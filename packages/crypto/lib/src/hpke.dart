import 'dart:typed_data';
import 'package:turnkey_encoding/turnkey_encoding.dart';

import 'constant.dart';
import 'crypto.dart';
import 'package:pointycastle/export.dart';
import 'dart:convert';

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

/// Encrypts data using Authenticated Hybrid Public Key Encryption (HPKE) standard.
///
/// - [plainTextBuf]: The plaintext data as a `Uint8List`.
/// - [targetKeyBuf]: The target public key as a `Uint8List`.
/// - [senderPriv]: The sender's private key as a hex string.
///
/// Returns:
/// - The encrypted data as a `Uint8List`.
Uint8List hpkeAuthEncrypt({
  required Uint8List plainTextBuf,
  required Uint8List targetKeyBuf,
  required String senderPriv,
}) {
  try {
    // Authenticated HPKE Mode
    final senderPrivBuf = uint8ArrayFromHexString(senderPriv);
    final senderPubBuf = getPublicKey(senderPrivBuf, isCompressed: false);

    final aad = buildAdditionalAssociatedData(senderPubBuf, targetKeyBuf);

    // Step 1: Generate Shared Secret
    final ss = deriveSS(targetKeyBuf, senderPriv);

    // Step 2: Generate the KEM context
    final kemContext =
        getKemContext(senderPubBuf, uint8ArrayToHexString(targetKeyBuf));

    // Step 3: Build the HKDF inputs for key derivation
    var ikm = buildLabeledIkm(LABEL_EAE_PRK, ss, SUITE_ID_1);
    var info =
        buildLabeledInfo(LABEL_SHARED_SECRET, kemContext, SUITE_ID_1, 32);
    final sharedSecret = extractAndExpand(Uint8List(0), ikm, info, 32);

    // Step 4: Derive the AES key
    ikm = buildLabeledIkm(LABEL_SECRET, Uint8List(0), SUITE_ID_2);
    info = AES_KEY_INFO;
    final key = extractAndExpand(sharedSecret, ikm, info, 32);

    // Step 5: Derive the initialization vector
    info = IV_INFO;
    final iv = extractAndExpand(sharedSecret, ikm, info, 12);

    // Step 6: Encrypt the data using AES-GCM
    final encryptedData = aesGcmEncrypt(plainTextBuf, key, iv, aad);

    // Step 7: Concatenate the encapsulated key and the encrypted data for output
    final compressedSenderBuf = compressRawPublicKey(senderPubBuf);
    final result = Uint8List(compressedSenderBuf.length + encryptedData.length)
      ..setAll(0, compressedSenderBuf)
      ..setAll(compressedSenderBuf.length, encryptedData);

    return result;
  } catch (error) {
    throw ArgumentError('Unable to perform hpkeAuthEncrypt: $error');
  }
}

