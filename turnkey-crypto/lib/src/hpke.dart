import 'dart:typed_data';
import 'package:encoding/encoding.dart';
import 'constant.dart';
import 'crypto_base.dart';

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
