import 'dart:math';
import 'dart:typed_data';
import 'package:turnkey_encoding/encoding.dart';
import 'constant.dart';
import 'math.dart';
import 'package:pointycastle/export.dart';
import 'type.dart';
import 'package:bs58/bs58.dart';

/// Converts a [BigInt] to a hexadecimal string of a specified length.
///
/// Parameters:
/// - [num]: The [BigInt] value to convert to hexadecimal.
/// - [length]: The desired length of the resulting hexadecimal string.
///
/// Returns:
/// - A zero-padded hexadecimal string representation of [num] with the specified [length].
///
/// Throws:
/// - [ArgumentError]: If the hexadecimal representation of [num] exceeds the specified [length].
String bigIntToHex(BigInt num, int length) {
  final hexString = num.toRadixString(16);
  if (hexString.length > length) {
    throw ArgumentError(
        'Number cannot fit in a hex string of $length characters');
  }
  return hexString.padLeft(length, '0');
}

/// Converts a [BigInt] to a fixed-length [Uint8List].
///
/// Parameters:
/// - [value]: The [BigInt] to convert.
/// - [length]: The desired length of the resulting [Uint8List], in bytes.
///
/// Returns:
/// - A [Uint8List] of the specified length representing the [BigInt] value.
///
/// Throws:
/// - [ArgumentError]: If the [value] cannot be represented within the specified [length].
Uint8List bigIntToFixedLength(BigInt value, int length) {
  final bytes =
      value.toUnsigned(8 * length).toRadixString(16).padLeft(length * 2, '0');
  final result = Uint8List(length);
  for (int i = 0; i < length; i++) {
    result[i] = int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16);
  }
  return result;
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

/// Uncompresses a raw elliptic curve public key.
///
/// Parameters:
/// - [rawPublicKey]: A [Uint8List] containing the compressed public key in SEC1 format.
///
/// Returns:
/// - A [Uint8List] containing the uncompressed public key in SEC1 format.
///
/// Throws:
/// - [ArgumentError]: If the x or y coordinate of the public key is out of range.
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

