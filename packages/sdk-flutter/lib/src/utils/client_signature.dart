import 'dart:convert';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/utils/types.dart';

/// Used for building client signature payloads used in OTP authentication flows.
///
/// Client signatures provide two security guarantees:
/// 1. Only the owner of the public key in the verification token's claim can use the token
/// 2. The intent hasn't been tampered with and was directly approved by the key owner
class ClientSignature {
  /// Creates a client signature payload for login
  ///
  /// - Parameters:
  ///   - verificationToken: The JWT verification token to decode
  ///   - sessionPublicKey: Optional public key to use instead of the one in the token
  /// - Returns: A ClientSignaturePayload containing the message to sign and the public key for client signature
  /// - Throws: Exception if no public key is available
  static ClientSignaturePayload forLogin({
    required String verificationToken,
    String? sessionPublicKey,
  }) {
    final decoded = VerificationToken.fromJwt(verificationToken);

    if (decoded.publicKey == null || decoded.publicKey!.isEmpty) {
      throw Exception("Verification token is missing a public key");
    }

    // if a session publicKey was passed in then we use that
    // otherwise we default to the publicKey that lives inside the verificationToken
    final resolvedSessionPublicKey = sessionPublicKey ?? decoded.publicKey!;

    final usage = v1LoginUsage(publicKey: resolvedSessionPublicKey);
    final payload = v1TokenUsage(
      login: usage,
      tokenId: decoded.id,
      type: v1UsageType.usage_type_login,
    );

    final json = jsonEncode(payload.toJson());

    return ClientSignaturePayload(
      message: json,
      clientSignaturePublicKey: decoded.publicKey!,
    );
  }

  /// Creates a client signature payload for signup
  ///
  /// - Parameters:
  ///   - verificationToken: The JWT verification token to decode
  ///   - email: Optional email address
  ///   - phoneNumber: Optional phone number
  ///   - apiKeys: Optional array of API keys
  ///   - authenticators: Optional array of authenticators
  ///   - oauthProviders: Optional array of OAuth providers
  /// - Returns: A ClientSignaturePayload containing the message to sign and the public key for client signature
  /// - Throws: Exception if no public key is available in the token
  static ClientSignaturePayload forSignup({
    required String verificationToken,
    String? email,
    String? phoneNumber,
    List<v1ApiKeyParamsV2>? apiKeys,
    List<v1AuthenticatorParamsV2>? authenticators,
    List<v1OauthProviderParams>? oauthProviders,
  }) {
    final decoded = VerificationToken.fromJwt(verificationToken);

    if ( decoded.publicKey == null || decoded.publicKey!.isEmpty) {
      throw Exception("Verification token is missing a public key");
    }

    final usage = v1SignupUsage(
      apiKeys: apiKeys,
      authenticators: authenticators,
      email: email,
      oauthProviders: oauthProviders,
      phoneNumber: phoneNumber,
    );

    final payload = v1TokenUsage(
      signup: usage,
      tokenId: decoded.id,
      type: v1UsageType.usage_type_signup,
    );

    final json = jsonEncode(payload.toJson());

    return ClientSignaturePayload(
      message: json,
      clientSignaturePublicKey: decoded.publicKey!,
    );
  }
}