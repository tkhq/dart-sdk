
import 'dart:typed_data';
import 'helper.dart';
import 'math.dart';
import 'package:encoding/encoding.dart';
import 'package:pointycastle/export.dart';



/**
 * Convert a BigInt to a hexadecimal string of a specific length.
 */
String bigIntToHex(BigInt num, int length) {
  final hexString = num.toRadixString(16);
  if (hexString.length > length) {
    throw ArgumentError(
        'Number cannot fit in a hex string of $length characters');
  }
  return hexString.padLeft(length, '0');
}


/**
 * Uncompress a raw public key.
 */
Uint8List uncompressRawPublicKey(Uint8List rawPublicKey) {
  // point[0] must be 2 (false) or 3 (true).
  // this maps to the initial "02" or "03" prefix
  final lsb = rawPublicKey[0] == 3;
  final x = BigInt.parse(uint8ArrayToHexString(rawPublicKey.sublist(1)), radix: 16);

  // https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.186-4.pdf (Appendix D).
  final p = BigInt.parse(
      "115792089210356248762697446949407573530086143415290314195533631308867097853951");
  final b = BigInt.parse(
      "5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b",
      radix: 16);
  final a = p - BigInt.from(3);

  // Now compute y based on x
  final rhs = ((x * x + a) * x + b) % p;
  BigInt y = modSqrt(rhs, p);
  if (lsb != testBit(y, 0)) {
    y = (p - y) % p;
  }

  if (x < BigInt.zero || x >= p) {
    throw ArgumentError("x is out of range");
  }
  if (y < BigInt.zero || y >= p) {
    throw ArgumentError("y is out of range");
  }

  final uncompressedHexString = "04" + bigIntToHex(x, 64) + bigIntToHex(y, 64);
  return uint8ArrayFromHexString(uncompressedHexString);
}

// Encrypts data using AES-GCM.
/// 
/// - [plainTextData]: The plaintext data to encrypt.
/// - [key]: The encryption key (16, 24, or 32 bytes).
/// - [iv]: The 12-byte initialization vector for AES-GCM.
/// - [aad]: Additional authenticated data (optional).
///
/// Returns the ciphertext + 16-byte tag as a single Uint8List.
Uint8List aesGcmEncrypt(
  Uint8List plainTextData,
  Uint8List key,
  Uint8List iv, [
  Uint8List? aad,
]) {
  final cipher = GCMBlockCipher(AESEngine());
  final aeadParams = AEADParameters(
    KeyParameter(key),
    128, //TODO: check what we use in javascript (@noble/ciphers/aes default value)
    iv,
    aad ?? Uint8List(0),
  );

  cipher.init(true, aeadParams);
  return cipher.process(plainTextData);
}

/// Perform HKDF extract and expand operations.
///
/// - [sharedSecret]: The shared secret used as the salt for the extract phase.
/// - [ikm]: Input key material.
/// - [info]: Context and application-specific information.
/// - [len]: The desired output length in bytes.
///
/// Returns a `Uint8List` containing the derived key of the specified length.
Uint8List extractAndExpand(
  Uint8List sharedSecret,
  Uint8List ikm,
  Uint8List info,
  int len,
) {
  final prk = hkdfExtract(ikm, sharedSecret);
  final okm = hkdfExpand(prk, info, len);
  return okm;
}