import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';

String getChallengeFromPayload(String payload) {
  final digest = sha256.convert(utf8.encode(payload));
  final hexString = digest.toString();
  final utf8Bytes = utf8.encode(hexString);
  final base64String = base64Encode(utf8Bytes);

  return base64StringToBase64UrlEncodedString(base64String);
}

String generateChallenge() {
  final random = Random.secure();
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),
  );
  return base64Url.encode(bytes).replaceAll('=', '');
}
