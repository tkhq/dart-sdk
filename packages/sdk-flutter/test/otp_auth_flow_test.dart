import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/internal/otp_auth_flow.dart';

String _verificationToken() {
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({
        'contact': 'user@example.com',
        'exp': 1,
        'id': 'token-id',
        'public_key': 'public-key',
        'verification_type': 'OTP',
        'organization_id': 'token-org',
      })))
      .replaceAll('=', '');
  return 'header.$payload.signature';
}

ProxyTGetWalletKitConfigResponse _walletKitConfig({
  required String organizationId,
  String expirationSeconds = '7200',
}) {
  return ProxyTGetWalletKitConfigResponse(
    enabledProviders: const [],
    sessionExpirationSeconds: expirationSeconds,
    organizationId: organizationId,
  );
}

class _FakeOtpAuthProxyClient implements OtpAuthProxyClient {
  final Future<ProxyTGetWalletKitConfigResponse?> Function() _getConfig;
  ProxyTOtpLoginV2Body? loginRequest;
  ProxyTSignupV2Body? signupRequest;
  int configRequests = 0;
  int loginRequests = 0;
  int signupRequests = 0;

  _FakeOtpAuthProxyClient({
    required Future<ProxyTGetWalletKitConfigResponse?> Function() getConfig,
  }) : _getConfig = getConfig;

  @override
  Future<ProxyTGetWalletKitConfigResponse?> getWalletKitConfig() async {
    configRequests++;
    return await _getConfig();
  }

  @override
  Future<ProxyTOtpLoginV2Response> otpLoginV2(
      ProxyTOtpLoginV2Body input) async {
    loginRequest = input;
    loginRequests++;
    return const ProxyTOtpLoginV2Response(session: 'session');
  }

  @override
  Future<ProxyTSignupV2Response> signupV2(ProxyTSignupV2Body input) async {
    signupRequest = input;
    signupRequests++;
    return const ProxyTSignupV2Response(
      organizationId: 'created-org',
      userId: 'user-id',
    );
  }
}

OtpAuthFlow _flow(_FakeOtpAuthProxyClient client) {
  return OtpAuthFlow(
    client: client,
    sign: (message, publicKey) async {
      expect(publicKey, 'public-key');
      return 'signature';
    },
  );
}

Map<String, dynamic> _signedUsage(v1ClientSignature signature) {
  return jsonDecode(signature.message) as Map<String, dynamic>;
}

