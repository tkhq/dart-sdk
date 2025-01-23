import 'dart:convert';
import 'dart:typed_data';
import 'package:base58check/base58check.dart';
import 'package:cryptography/cryptography.dart' as crypto;
import 'package:turnkey_encoding/encoding.dart';
import 'crypto.dart';
import 'hpke.dart';
import 'package:bs58/bs58.dart';

/// Decrypts an encrypted email authentication/recovery or OAuth credential bundle.
///
/// This function takes an encrypted credential bundle, decodes it using Base58Check, and decrypts it using the specified private key. 
/// The decryption process involves extracting the encapsulated public key and ciphertext, uncompressing the public key, and performing HPKE decryption.
///
/// Parameters:
/// - [credentialBundle]: The encrypted credential bundle as a Base58Check encoded string.
/// - [embeddedKey]: The private key for decryption as a hexadecimal string.
///
/// Returns:
/// - The decrypted data as a hexadecimal string.
///
/// Throws:
/// - [ArgumentError] if the credential bundle is invalid or too small.
/// - [Exception] if decryption fails.

String decryptCredentialBundle({
  required String credentialBundle,
  required String embeddedKey,
}) {
  try {
    // TODO: check if bitcoin is the right codec here, in javascript we use https://github.com/bitcoinjs/bs58check
    final bundleBytes = Base58CheckCodec.bitcoin().decode(credentialBundle);

    // Base58CheckCodec strips the version byte, so we need to add it back 
    final versionByte = Uint8List.fromList([bundleBytes.version]); // Add the version byte
    final bundleBytesPayload = Uint8List.fromList(versionByte + bundleBytes.payload);


    if (bundleBytesPayload.length <= 33) {
      throw ArgumentError(
        'Bundle size ${bundleBytesPayload.length} is too low. Expecting a compressed public key (33 bytes) and an encrypted credential.',
      );
    }

    final compressedEncappedKeyBuf = Uint8List.fromList(bundleBytesPayload.sublist(0, 33));
    final ciphertextBuf = Uint8List.fromList(bundleBytesPayload.sublist(33));
    final encappedKeyBuf = uncompressRawPublicKey(compressedEncappedKeyBuf);

    final decryptedData = hpkeDecrypt(
      ciphertextBuf: ciphertextBuf,
      encappedKeyBuf: encappedKeyBuf,
      receiverPriv: embeddedKey,
    );

    return uint8ArrayToHexString(decryptedData);
  } catch (error) {
    throw Exception('Error decrypting bundle: $error');
  }
}

/// Decrypts an encrypted export bundle (such as a private key or wallet account bundle).
///
/// This function verifies the enclave signature to ensure the authenticity of the encrypted data.
/// It uses HPKE (Hybrid Public Key Encryption) to decrypt the contents of the bundle and returns
/// either the decrypted mnemonic or the decrypted data in hexadecimal format, based on the
/// `returnMnemonic` flag.
///
/// Parameters:
/// - [exportBundle]: The encrypted export bundle in JSON format.
/// - [organizationId]: The expected organization ID to verify against the signed data.
/// - [embeddedKey]: The private key used for decrypting the data, provided as a hex string (32 bytes).
/// - [dangerouslyOverrideSignerPublicKey]: (Optional) Override the default signer public key used for
///   verifying the signature. This should only be done for testing purposes.
/// - [keyFormat]: Format of the key (default is `HEXADECIMAL`).
/// - [returnMnemonic]: If true, returns the decrypted data as a mnemonic string; otherwise, returns it
///   in hexadecimal format (default is `false`).
///
/// Returns:
/// - A [Future<String>] that resolves to the decrypted mnemonic or the decrypted hexadecimal data.
///
/// Throws:
/// - [Exception]: If decryption or signature verification fails, an error with details is thrown.