/// Decodes a private key based on the specified format.
///
/// Parameters:
/// - [privateKey]: The private key to decode.
/// - [keyFormat]: The format of the private key (e.g., "SOLANA", "HEXADECIMAL").
///
/// Returns:
/// - A [Uint8List] representing the decoded private key.
///
/// Throws:
/// - [Exception]: If the key length is invalid for the "SOLANA" format.
Uint8List decodeKey(String privateKey, String keyFormat) {
  switch (keyFormat) {
    case "SOLANA":
      final decodedKeyBytes = base58.decode(privateKey);
      if (decodedKeyBytes.length != 64) {
        throw Exception(
            'Invalid key length. Expected 64 bytes. Got ${decodedKeyBytes.length}.');
      }
      return Uint8List.fromList(decodedKeyBytes.sublist(0, 32));
    case "HEXADECIMAL":
      if (privateKey.startsWith("0x")) {
        return uint8ArrayFromHexString(privateKey.substring(2));
      }
      return uint8ArrayFromHexString(privateKey);
    default:
      print(
          'Invalid key format: $keyFormat. Defaulting to HEXADECIMAL.');
      if (privateKey.startsWith("0x")) {
        return uint8ArrayFromHexString(privateKey.substring(2));
      }
      return uint8ArrayFromHexString(privateKey);
  }
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
    128,
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
    128, 
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

/// Derives the public key from a private key using the P-256 curve.
///
/// - [privateKey]: The private key as a `Uint8List` or a hexadecimal string.
/// - [isCompressed]: Specifies whether to return a compressed or uncompressed public key. Defaults to true.
///
/// Returns:
/// - The public key as a `Uint8List` in the specified format.
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

/// Loads an ECDSA public key from a raw format for signature verification.
///
/// - [publicKeyBytes]: The raw public key bytes as a `Uint8List`.
///
/// Returns:
/// - An `ECPublicKey` object representing the decoded public key on the P-256 curve.
///
/// Throws:
/// - [ArgumentError] if the provided public key bytes are invalid.
ECPublicKey loadPublicKey(Uint8List publicKeyBytes) {
  final domain = ECDomainParameters('prime256v1');
  final ecPoint = domain.curve.decodePoint(publicKeyBytes);
  if (ecPoint == null) {
    throw ArgumentError('Invalid public key bytes.');
  }
  return ECPublicKey(ecPoint, domain);
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
  return Uint8List.fromList(xBytes);
}

/// Converts a DER-encoded ECDSA signature into a normalized `Uint8List` format
/// with 32-byte r and s components concatenated.
///
/// - [derSignature]: The DER-encoded ECDSA signature as a hexadecimal string.
///
/// Returns:
/// - A `Uint8List` containing the normalized 32-byte r and s components concatenated.
///
/// Throws:
/// - [ArgumentError] if the DER signature format is invalid or improperly tagged.
Uint8List fromDerSignature(String derSignature) {
  final derSignatureBuf = uint8ArrayFromHexString(derSignature);

  // Check and skip the sequence tag (0x30)
  int index = 2;

  // Parse 'r' and check for integer tag (0x02)
  if (derSignatureBuf[index] != 0x02) {
    throw ArgumentError('Invalid tag for r');
  }
  index++; // Move past the INTEGER tag
  final rLength = derSignatureBuf[index];
  index++; // Move past the length byte
  final r = derSignatureBuf.sublist(index, index + rLength);
  index += rLength;  // Move to the start of s

  // Parse 's' and check for integer tag (0x02)
  if (derSignatureBuf[index] != 0x02) {
    throw ArgumentError('Invalid tag for s');
  }
  index++; // Move past the INTEGER tag
  final sLength = derSignatureBuf[index];
  index++; // Move past the length byte
  final s = derSignatureBuf.sublist(index, index + sLength);

  // Normalize 'r' and 's' to 32 bytes each
  final rPadded = normalizePadding(r, 32);
  final sPadded = normalizePadding(s, 32);

  return Uint8List.fromList([...rPadded, ...sPadded]);
}

/// Verifies a signature from a Turnkey enclave using ECDSA and SHA-256.
///
/// - [enclaveQuorumPublic]: The public key of the enclave signer as a hexadecimal string.
/// - [publicSignature]: The ECDSA signature in DER format as a hexadecimal string.
/// - [signedData]: The data that was signed as a hexadecimal string.
/// - [dangerouslyOverrideSignerPublicKey]: (Optional) The public key to verify against, overriding the default signer enclave key.
///
/// Returns:
/// - `true` if the signature is valid; otherwise, throws an error.
///
/// Throws:
/// - [ArgumentError] if the public key does not match the expected signer public key.
/// - [Exception] if the signature verification fails.
bool verifyEnclaveSignature({
  required String enclaveQuorumPublic,
  required String publicSignature,
  required String signedData,
  String? dangerouslyOverrideSignerPublicKey,
}) {
  final expectedSignerPublicKey =
      dangerouslyOverrideSignerPublicKey ?? PRODUCTION_SIGNER_PUBLIC_KEY;

  if (enclaveQuorumPublic != expectedSignerPublicKey) {
    throw ArgumentError(
      'Expected signer key ${dangerouslyOverrideSignerPublicKey ?? PRODUCTION_SIGNER_PUBLIC_KEY} '
      'does not match signer key from bundle: $enclaveQuorumPublic',
    );
  }

  final encryptionQuorumPublicBuf =
      uint8ArrayFromHexString(enclaveQuorumPublic);
  final quorumKey = loadPublicKey(encryptionQuorumPublicBuf);

  // The ECDSA signature is ASN.1 DER encoded but WebCrypto uses raw format
  final publicSignatureBuf = fromDerSignature(publicSignature);
  final signedDataBuf = uint8ArrayFromHexString(signedData);
  final verifier = Signer('SHA-256/ECDSA')
    ..init(false, PublicKeyParameter<ECPublicKey>(quorumKey));

  final signature = ECSignature(
    BigInt.parse(
      publicSignatureBuf.sublist(0, 32).map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    ),
    BigInt.parse(
      publicSignatureBuf.sublist(32).map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      radix: 16,
    ),
  );

  return verifier.verifySignature(signedDataBuf, signature);
}



