import 'dart:convert';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/types.dart';

import 'types.dart';
import 'utils.dart';


/// Enum for authenticator transport types
enum AuthenticatorTransport {
  usb,
  nfc,
  ble,
  smartCard,
  hybrid,
  internal,
}

class Stamp {
  final String authenticatorData;
  final String clientDataJson;
  final String credentialId;
  final String signature;

  Stamp({
    required this.authenticatorData,
    required this.clientDataJson,
    required this.credentialId,
    required this.signature,
  });
}


class PasskeyRegistrationConfig {
  final Map<String, String> rp; // Relying party details: {name, id}
  final Map<String, String> user; // User details: {displayName, name, id}
  final String? challenge; // Optional challenge
  final int? timeout; // Optional timeout in milliseconds
  final List<CredentialType>? excludeCredentials; // Credentials to exclude
  final String? attestation; // Attestation type: none, direct, indirect
  final AuthenticatorSelectionType? authenticatorSelection; // Authenticator selection criteria
  final String? authenticatorName; // Optional authenticator name

  PasskeyRegistrationConfig({
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
  // The RPID ("Relying Party ID") for your app.
  // See https://github.com/f-23/react-native-passkey?tab=readme-ov-file#configuration to set this up.
  final String rpId;

  // Optional timeout value in milliseconds. Defaults to 5 minutes.
  final int? timeout;

  final String? userVerification;

  // Optional list of credentials to pass. Defaults to empty.
  final List<CredentialType>? allowCredentials;

  // Option to force security passkeys on native platforms
  final bool? withSecurityKey;

  // Option to force platform passkeys on native platforms
  final bool? withPlatformKey;

  // Optional extensions. Defaults to empty.
  final Map<String, dynamic>? extensions;

  final MediationType? mediation;

  final bool? preferImmediatelyAvailableCredentials;

  PasskeyStamperConfig({required this.rpId, this.timeout, this.userVerification, this.allowCredentials, this.withSecurityKey, this.withPlatformKey, this.mediation, this.preferImmediatelyAvailableCredentials, this.extensions});

}

String base64StringToBase64UrlEncodedString(String input) { // TODO: replace with function from encoding library
  return input
      .replaceAll('+', '-')  // Replace '+' with '-'
      .replaceAll('/', '_')  // Replace '/' with '_'
      .replaceAll('=', '');  // Remove '=' padding
}



/// Function to create a passkey
Future<Map<String, dynamic>> createPasskey(
  PasskeyRegistrationConfig config,
  {bool withSecurityKey = false, bool withPlatformKey = false}  // TODO: Support for security key and platform key
) async {
  final String challenge = config.challenge ?? generateChallenge();

final String userId = base64Url.encode(utf8.encode(config.user['id']!)).replaceAll('=', '');

  final authenticator = PasskeyAuthenticator();
  
  final options = RegisterRequestType(
    relyingParty: RelyingPartyType(name: config.rp['name']!, id: config.rp['id']!),
    user: UserType(displayName: config.user['displayName']!, name: config.user['name']!, id: userId),
    timeout: config.timeout ?? 300000,
    challenge: challenge,
    excludeCredentials: config.excludeCredentials ?? [],
    pubKeyCredParams: [PubKeyCredParamType(type: "public-key", alg: -7), PubKeyCredParamType(type: "public-key", alg: -257)],
    attestation: config.attestation ?? 'none',
    authSelectionType: config.authenticatorSelection ?? AuthenticatorSelectionType(
      requireResidentKey: true,
      authenticatorAttachment: "platform",
      residentKey: "required",
      userVerification: "preferred"
    ),
  );

  final credential = await authenticator.register(options);

  return {
    'authenticatorName': config.authenticatorName,
    'challenge': challenge,
    'attestation': {
      'credentialId': base64StringToBase64UrlEncodedString(credential.rawId),
      'clientDataJson': base64StringToBase64UrlEncodedString(credential.clientDataJSON),
      'attestationObject': base64StringToBase64UrlEncodedString(credential.attestationObject),
      'transports': ["AUTHENTICATOR_TRANSPORT_HYBRID"],
    },
  };
}



/// Passkey Stamper class
class PasskeyStamper {
  final String rpId;
  final int timeout;
  final String userVerification;
  final List<CredentialType> allowCredentials;
  final bool forcePlatformKey;
  final bool forceSecurityKey;
  final MediationType mediation;
  final bool preferImmediatelyAvailableCredentials;
  final Map<String, dynamic> extensions;
  

  PasskeyStamper(PasskeyStamperConfig config)
      : rpId = config.rpId,
        timeout = config.timeout ?? 300000,
        userVerification = config.userVerification ?? 'preferred',
        allowCredentials = config.allowCredentials ?? [],
        forcePlatformKey = config.withPlatformKey ?? false, //TODO: Allow for platform key
        forceSecurityKey = config.withSecurityKey ?? false, //TODO: Allow for security key
        mediation = config.mediation ?? MediationType.Silent,
        preferImmediatelyAvailableCredentials = config.preferImmediatelyAvailableCredentials ?? true,
        extensions = config.extensions ?? {};

  final stampHeaderName = "X-Stamp";


  Future<StampReturnType> stamp(String payload) async {
    final challenge = getChallengeFromPayload(payload);

    final authenticator = PasskeyAuthenticator(); //TODO: Is it ok to create another authenticator object here?

    final signingOptions = AuthenticateRequestType(
      challenge: challenge,
      mediation: mediation,
      relyingPartyId: rpId,
      timeout: timeout,
      allowCredentials: allowCredentials,
      userVerification: userVerification, 
      preferImmediatelyAvailableCredentials: preferImmediatelyAvailableCredentials,
    );

    var authenticationResult = await authenticator.authenticate(signingOptions);

    var stamp = {
      "authenticatorData": base64StringToBase64UrlEncodedString(
        authenticationResult.authenticatorData
      ),
      "clientDataJson": base64StringToBase64UrlEncodedString(
        authenticationResult.clientDataJSON
      ),
      "credentialId": base64StringToBase64UrlEncodedString(authenticationResult.id),
      "signature": base64StringToBase64UrlEncodedString(authenticationResult.signature),
    };

    return StampReturnType(
      stampHeaderName: stampHeaderName,
      stampHeaderValue: jsonEncode(stamp),
    );
  }
}