Future<String> decryptExportBundle({
  required String exportBundle,
  required String embeddedKey,
  required String organizationId,
  String? dangerouslyOverrideSignerPublicKey,
  String keyFormat = 'HEXADECIMAL',
  bool returnMnemonic = false,
}) async {
  try {
    final parsedExportBundle = jsonDecode(exportBundle);

    final verified = await verifyEnclaveSignature(
      enclaveQuorumPublic: parsedExportBundle['enclaveQuorumPublic'],
      publicSignature: parsedExportBundle['dataSignature'],
      signedData: parsedExportBundle['data'],
      dangerouslyOverrideSignerPublicKey: dangerouslyOverrideSignerPublicKey,
    );
    if (!verified) {
      throw Exception('failed to verify enclave signature');
    }

    final dataBytes = uint8ArrayFromHexString(parsedExportBundle['data']);
    final signedDataJson = utf8.decode(dataBytes);
    final signedData = jsonDecode(signedDataJson);

    if (signedData['organizationId'] == null ||
        signedData['organizationId'] != organizationId) {
      throw Exception(
        'organization id does not match. Expected: $organizationId. Found: ${signedData["organizationId"]}.',
      );
    }

    if (signedData['encappedPublic'] == null) {
      throw Exception('missing "encappedPublic" in bundle signed data');
    }
    final encappedKeyBuf = uint8ArrayFromHexString(signedData['encappedPublic']);

    final ciphertextBuf = uint8ArrayFromHexString(signedData['ciphertext']);

    final decryptedData = hpkeDecrypt(
      ciphertextBuf: ciphertextBuf,
      encappedKeyBuf: encappedKeyBuf,
      receiverPriv: embeddedKey,
    );

    if (keyFormat == 'SOLANA' && !returnMnemonic) {
      if (decryptedData.length != 32) {
        throw Exception(
            'invalid private key length. Expected 32 bytes, got ${decryptedData.length}');
      }

      final algorithm = crypto.Ed25519();
      final keyPair = await algorithm.newKeyPairFromSeed(decryptedData);
      final publicKey = await keyPair.extractPublicKey();
      final publicKeyBytes = publicKey.bytes; // should be 32 bytes

      if (publicKeyBytes.length != 32) {
        throw Exception(
            'invalid public key length. Expected 32 bytes. Got ${publicKeyBytes.length}');
      }

      final concatenatedBytes = Uint8List(64);
      concatenatedBytes.setAll(0, decryptedData);
      concatenatedBytes.setAll(32, publicKeyBytes);

        return base58.encode(concatenatedBytes);
    }

    final decryptedDataHex = uint8ArrayToHexString(decryptedData);
    return returnMnemonic
        ? hexToAscii(decryptedDataHex)
        : decryptedDataHex;
  } catch (error) {
    throw Exception('Error decrypting bundle: $error');
  }
}

/// Encrypts a mnemonic wallet bundle using HPKE and verifies the enclave signature.
///
/// This function securely encrypts a mnemonic phrase using HPKE (Hybrid Public Key Encryption) based on a target public key extracted 
/// from the provided import bundle. The function also verifies the integrity of the enclave signature to ensure the authenticity 
/// of the bundle before encryption.
///
/// Parameters:
/// - [mnemonic]: The mnemonic phrase to encrypt.
/// - [importBundle]: A JSON string representing the import bundle, which includes enclave-generated metadata and target public key.
/// - [userId]: The user ID associated with the import bundle.
/// - [organizationId]: The organization ID associated with the import bundle.
/// - [dangerouslyOverrideSignerPublicKey]: Optionally override the default signer public key for testing purposes.
///
/// Returns:
/// - A [String] representing the encrypted wallet bundle in JSON format.
///
/// Throws:
/// - [Exception]: If the enclave signature verification fails, or if the bundle validation fails (e.g., mismatched organization or user ID).

