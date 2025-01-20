import 'dart:math';
import 'dart:typed_data';
import 'constant.dart';
import 'helper.dart';
import 'math.dart';
import 'package:encoding/encoding.dart';
import 'package:pointycastle/export.dart';
import 'type.dart';

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

/// Accepts a public key `Uint8List` and returns a `Uint8List` with the compressed version of the public key.
///
/// - [rawPublicKey]: The uncompressed public key as a `Uint8List` in the form `0x04 || x || y`.
///
/// Returns:
/// - The compressed public key as a `Uint8List` in the form `0x02/0x03 || x`.
Uint8List compressRawPublicKey(Uint8List rawPublicKey) {
  if (rawPublicKey.isEmpty || rawPublicKey[0] != 0x04) {
    throw ArgumentError('Invalid uncompressed public key format.');
  }

  final len = rawPublicKey.length;

  // Drop the y-coordinate
  // Uncompressed key is in the form 0x04 || x || y
  // `(len + 1) ~/ 2` calculates the length of the compressed key (x-coordinate only)
  final xBytes = rawPublicKey.sublist(1, (len + 1) ~/ 2);

  // Encode the parity of `y` in the first byte
  // `rawPublicKey[len - 1] & 0x01` tests for the parity of the y-coordinate
  // It returns 0x00 for even or 0x01 for odd
  // Then `0x02 | <parity test result>` results in either 0x02 (even) or 0x03 (odd)
  final yParity = rawPublicKey[len - 1] & 0x01;

  final compressedKey = Uint8List(xBytes.length + 1);
  compressedKey[0] = 0x02 | yParity;
  compressedKey.setAll(1, xBytes);

  return compressedKey;
}

/**
 * Uncompress a raw public key.
 */
