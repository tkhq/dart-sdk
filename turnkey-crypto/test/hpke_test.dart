import 'dart:convert';
import 'dart:typed_data';
import 'package:encoding/encoding.dart';
import 'package:test/test.dart';
import 'package:turnkey_crypto/src/crypto_base.dart';
import 'package:turnkey_crypto/src/helper.dart';
import 'package:turnkey_crypto/src/hpke.dart';

void main() {
  group('HPKE Tests', () {
    test(
        'hpkeAuthEncrypt and hpkeDecrypt - end-to-end encryption and decryption',
        () {
      final senderKeyPair = generateP256KeyPair();
      final receiverKeyPair = generateP256KeyPair();
      final receiverPublicKeyUncompressed = uncompressRawPublicKey(
        uint8ArrayFromHexString(receiverKeyPair.publicKey),
      );

      // Mock plaintext
      final plainText = 'Hello, this is a secure message!';
      final plainTextBuf = Uint8List.fromList(utf8.encode(plainText));

      // Encrypt
      final encryptedDataBuf = hpkeAuthEncrypt(
        plainTextBuf: plainTextBuf,
        targetKeyBuf: receiverPublicKeyUncompressed,
        senderPriv: senderKeyPair.privateKey,
      );

      // Format encrypted data into JSON-like structure
      final encryptedData = formatHpkeBuf(encryptedDataBuf);
      final data = jsonDecode(encryptedData);

      // Decrypt
      final decryptedData = hpkeDecrypt(
        ciphertextBuf: uint8ArrayFromHexString(data['ciphertext']),
        encappedKeyBuf: uint8ArrayFromHexString(data['encappedPublic']),
        receiverPriv: receiverKeyPair.privateKey,
      );

      // Convert decrypted data back to string
      final decryptedText = utf8.decode(decryptedData);

      // Expect the decrypted text to equal the original plaintext
      expect(decryptedText, equals(plainText));
    });

    test('hpkeEncrypt and hpkeDecrypt - standard mode (ephemeral sender key)',
        () {
      // Generate a receiver key pair
      final receiverKeyPair = generateP256KeyPair();
      final receiverPublicKeyUncompressed = uncompressRawPublicKey(
        uint8ArrayFromHexString(receiverKeyPair.publicKey),
      );

      // Prepare the plaintext
      final plainText =
          '6ab33bd6e4bdc73017233da0554f9616fe10ede5c3ce001e81b321d5a74199b7';
      final plainTextBuf = Uint8List.fromList(utf8.encode(plainText));

      // Encrypt using standard mode (no sender private key provided)
      final encryptedDataBuf = hpkeEncrypt(
        plainTextBuf: plainTextBuf,
        targetKeyBuf: receiverPublicKeyUncompressed,
        // No senderPriv provided, so it will use an ephemeral key
      );

      // Format encrypted data into JSON-like structure
      final encryptedData = formatHpkeBuf(encryptedDataBuf);
      final data = jsonDecode(encryptedData);

      // Decrypt the message
      final decryptedData = hpkeDecrypt(
        ciphertextBuf: uint8ArrayFromHexString(data['ciphertext']),
        encappedKeyBuf: uint8ArrayFromHexString(data['encappedPublic']),
        receiverPriv: receiverKeyPair.privateKey,
      );

      // Convert decrypted data back to string
      final decryptedText = utf8.decode(decryptedData);

      // Verify that the decrypted text matches the original plaintext
      expect(decryptedText, equals(plainText));

      // Additional checks to ensure standard mode behavior
      final encappedPublicKey = uint8ArrayFromHexString(data['encappedPublic']);
      expect(encappedPublicKey.length, equals(65),
          reason: 'Uncompressed public key length should be 65 bytes');
      expect(encappedPublicKey[0], equals(0x04),
          reason: 'Uncompressed public key should have prefix 0x04');
    });
  });
}