/// HPKE Encrypt Function
/// Encrypts data using the Hybrid Public Key Encryption (HPKE) standard (RFC 9180).
///
/// - [plainTextBuf]: The plaintext data to encrypt as a `Uint8List`.
/// - [targetKeyBuf]: The recipient's public key as an uncompressed `Uint8List` (in the form `0x04 || x || y`).
///
/// Returns:
/// - The encrypted data as a `Uint8List`, including the encapsulated public key and ciphertext.
///
/// Throws:
/// - [ArgumentError] if encryption fails.
Uint8List hpkeEncrypt({
  required Uint8List plainTextBuf,
  required Uint8List targetKeyBuf,
}) {
  try {
    // Standard HPKE Mode (Ephemeral Key Pair)
    final ephemeralKeyPair = generateP256KeyPair();
    final senderPrivBuf = uint8ArrayFromHexString(ephemeralKeyPair.privateKey);
    final senderPubBuf =
        uint8ArrayFromHexString(ephemeralKeyPair.publicKeyUncompressed);

    final aad = buildAdditionalAssociatedData(senderPubBuf, targetKeyBuf);

    // Step 1: Generate Shared Secret
    final ss = deriveSS(targetKeyBuf, uint8ArrayToHexString(senderPrivBuf));

    // Step 2: Generate the KEM context
    final kemContext =
        getKemContext(senderPubBuf, uint8ArrayToHexString(targetKeyBuf));

    // Step 3: Build the HKDF inputs for key derivation
    var ikm = buildLabeledIkm(LABEL_EAE_PRK, ss, SUITE_ID_1);
    var info =
        buildLabeledInfo(LABEL_SHARED_SECRET, kemContext, SUITE_ID_1, 32);
    final sharedSecret = extractAndExpand(Uint8List(0), ikm, info, 32);

    // Step 4: Derive the AES key
    ikm = buildLabeledIkm(LABEL_SECRET, Uint8List(0), SUITE_ID_2);
    info = AES_KEY_INFO;
    final key = extractAndExpand(sharedSecret, ikm, info, 32);

    // Step 5: Derive the initialization vector
    info = IV_INFO;
    final iv = extractAndExpand(sharedSecret, ikm, info, 12);

    // Step 6: Encrypt the data using AES-GCM
    final encryptedData = aesGcmEncrypt(plainTextBuf, key, iv, aad);

    // Step 7: Concatenate the encapsulated key and the encrypted data for output
    final compressedSenderBuf = compressRawPublicKey(senderPubBuf);
    final result = Uint8List(compressedSenderBuf.length + encryptedData.length)
      ..setAll(0, compressedSenderBuf)
      ..setAll(compressedSenderBuf.length, encryptedData);

    return result;
  } catch (error) {
    throw ArgumentError('Unable to perform hpkeEncrypt: $error');
  }
}

/// HPKE Decrypt Function
/// Decrypts data using the Hybrid Public Key Encryption (HPKE) standard (RFC 9180).
///
/// - [ciphertextBuf]: The ciphertext as a `Uint8List`.
/// - [encappedKeyBuf]: The encapsulated key as a `Uint8List`.
/// - [receiverPriv]: The receiver's private key as a hexadecimal string.
///
/// Returns:
/// - The decrypted data as a `Uint8List`.
Uint8List hpkeDecrypt({
  required Uint8List ciphertextBuf,
  required Uint8List encappedKeyBuf,
  required String receiverPriv,
}) {
  try {
    final receiverPubBuf = getPublicKey(
      uint8ArrayFromHexString(receiverPriv),
      isCompressed: false,
    );

    final aad = buildAdditionalAssociatedData(encappedKeyBuf,
        receiverPubBuf); // Eventually we want users to be able to pass in aad as optional

    // Step 1: Generate the Shared Secret
    final ss = deriveSS(encappedKeyBuf, receiverPriv);

    // Step 2: Generate the KEM context
    final kemContext = getKemContext(
      encappedKeyBuf,
      receiverPubBuf
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join(),
    );

    // Step 3: Build the HKDF inputs for key derivation
    final ikmEaePrk = buildLabeledIkm(LABEL_EAE_PRK, ss, SUITE_ID_1);
    final infoSharedSecret =
        buildLabeledInfo(LABEL_SHARED_SECRET, kemContext, SUITE_ID_1, 32);
    final sharedSecret =
        extractAndExpand(Uint8List(0), ikmEaePrk, infoSharedSecret, 32);

    // Step 4: Derive the AES key
    final ikmSecret = buildLabeledIkm(LABEL_SECRET, Uint8List(0), SUITE_ID_2);
    final key = extractAndExpand(sharedSecret, ikmSecret, AES_KEY_INFO, 32);

    // Step 5: Derive the initialization vector
    final iv = extractAndExpand(sharedSecret, ikmSecret, IV_INFO, 12);

    // Step 6: Decrypt the data using AES-GCM
    final decryptedData = aesGcmDecrypt(ciphertextBuf, key, iv, aad);
    return decryptedData;
  } catch (error) {
    throw Exception('Unable to perform hpkeDecrypt: $error');
  }
}