Future<String> encryptWalletToBundle({
  required String mnemonic,
  required String importBundle,
  required String userId,
  required String organizationId,
  String? dangerouslyOverrideSignerPublicKey,
}) async {
  final Map<String, dynamic> parsedImportBundle = jsonDecode(importBundle);
  final Uint8List plainTextBuf = Uint8List.fromList(utf8.encode(mnemonic));
  final bool verified = await verifyEnclaveSignature(
    enclaveQuorumPublic: parsedImportBundle['enclaveQuorumPublic'],
    publicSignature: parsedImportBundle['dataSignature'],
    signedData: parsedImportBundle['data'],
    dangerouslyOverrideSignerPublicKey: dangerouslyOverrideSignerPublicKey,
  );

  if (!verified) {
    throw Exception('Failed to verify enclave signature: $importBundle');
  }

  final Uint8List dataBytes = uint8ArrayFromHexString(parsedImportBundle['data']);
  final String signedDataJson = utf8.decode(dataBytes);
  final Map<String, dynamic> signedData = jsonDecode(signedDataJson);

  if (signedData['organizationId'] == null ||
      signedData['organizationId'] != organizationId) {
    throw Exception(
      'Organization ID does not match expected value. '
      'Expected: $organizationId. Found: ${signedData["organizationId"]}.',
    );
  }

  if (signedData['userId'] == null || signedData['userId'] != userId) {
    throw Exception(
      'User ID does not match expected value. '
      'Expected: $userId. Found: ${signedData["userId"]}.',
    );
  }

  if (signedData['targetPublic'] == null) {
    throw Exception('Missing "targetPublic" in bundle signed data.');
  }

  // Load target public key generated from enclave and set in local storage
  // TODO: this is a comment in the javascript implementation, but I don't think this makes sense
  final Uint8List targetKeyBuf = uint8ArrayFromHexString(signedData['targetPublic']);
  final Uint8List privateKeyBundle = hpkeEncrypt(
    plainTextBuf: plainTextBuf,
    targetKeyBuf: targetKeyBuf,
  );
  return formatHpkeBuf(privateKeyBundle);
}

/// Encrypts a private key bundle using HPKE and verifies the enclave signature.
///
/// This function securely encrypts a private key using HPKE (Hybrid Public Key Encryption). The target public key required for encryption 
/// is extracted from the provided import bundle. Before encryption, the enclave signature within the import bundle is verified to ensure 
/// the authenticity and integrity of the bundle.
///
/// Parameters:
/// - [privateKey]: The private key to encrypt.
/// - [keyFormat]: The format of the private key (e.g., "SOLANA", "HEXADECIMAL").
/// - [importBundle]: A JSON string representing the import bundle, containing metadata and the target public key.
/// - [userId]: The user ID associated with the import bundle.
/// - [organizationId]: The organization ID associated with the import bundle.
/// - [dangerouslyOverrideSignerPublicKey]: Optionally override the default signer public key for testing purposes.
///
/// Returns:
/// - A [String] representing the encrypted bundle in JSON format.
///
/// Throws:
/// - [Exception]: If enclave signature verification fails, or if the bundle validation fails (e.g., mismatched organization or user ID).
Future<String> encryptPrivateKeyToBundle({
  required String privateKey,
  required String keyFormat,
  required String importBundle,
  required String userId,
  required String organizationId,
  String? dangerouslyOverrideSignerPublicKey,
}) async {
  final Map<String, dynamic> parsedImportBundle = jsonDecode(importBundle);
  final Uint8List plainTextBuf = decodeKey(privateKey, keyFormat);
  final bool verified = await verifyEnclaveSignature(
    enclaveQuorumPublic: parsedImportBundle['enclaveQuorumPublic'],
    publicSignature: parsedImportBundle['dataSignature'],
    signedData: parsedImportBundle['data'],
    dangerouslyOverrideSignerPublicKey: dangerouslyOverrideSignerPublicKey,
  );

  if (!verified) {
    throw Exception('Failed to verify enclave signature: $importBundle');
  }

  final Uint8List dataBytes = uint8ArrayFromHexString(parsedImportBundle['data']);
  final String signedDataJson = utf8.decode(dataBytes);
  final Map<String, dynamic> signedData = jsonDecode(signedDataJson);

  if (signedData['organizationId'] == null ||
      signedData['organizationId'] != organizationId) {
    throw Exception(
      'Organization ID does not match expected value. '
      'Expected: $organizationId. Found: ${signedData["organizationId"]}.',
    );
  }

  if (signedData['userId'] == null || signedData['userId'] != userId) {
    throw Exception(
      'User ID does not match expected value. '
      'Expected: $userId. Found: ${signedData["userId"]}.',
    );
  }

  if (signedData['targetPublic'] == null) {
    throw Exception('Missing "targetPublic" in bundle signed data.');
  }

  // Load target public key generated from enclave and set in local storage
  // TODO: this is a comment in the javascript implementation, but I don't think this makes sense
  final Uint8List targetKeyBuf = uint8ArrayFromHexString(signedData['targetPublic']);
  final Uint8List privateKeyBundle = hpkeEncrypt(
    plainTextBuf: plainTextBuf,
    targetKeyBuf: targetKeyBuf,
  );
  return formatHpkeBuf(privateKeyBundle);
}