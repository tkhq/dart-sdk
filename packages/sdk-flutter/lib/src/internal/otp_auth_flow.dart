import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/utils/client_signature.dart';

abstract interface class OtpAuthProxyClient {
  Future<ProxyTGetWalletKitConfigResponse?> getWalletKitConfig();

  Future<ProxyTOtpLoginV2Response> otpLoginV2(
    ProxyTOtpLoginV2Body input,
  );

  Future<ProxyTSignupV2Response> signupV2(
    ProxyTSignupV2Body input,
  );
}

typedef OtpAuthSigner = Future<String> Function(
    String message, String publicKey);

/// Executes an OTP auth flow against one captured auth-proxy client.
///
/// The caller constructs this flow from its active client snapshot. Every
/// configuration fetch and proxy request then uses that same client.
class OtpAuthFlow {
  final OtpAuthProxyClient _client;
  final OtpAuthSigner _sign;

  const OtpAuthFlow({
    required OtpAuthProxyClient client,
    required OtpAuthSigner sign,
  })  : _client = client,
        _sign = sign;

  Future<String> loginWithOtp({
    required String verificationToken,
    required String? organizationId,
    required bool invalidateExisting,
  }) async {
    return _loginWithOtp(
      verificationToken: verificationToken,
      organizationId: organizationId,
      invalidateExisting: invalidateExisting,
      walletKitConfig: await _client.getWalletKitConfig(),
    );
  }

  Future<String> _loginWithOtp({
    required String verificationToken,
    required String? organizationId,
    required bool invalidateExisting,
    required ProxyTGetWalletKitConfigResponse? walletKitConfig,
  }) async {
    final expirationSeconds = walletKitConfig?.sessionExpirationSeconds;
    final useStrictUsage = organizationId?.isNotEmpty == true &&
        expirationSeconds?.isNotEmpty == true;
    final payload = useStrictUsage
        ? ClientSignature.forLoginV2(
            verificationToken: verificationToken,
            organizationId: organizationId!,
            invalidateExisting: invalidateExisting,
            expirationSeconds: expirationSeconds,
          )
        : ClientSignature.forLogin(verificationToken: verificationToken);
    final signature = await _sign(
      payload.message,
      payload.clientSignaturePublicKey,
    );

    if (signature.isEmpty) {
      throw Exception('Failed to create client signature on OTP login');
    }

    final response = await _client.otpLoginV2(
      ProxyTOtpLoginV2Body(
        verificationToken: verificationToken,
        publicKey: payload.clientSignaturePublicKey,
        clientSignature: v1ClientSignature(
          message: payload.message,
          publicKey: payload.clientSignaturePublicKey,
          scheme: v1ClientSignatureScheme.client_signature_scheme_api_p256,
          signature: signature,
        ),
        invalidateExisting: invalidateExisting,
        organizationId: organizationId,
      ),
    );

    if (response.session.isEmpty) {
      throw Exception('No session returned from OTP login');
    }

    return response.session;
  }

  Future<String> signUpWithOtp({
    required String verificationToken,
    required ProxyTSignupV2Body signUpBody,
    required bool invalidateExisting,
  }) async {
    final walletKitConfig = await _client.getWalletKitConfig();
    final parentOrganizationId = walletKitConfig?.organizationId;
    final payload = parentOrganizationId?.isNotEmpty == true
        ? ClientSignature.forSignupV3(
            verificationToken: verificationToken,
            parentOrganizationId: parentOrganizationId!,
            signup: signUpBody,
          )
        : ClientSignature.forSignup(
            verificationToken: verificationToken,
            email: signUpBody.userEmail,
            phoneNumber: signUpBody.userPhoneNumber,
            apiKeys: signUpBody.apiKeys,
            authenticators: signUpBody.authenticators,
            oauthProviders: signUpBody.oauthProviders,
          );
    final signature = await _sign(
      payload.message,
      payload.clientSignaturePublicKey,
    );

    if (signature.isEmpty) {
      throw Exception('Failed to create client signature on OTP signup');
    }

    final signUpResponse = await _client.signupV2(
      ProxyTSignupV2Body(
        userEmail: signUpBody.userEmail,
        userPhoneNumber: signUpBody.userPhoneNumber,
        userTag: signUpBody.userTag,
        userName: signUpBody.userName,
        organizationName: signUpBody.organizationName,
        verificationToken: signUpBody.verificationToken,
        apiKeys: signUpBody.apiKeys,
        authenticators: signUpBody.authenticators,
        oauthProviders: signUpBody.oauthProviders,
        wallet: signUpBody.wallet,
        clientSignature: v1ClientSignature(
          message: payload.message,
          publicKey: payload.clientSignaturePublicKey,
          scheme: v1ClientSignatureScheme.client_signature_scheme_api_p256,
          signature: signature,
        ),
      ),
    );

    if (signUpResponse.organizationId.isEmpty) {
      throw Exception('Auth proxy OTP sign up failed');
    }

    return _loginWithOtp(
      verificationToken: verificationToken,
      organizationId: signUpResponse.organizationId,
      invalidateExisting: invalidateExisting,
      walletKitConfig: walletKitConfig,
    );
  }
}
