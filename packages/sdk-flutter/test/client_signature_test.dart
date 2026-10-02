import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/utils/client_signature.dart';
import 'package:turnkey_sdk_flutter/src/utils/types.dart';

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

Map<String, dynamic> _payload(ClientSignaturePayload signature) =>
    jsonDecode(signature.message) as Map<String, dynamic>;

void main() {
  group('ClientSignature.forLoginV2', () {
    test('requires a concrete target organization ID', () {
      expect(
        () => ClientSignature.forLoginV2(
          verificationToken: _verificationToken(),
          organizationId: '',
        ),
        throwsArgumentError,
      );
    });

    test('binds WalletKit-configured expiration and optional values', () {
      const authConfig = RuntimeAuthConfig(sessionExpirationSeconds: '7200');

      final payload = _payload(ClientSignature.forLoginV2(
        verificationToken: _verificationToken(),
        organizationId: 'org-id',
        invalidateExisting: false,
        expirationSeconds: authConfig.sessionExpirationSeconds,
        sessionProfileId: 'profile-id',
      ));
      final usage = payload['loginV2'] as Map<String, dynamic>;

      expect(usage['organizationId'], 'org-id');
      expect(usage['publicKey'], 'public-key');
      expect(usage['invalidateExisting'], isFalse);
      expect(usage['expirationSeconds'], authConfig.sessionExpirationSeconds);
      expect(usage['sessionProfileId'], 'profile-id');
    });

    test('preserves optional field absence', () {
      final usage = _payload(ClientSignature.forLoginV2(
        verificationToken: _verificationToken(),
        organizationId: 'org-id',
      ))['loginV2'] as Map<String, dynamic>;

      expect(usage.containsKey('invalidateExisting'), isFalse);
      expect(usage.containsKey('expirationSeconds'), isFalse);
      expect(usage.containsKey('sessionProfileId'), isFalse);
    });

    test('matches the final OTP login request semantics', () {
      final payload = ClientSignature.forLoginV2(
        verificationToken: _verificationToken(),
        organizationId: 'org-id',
        invalidateExisting: true,
        expirationSeconds: '7200',
      );
      final request = ProxyTOtpLoginV2Body(
        verificationToken: _verificationToken(),
        publicKey: payload.clientSignaturePublicKey,
        clientSignature: v1ClientSignature(
          message: payload.message,
          publicKey: payload.clientSignaturePublicKey,
          scheme: v1ClientSignatureScheme.client_signature_scheme_api_p256,
          signature: 'signature',
        ),
        organizationId: 'org-id',
        invalidateExisting: true,
      );
      final usage = _payload(payload)['loginV2'] as Map<String, dynamic>;

      expect(usage['organizationId'], request.organizationId);
      expect(usage['publicKey'], request.publicKey);
      expect(usage['invalidateExisting'], request.invalidateExisting);
      expect(usage['expirationSeconds'], '7200');
    });
  });

  group('ClientSignature.forSignupV3', () {
    test('matches the final OTP signup request semantics', () {
      final signup = ProxyTSignupV2Body(
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
      final usage = _payload(ClientSignature.forSignupV3(
        verificationToken: _verificationToken(),
        parentOrganizationId: 'provider-org-id',
        signup: signup,
      ))['signupV3'] as Map<String, dynamic>;
      final rootUser =
          (usage['rootUsers'] as List<dynamic>).single as Map<String, dynamic>;

      expect(usage['parentOrganizationId'], 'provider-org-id');
      expect(usage['subOrganizationName'], signup.organizationName);
      expect(usage['rootQuorumThreshold'], 1);
      expect(rootUser['userName'], signup.userName);
      expect(rootUser['userEmail'], signup.userEmail);
      expect(rootUser['userPhoneNumber'], signup.userPhoneNumber);
      expect(rootUser['apiKeys'], isEmpty);
      expect(rootUser['authenticators'], isEmpty);
      expect(rootUser['oauthProviders'], isEmpty);
      expect(usage['wallet'], signup.wallet?.toJson());
    });

    test('rejects unresolved strict signup values', () {
      expect(
        () => ClientSignature.forSignupV3(
          verificationToken: _verificationToken(),
          parentOrganizationId: '',
          signup: ProxyTSignupV2Body(
            apiKeys: const [],
            authenticators: const [],
            oauthProviders: const [],
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
