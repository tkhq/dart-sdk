// Convert a hex string to Uint8List, used for running tests
import 'dart:convert';
import 'dart:typed_data';
import 'package:encoding/encoding.dart';
import 'package:pointycastle/export.dart';
import 'crypto_base.dart';


/// Simple HMAC-SHA256 function.
Uint8List hmacSha256(Uint8List key, Uint8List data) {
  final hmac = HMac(SHA256Digest(), 64);
  hmac.init(KeyParameter(key));
  return hmac.process(data);
}

/// HKDF-extract (JS: `extract(sha256, ikm, salt)`).
/// If [salt] is null, uses a zeroed array of length 32 (SHA-256 digest size).
Uint8List hkdfExtract(Uint8List ikm, [Uint8List? salt]) {
  const hashLen = 32; // for SHA-256
  final usedSalt = salt ?? Uint8List(hashLen);
  return hmacSha256(usedSalt, ikm);
}

/// HKDF-expand (JS: `expand(sha256, prk, info, len)`).
/// Produces [length] bytes of output key material.
/// If [info] is null, uses an empty array.
Uint8List hkdfExpand(Uint8List prk, [Uint8List? info, int length = 32]) {
  const hashLen = 32; // for SHA-256
  if (length > 255 * hashLen) {
    throw ArgumentError('length cannot exceed 255 * hashLen');
  }
  final usedInfo = info ?? Uint8List(0);
  final blocks = (length + hashLen - 1) ~/ hashLen;

  final okm = Uint8List(blocks * hashLen);
  Uint8List tBlock = Uint8List(0);

  for (int i = 0; i < blocks; i++) {
    // T(i) = HMAC-Hash(prk, T(i-1) || info || counter)
    final buffer = Uint8List(tBlock.length + usedInfo.length + 1);
    buffer.setAll(0, tBlock);
    buffer.setAll(tBlock.length, usedInfo);
    buffer[buffer.length - 1] = i + 1; // counter
    tBlock = hmacSha256(prk, buffer);
    okm.setAll(i * hashLen, tBlock);
  }
  return okm.sublist(0, length);
}

/// Convert a BigInt to a fixed-length Uint8List.
Uint8List bigIntToFixedLength(BigInt value, int length) {
  final bytes =
      value.toUnsigned(8 * length).toRadixString(16).padLeft(length * 2, '0');
  final result = Uint8List(length);
  for (int i = 0; i < length; i++) {
    result[i] = int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return result;
}

/// Formats an HPKE buffer into a JSON string with the encapsulated public key and ciphertext.
///
/// - [encryptedBuf]: The result of `hpkeAuthEncrypt` or `hpkeEncrypt` as a `Uint8List`.
///
/// Returns:
/// - A JSON string with "encappedPublic" and "ciphertext".
String formatHpkeBuf(Uint8List encryptedBuf) {
  final compressedSenderBuf = encryptedBuf.sublist(0, 33);
  final encryptedData = encryptedBuf.sublist(33);

  final encappedKeyBufHex = uint8ArrayToHexString(
    uncompressRawPublicKey(compressedSenderBuf),
  );

  final ciphertextHex = uint8ArrayToHexString(encryptedData);

  return jsonEncode({
    'encappedPublic': encappedKeyBufHex,
    'ciphertext': ciphertextHex,
  });
}
