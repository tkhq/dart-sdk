import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

String getChallengeFromPayload(String payload) {
  var bytes = utf8.encode(payload);
  var digest = sha256.convert(bytes);

  String hexString = digest.toString();

  Uint8List hexBytes = Uint8List.fromList(hexString.codeUnits);
  String base64String = base64Encode(hexBytes);

  return base64String;
}

String generateChallenge() {
  final random = Random.secure();
  final Uint8List bytes = Uint8List.fromList(
    List<int>.generate(32, (_) => random.nextInt(256)),
  );
  return base64Url.encode(bytes).replaceAll('=', '');
}
