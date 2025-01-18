import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:passkeys/authenticator.dart';
import 'package:passkeys/exceptions.dart';
import 'package:passkeys/types.dart';

/// Enum for authenticator transport types
enum AuthenticatorTransport {
  usb,
  nfc,
  ble,
  smartCard,
  hybrid,
  internal,
}

/// Descriptor for allowed credentials
class PublicKeyCredentialDescriptor {
  final String type;
  final String id;
  final List<AuthenticatorTransport>? transports;

  PublicKeyCredentialDescriptor({
    required this.type,
    required this.id,
    this.transports,
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


String base64StringToBase64UrlEncodedString(String input) { // TODO: replace with function from encoding library
  return input
      .replaceAll('+', '-')  // Replace '+' with '-'
      .replaceAll('/', '_')  // Replace '/' with '_'
      .replaceAll('=', '');  // Remove '=' padding
}


String generateChallenge() {
  final random = Random.secure();
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),  // 32 random bytes
  );
  return base64Url.encode(bytes).replaceAll('=', '');  // Base64URL without padding
}

/// Function to create a passkey
Future<Map<String, dynamic>> createPasskey(
  PasskeyRegistrationConfig config,
  {bool withSecurityKey = false, bool withPlatformKey = false}
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
      authenticatorAttachment: 'platform',
      residentKey: "required",
      userVerification: "preferred",
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

// /// Passkey Stamper class
// class PasskeyStamper {
//   final String rpId;
//   final int timeout;
//   final String userVerification;
//   final List<PublicKeyCredentialDescriptor> allowCredentials;
//   final bool forcePlatformKey;
//   final bool forceSecurityKey;
//   final Map<String, dynamic> extensions;

//   PasskeyStamper(TPasskeyStamperConfig config)
//       : rpId = config.rpId,
//         timeout = config.timeout ?? 300000,
//         userVerification = config.userVerification ?? 'preferred',
//         allowCredentials = config.allowCredentials ?? [],
//         forcePlatformKey = config.withPlatformKey ?? false,
//         forceSecurityKey = config.withSecurityKey ?? false,
//         extensions = config.extensions ?? {};

// }