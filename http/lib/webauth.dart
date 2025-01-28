import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import '__generated__/services/coordinator/v1/public_api.swagger.dart';

typedef TWebAuthnStamp = V1WebAuthnStamp;
typedef TAttestation = V1Attestation;

typedef ExternalAuthenticatorTransports = String;
typedef InternalAuthenticatorTransports = V1AuthenticatorTransport;

// Constants
const int defaultTimeout = 5 * 60 * 1000; // Five minutes in milliseconds
const String defaultUserVerification = "preferred";

const defaultSigningOptions = (
  publicKey: (
    timeout: defaultTimeout,
    userVerification: defaultUserVerification,
  ),
);

Future<Uint8List> getChallengeFromPayload(String payload) async {
  // Encode the payload into bytes
  final List<int> messageBytes = utf8.encode(payload);

  // Compute the SHA-256 hash
  final Digest hash = sha256.convert(messageBytes);

  // Convert the hash to a hex string
  final String hexString =
      hash.bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  // Convert the hex string to bytes and return as Uint8List
  return Uint8List.fromList(utf8.encode(hexString));
}

// Dart equivalent of TurnkeyPublicKeyCredentialRequestOptions
class TurnkeyPublicKeyCredentialRequestOptions {
  final int? timeout;
  final String? rpId;
  final List<PublicKeyCredentialDescriptor>? allowCredentials;
  final String? userVerification;
  final Map<String, dynamic>? extensions;

  TurnkeyPublicKeyCredentialRequestOptions({
    this.timeout,
    this.rpId,
    this.allowCredentials,
    this.userVerification,
    this.extensions,
  });
}

// Dart equivalent of TurnkeyCredentialRequestOptions
class TurnkeyCredentialRequestOptions {
  final String? mediation;
  final TurnkeyPublicKeyCredentialRequestOptions publicKey;
  final AbortSignal? signal;
  final bool? password;
  final bool? unmediated;

  TurnkeyCredentialRequestOptions({
    this.mediation,
    required this.publicKey,
    this.signal,
    this.password,
    this.unmediated,
  });
}

// Dart doesn't have a built-in AbortSignal class, so we define a similar one here
class AbortSignal {
  final Completer<void> _abortCompleter = Completer<void>();

  /// Whether the signal has been aborted
  bool get aborted => _abortCompleter.isCompleted;

  /// A [Future] that completes when the signal is aborted
  Future<void> get onAbort => _abortCompleter.future;

  /// Abort the signal
  void abort() {
    if (!_abortCompleter.isCompleted) {
      _abortCompleter.complete();
    }
  }
}

enum AuthenticatorTransport {
  ble,
  hybrid,
  internal,
  nfc,
  usb,
}

enum PublicKeyCredentialType {
  publicKey,
}

// Dart doesn't have a built-in PublicKeyCredentialDescriptor class, so we define a similar one here
class PublicKeyCredentialDescriptor {
  final ByteBuffer id;
  final List<AuthenticatorTransport>? transports;
  final PublicKeyCredentialType type;

  PublicKeyCredentialDescriptor({
    required this.id,
    this.transports,
    required this.type,
  });
}

//TODO: add types
Future<dynamic> getCredentialRequestOptions(String payload) async {
  final challenge = await getChallengeFromPayload(payload);

  final signingOptions = (
    publicKey: <String, dynamic>{
      ...defaultSigningOptions.publicKey as Map<String, dynamic>,
      'challenge': challenge,
    },
  );

  return signingOptions;
}

Future<String> getWebAuthnAssertion(String payload) async {
  final signingOptions = await getCredentialRequestOptions(payload);
  final clientGetResult = await webauthnCredentialGet(signingOptions);
  final assertion = clientGetResult.toJson();

  final TWebAuthnStamp stamp = TWebAuthnStamp(
    authenticatorData: assertion['response']['authenticatorData'],
    clientDataJson: assertion['response']['clientDataJSON'],
    credentialId: assertion['id'],
    signature: assertion['response']['signature'],
  );

  return jsonEncode(stamp.toJson());
}