Uint8List uncompressRawPublicKey(Uint8List rawPublicKey) {
  // point[0] must be 2 (false) or 3 (true).
  // this maps to the initial "02" or "03" prefix
  final lsb = rawPublicKey[0] == 3;
  final x =
      BigInt.parse(uint8ArrayToHexString(rawPublicKey.sublist(1)), radix: 16);

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

/// Decrypts data using AES-GCM.
///
/// - [encryptedData]: The ciphertext + 16-byte tag as a single Uint8List.
/// - [key]: The encryption key (16, 24, or 32 bytes).
/// - [iv]: The 12-byte initialization vector for AES-GCM.
/// - [aad]: Additional authenticated data (optional).
///
/// Returns:
/// - The decrypted plaintext as a `Uint8List`.
Uint8List aesGcmDecrypt(
  Uint8List encryptedData,
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

  cipher.init(false, aeadParams);

  try {
    return cipher.process(encryptedData);
  } catch (e) {
    throw Exception('AES-GCM decryption failed: $e');
  }
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

/// Build labeled info for HKDF operations.
///
/// - [label]: The label to use as a `Uint8List`.
/// - [info]: Additional information as a `Uint8List`.
/// - [suiteId]: The suite identifier as a `Uint8List`.
/// - [len]: The output length.
///
/// Returns a `Uint8List` containing the labeled info.
Uint8List buildLabeledInfo(
  Uint8List label,
  Uint8List info,
  Uint8List suiteId,
  int len,
) {
  const suiteIdStartIndex =
      9; // first two are reserved for length bytes (unused in this case), the next 7 are for the HPKE_VERSION, then the suiteId starts at 9
  final result = Uint8List(
      suiteIdStartIndex + suiteId.length + label.length + info.length);

  // this isn’t an error, we’re starting at index 2 because the first two bytes should be 0. See <https://github.com/dajiaji/hpke-js/blob/1e7fb1372fbcdb6d06bf2f4fa27ff676329d633e/src/kdfs/hkdf.ts#L41> for reference.
  result[0] = 0;
  result[1] = len;

  result.setRange(2, suiteIdStartIndex, HPKE_VERSION);

  result.setRange(
      suiteIdStartIndex, suiteIdStartIndex + suiteId.length, suiteId);

  final labelStartIndex = suiteIdStartIndex + suiteId.length;
  result.setRange(labelStartIndex, labelStartIndex + label.length, label);

  final infoStartIndex = labelStartIndex + label.length;
  result.setRange(infoStartIndex, infoStartIndex + info.length, info);

  return result;
}

/// Build labeled Initial Key Material (IKM).
///
/// - [label]: The label to use.
/// - [ikm]: The input key material.
/// - [suiteId]: The suite identifier.
///
/// Returns a `Uint8List` representing the labeled IKM.
Uint8List buildLabeledIkm(Uint8List label, Uint8List ikm, Uint8List suiteId) {
  final combinedLength =
      HPKE_VERSION.length + suiteId.length + label.length + ikm.length;
  final ret = Uint8List(combinedLength);
  var offset = 0;

  ret.setRange(offset, offset + HPKE_VERSION.length, HPKE_VERSION);
  offset += HPKE_VERSION.length;

  ret.setRange(offset, offset + suiteId.length, suiteId);
  offset += suiteId.length;

  ret.setRange(offset, offset + label.length, label);
  offset += label.length;

  ret.setRange(offset, offset + ikm.length, ikm);

  return ret;
}

/// Generate a Key Encapsulation Mechanism (KEM) context.
///
/// - [encappedKeyBuf]: The encapsulated key buffer as a `Uint8List`.
/// - [publicKey]: The public key as a hexadecimal string.
///
/// Returns a `Uint8List` representing the KEM context.
Uint8List getKemContext(Uint8List encappedKeyBuf, String publicKey) {
  final publicKeyArray = uint8ArrayFromHexString(publicKey);

  final kemContext = Uint8List(encappedKeyBuf.length + publicKeyArray.length);
  kemContext.setRange(0, encappedKeyBuf.length, encappedKeyBuf);
  kemContext.setRange(encappedKeyBuf.length, kemContext.length, publicKeyArray);

  return kemContext;
}

/// Derive the Diffie-Hellman shared secret (ECDH) using the P-256 curve.
///
/// - [encappedKeyBuf]: The ephemeral public key as a `Uint8List` (compressed or uncompressed).
/// - [priv]: The private key as a 32-byte hexadecimal string.
///
/// Returns the shared secret as a `Uint8List` (32 bytes X-coordinate).
Uint8List deriveSS(Uint8List encappedKeyBuf, String priv) {
  // Validate that the private key is exactly 32 bytes (64 hex characters)
  // We do this to be consistent with the javascript implementation
  if (priv.length != 64) {
    throw ArgumentError('Private key must be exactly 32 bytes.');
  }

  final domain = ECDomainParameters('secp256r1');
  final privateKeyValue = BigInt.parse(priv, radix: 16);

  if (privateKeyValue <= BigInt.zero || privateKeyValue >= domain.n) {
    throw ArgumentError(
        'Private key is invalid or out of range for the curve.');
  }

  final privateKey = ECPrivateKey(privateKeyValue, domain);

  final pubPoint = domain.curve.decodePoint(encappedKeyBuf);
  if (pubPoint == null) {
    throw ArgumentError('Invalid public key bytes.');
  }

  final sharedPoint = pubPoint * privateKey.d!;
  if (sharedPoint == null || sharedPoint.x == null) {
    throw ArgumentError('Failed to compute the shared point.');
  }

  final xBytes = bigIntToFixedLength(sharedPoint.x!.toBigInteger()!, 32);

  if (xBytes.length != 32) {
    throw StateError('Invalid shared secret length.');
  }

  // Return only the X-coordinate as the shared secret
  // TODO: check if we need to return the full point (javascript implementation only does x, is that intentional?)
  return Uint8List.fromList(xBytes);
}

/// Creates additional associated data (AAD) for AES-GCM decryption.
///
/// - [senderPubBuf]: A `Uint8List` representing the sender's public key.
/// - [receiverPubBuf]: A `Uint8List` representing the receiver's public key.
///
/// Returns:
/// - A `Uint8List` containing the concatenation of the sender and receiver public keys.
Uint8List buildAdditionalAssociatedData(
    Uint8List senderPubBuf, Uint8List receiverPubBuf) {
  return Uint8List.fromList([...senderPubBuf, ...receiverPubBuf]);
}

/// Derives the public key from a private key using the P-256 curve.
///
/// - [privateKey]: The private key as a `Uint8List` or a hexadecimal string.
/// - [isCompressed]: Specifies whether to return a compressed or uncompressed public key. Defaults to true.
///
/// Returns:
/// - The public key as a `Uint8List` in the specified format.
/// TODO: In javascript we actually say this function returns an Uint8Array or hexstring private key when it just returns a Uint8Array, we should fix that
Uint8List getPublicKey(dynamic privateKey, {bool isCompressed = true}) {
  Uint8List privKeyBytes;
  if (privateKey is String) {
    if (privateKey.length != 64) {
      throw ArgumentError('Private key must be a 32-byte hexadecimal string.');
    }
    privKeyBytes = Uint8List.fromList(List<int>.generate(privateKey.length ~/ 2,
        (i) => int.parse(privateKey.substring(i * 2, i * 2 + 2), radix: 16)));
  } else if (privateKey is Uint8List) {
    if (privateKey.length != 32) {
      throw ArgumentError('Private key must be exactly 32 bytes.');
    }
    privKeyBytes = privateKey;
  } else {
    throw ArgumentError(
        'Private key must be a Uint8List or a hexadecimal string.');
  }

  final domain = ECDomainParameters('secp256r1');

  final privateKeyValue = BigInt.parse(
      privKeyBytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16);
  final privateKeyParam = ECPrivateKey(privateKeyValue, domain);
  final publicKeyPoint = domain.G * privateKeyParam.d;

  if (publicKeyPoint == null) {
    throw StateError('Failed to compute public key.');
  }

  if (isCompressed) {
    return Uint8List.fromList(publicKeyPoint.getEncoded(true));
  } else {
    return Uint8List.fromList(publicKeyPoint.getEncoded(false));
  }
}

/// Generates a P-256 key pair.
///
/// Returns:
/// - A `KeyPair` object containing the private key, compressed public key, and uncompressed public key as hex strings.
KeyPair generateP256KeyPair() {
  final random = Random.secure();
  final privateKey = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    privateKey[i] = random.nextInt(256);
  }

  final publicKey = getPublicKey(privateKey, isCompressed: true);
  final publicKeyUncompressed =
      uint8ArrayToHexString(uncompressRawPublicKey(publicKey));

  return KeyPair(
    privateKey: uint8ArrayToHexString(privateKey),
    publicKey: uint8ArrayToHexString(publicKey),
    publicKeyUncompressed: publicKeyUncompressed,
  );
}
