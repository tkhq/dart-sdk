import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:turnkey_encoding/encoding.dart';

String getChallengeFromPayload(String payload) {
  final bytes =
      utf8.encode(payload); // Encode the string to bytes (UTF-8 encoding)
  final digest = sha256.convert(bytes); // Perform SHA-256 hash
  final hexString = digest.bytes;

  // Convert to Base64 string
  final base64String = base64.encode(hexString);

  // Convert Base64 string to Base64 URL encoded string
  final base64UrlString = base64StringToBase64UrlEncodedString(base64String);

  return base64UrlString;
}

String generateChallenge() {
  final random = Random.secure();
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),
  );
  return base64Url.encode(bytes).replaceAll('=', '');
}