void main() {
  group('OtpAuthFlow.loginWithOtp', () {
    test('sends a strict request matching authoritative configuration',
        () async {
      final client = _FakeOtpAuthProxyClient(
        getConfig: () async => _walletKitConfig(organizationId: 'parent-org'),
      );

      await _flow(client).loginWithOtp(
        verificationToken: _verificationToken(),
        organizationId: 'target-org',
        invalidateExisting: true,
      );

      final request = client.loginRequest!;
      final usage = _signedUsage(request.clientSignature)['loginV2']
          as Map<String, dynamic>;
      expect(usage['organizationId'], request.organizationId);
      expect(usage['publicKey'], request.publicKey);
      expect(usage['invalidateExisting'], request.invalidateExisting);
      expect(usage['expirationSeconds'], '7200');
    });

    test('uses legacy semantics when configuration is unavailable', () async {
      final client = _FakeOtpAuthProxyClient(getConfig: () async => null);

      await _flow(client).loginWithOtp(
        verificationToken: _verificationToken(),
        organizationId: 'target-org',
        invalidateExisting: true,
      );

      final usage = _signedUsage(client.loginRequest!.clientSignature);
      expect(usage.containsKey('loginV2'), isFalse);
      expect(usage['login'], {'publicKey': 'public-key'});
    });

    test('keeps the captured provider through signing and send', () async {
      late _FakeOtpAuthProxyClient activeClient;
      final providerB = _FakeOtpAuthProxyClient(
        getConfig: () async => _walletKitConfig(organizationId: 'provider-b'),
      );
      final providerA = _FakeOtpAuthProxyClient(
        getConfig: () async {
          activeClient = providerB;
          return _walletKitConfig(organizationId: 'provider-a');
        },
      );
      activeClient = providerA;
      final flow = _flow(activeClient);

      await flow.loginWithOtp(
        verificationToken: _verificationToken(),
        organizationId: 'target-org',
        invalidateExisting: false,
      );

      expect(identical(activeClient, providerB), isTrue);
      expect(providerA.loginRequests, 1);
      expect(providerB.loginRequests, 0);
    });
  });

  group('OtpAuthFlow.signUpWithOtp', () {
    test('keeps strict signup and follow-up login on one provider', () async {
      late _FakeOtpAuthProxyClient activeClient;
      final providerB = _FakeOtpAuthProxyClient(
        getConfig: () async => _walletKitConfig(organizationId: 'provider-b'),
      );
      final client = _FakeOtpAuthProxyClient(
        getConfig: () async {
          activeClient = providerB;
          return _walletKitConfig(organizationId: 'parent-org');
        },
      );
      activeClient = client;
      final signUpBody = ProxyTSignupV2Body(
        userEmail: 'user@example.com',
        userPhoneNumber: '+15555550123',
        userName: 'User Name',
        organizationName: 'Sub Organization',
        verificationToken: _verificationToken(),
        apiKeys: const [],
        authenticators: const [],
        oauthProviders: const [],
        wallet: const v1WalletParams(walletName: 'Wallet', accounts: []),
      );

      await _flow(activeClient).signUpWithOtp(
        verificationToken: _verificationToken(),
        signUpBody: signUpBody,
        invalidateExisting: true,
      );

      final signupRequest = client.signupRequest!;
      final signupUsage =
          _signedUsage(signupRequest.clientSignature!)['signupV3']
              as Map<String, dynamic>;
      final rootUser = (signupUsage['rootUsers'] as List<dynamic>).single
          as Map<String, dynamic>;
      expect(signupUsage['parentOrganizationId'], 'parent-org');
      expect(
          signupUsage['subOrganizationName'], signupRequest.organizationName);
      expect(signupUsage['rootQuorumThreshold'], 1);
      expect(signupUsage['wallet'], signupRequest.wallet?.toJson());
      expect(rootUser['userName'], signupRequest.userName);
      expect(rootUser['apiKeys'], signupRequest.apiKeys.map((e) => e.toJson()));
      expect(rootUser['authenticators'],
          signupRequest.authenticators.map((e) => e.toJson()));
      expect(rootUser['oauthProviders'],
          signupRequest.oauthProviders.map((e) => e.toJson()));

      final loginUsage =
          _signedUsage(client.loginRequest!.clientSignature)['loginV2']
              as Map<String, dynamic>;
      expect(identical(activeClient, providerB), isTrue);
      expect(client.configRequests, 1);
      expect(client.signupRequests, 1);
      expect(client.loginRequests, 1);
      expect(providerB.signupRequests, 0);
      expect(providerB.loginRequests, 0);
      expect(loginUsage['organizationId'], 'created-org');
      expect(loginUsage['expirationSeconds'], '7200');
    });

    test('uses legacy signup and login semantics without configuration',
        () async {
      final client = _FakeOtpAuthProxyClient(getConfig: () async => null);
      final signUpBody = ProxyTSignupV2Body(
        userName: 'User Name',
        organizationName: 'Sub Organization',
        verificationToken: _verificationToken(),
        apiKeys: const [],
        authenticators: const [],
        oauthProviders: const [],
      );

      await _flow(client).signUpWithOtp(
        verificationToken: _verificationToken(),
        signUpBody: signUpBody,
        invalidateExisting: false,
      );

      final signupUsage = _signedUsage(client.signupRequest!.clientSignature!);
      final loginUsage = _signedUsage(client.loginRequest!.clientSignature);
      expect(client.configRequests, 1);
      expect(signupUsage.containsKey('signupV3'), isFalse);
      expect(signupUsage.containsKey('signupV2'), isTrue);
      expect(loginUsage.containsKey('loginV2'), isFalse);
      expect(loginUsage.containsKey('login'), isTrue);
    });
  });
}
