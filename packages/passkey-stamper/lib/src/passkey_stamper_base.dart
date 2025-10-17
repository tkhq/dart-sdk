import 'dart:convert';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_http/base.dart';

import 'utils.dart';

class Stamp {
  final String authenticatorData;
  final String clientDataJson;
  final String credentialId;
  final String signature;

  const Stamp({
    required this.authenticatorData,
    required this.clientDataJson,
    required this.credentialId,
    required this.signature,
  });
}

class RelyingParty {
  final String id;
  final String name;

  const RelyingParty({
    required this.id,
    required this.name,
  });
}

class WebAuthnUser {
  final String id;
  final String name;
  final String displayName;

  const WebAuthnUser({
    required this.id,
    required this.name,
    required this.displayName,
  });
}

// See more details on the registration config here: https://webauthn.guide/#registration
class PasskeyRegistrationConfig {
  final RelyingParty rp;
  final WebAuthnUser user;
  final String? challenge; // Optional challenge
  final int? timeout; // Optional timeout in milliseconds
  final List<CredentialType>? excludeCredentials; // Credentials to exclude
  final String? attestation; // Attestation type: none, direct, indirect
  final AuthenticatorSelectionType?
      authenticatorSelection; // Authenticator selection criteria
  final String? authenticatorName; // Optional authenticator name

  const PasskeyRegistrationConfig({
    required this.rp,
    required this.user,
    this.challenge,
    this.timeout,
    this.excludeCredentials,
    this.attestation,
    this.authenticatorSelection,
    this.authenticatorName,
  });
}

class PasskeyStamperConfig {
  final String rpId;
  final int? timeout;
  final String? userVerification;
  final List<CredentialType>? allowCredentials;
  final MediationType? mediation;
  final bool? preferImmediatelyAvailableCredentials;

  const PasskeyStamperConfig({
    required this.rpId,
    this.timeout,
    this.userVerification,
    this.allowCredentials,
    this.mediation,
    this.preferImmediatelyAvailableCredentials,
  });
}

class CreatePasskeyResult {
  final v1Attestation attestation;
  final String encodedChallenge;
  final String? authenticatorName;

  const CreatePasskeyResult({
    required this.attestation,
    required this.encodedChallenge,
    this.authenticatorName,
  });
}

Future<CreatePasskeyResult> createPasskey(
  PasskeyRegistrationConfig config,
) async {
  final String challenge = config.challenge ?? generateChallenge();

  // Encode userId to base64url-safe value
  final String userId =
      base64Url.encode(utf8.encode(config.user.id)).replaceAll('=', '');

  final authenticator = PasskeyAuthenticator();

  final options = RegisterRequestType(
    relyingParty: RelyingPartyType(
      name: config.rp.name,
      id: config.rp.id,
    ),
    user: UserType(
      displayName: config.user.displayName,
      name: config.user.name,
      id: userId,
    ),
    timeout: config.timeout ?? 300000,
    challenge: challenge,
    excludeCredentials: config.excludeCredentials ?? [],
    pubKeyCredParams: [
      PubKeyCredParamType(type: "public-key", alg: -7),
      PubKeyCredParamType(type: "public-key", alg: -257),
    ],
    attestation: config.attestation ?? 'none',
    authSelectionType: config.authenticatorSelection ??
        AuthenticatorSelectionType(
          requireResidentKey: true,
          authenticatorAttachment: "platform",
          residentKey: "required",
          userVerification: "preferred",
        ),
  );

  final credential = await authenticator.register(options);

  final attestation = v1Attestation(
    credentialId: base64StringToBase64UrlEncodedString(credential.id),
    clientDataJson:
        base64StringToBase64UrlEncodedString(credential.clientDataJSON),
    attestationObject:
        base64StringToBase64UrlEncodedString(credential.attestationObject),
    transports: [v1AuthenticatorTransport.authenticator_transport_hybrid],
  );

  return CreatePasskeyResult(
    attestation: attestation,
    encodedChallenge: challenge,
    authenticatorName: config.authenticatorName,
  );
}

// Passkey Stamper class
class PasskeyStamper implements TStamper {
  final String rpId;
  final int timeout;
  final String userVerification;
  final List<CredentialType> allowCredentials;
  final MediationType mediation;
  final bool preferImmediatelyAvailableCredentials;

  PasskeyStamper(PasskeyStamperConfig config)
      : rpId = config.rpId,
        timeout = config.timeout ?? 300000,
        userVerification = config.userVerification ?? 'preferred',
        allowCredentials = config.allowCredentials ?? const [],
        mediation = config.mediation ?? MediationType.Silent,
        preferImmediatelyAvailableCredentials =
            config.preferImmediatelyAvailableCredentials ?? true;

  final stampHeaderName = "X-Stamp-Webauthn";

  @override
  Future<TStamp> stamp(String payload) async {
    final challenge = getChallengeFromPayload(payload);

    final authenticator = PasskeyAuthenticator();

    final signingOptions = AuthenticateRequestType(
      challenge: challenge,
      mediation: mediation,
      relyingPartyId: rpId,
      timeout: timeout,
      allowCredentials: allowCredentials,
      userVerification: userVerification,
      preferImmediatelyAvailableCredentials:
          preferImmediatelyAvailableCredentials,
    );

    final authenticationResult =
        await authenticator.authenticate(signingOptions);

    final stamp = {
      "authenticatorData": base64StringToBase64UrlEncodedString(
          authenticationResult.authenticatorData),
      "clientDataJson": base64StringToBase64UrlEncodedString(
          authenticationResult.clientDataJSON),
      "credentialId":
          base64StringToBase64UrlEncodedString(authenticationResult.id),
      "signature":
          base64StringToBase64UrlEncodedString(authenticationResult.signature),
    };

    return TStamp(
      stampHeaderName: stampHeaderName,
      stampHeaderValue: jsonEncode(stamp),
    );
  }
}
