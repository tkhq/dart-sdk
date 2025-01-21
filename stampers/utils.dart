import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

final stampHeaderName = "X-Stamp";

String getChallengeFromPayload(String payload) {
  final bytes = utf8.encode(payload);
  final digest = sha256.convert(bytes);
  final hexString = digest.bytes;

  final base64String = base64.encode(hexString);
  return base64String;
}

String generateChallenge() {
  final random = Random.secure();
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),  // 32 random bytes
  );
  return base64Url.encode(bytes).replaceAll('=', '');  // Base64URL without padding
}
