import 'dart:convert';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:turnkey_crypto/src/crypto.dart';
import 'package:turnkey_crypto/src/hpke.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';

void main() {

  group('extractAndExpand Tests', () {
    test('RFC 5869 Test Vector', () {
      final ikm =
          Uint8List.fromList([11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11]);
      final sharedSecret =
          Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
      final info = Uint8List.fromList(
          [240, 241, 242, 243, 244, 245, 246, 247, 248, 249]);
      const length = 42;

      final expectedOkm = Uint8List.fromList([
        88,
        220,
        225,
        13,
        88,
        1,
        205,
        253,
        168,
        49,
        114,
        107,
        254,
        188,
        183,
        67,
        209,
        74,
        126,
        232,
        58,
        160,
        87,
        169,
        61,
        89,
        176,
        161,
        49,
        127,
        240,
        157,
        16,
        92,
        206,
        207,
        83,
        86,
        146,
        177,
        77,
        213
      ]);

      final okm = extractAndExpand(sharedSecret, ikm, info, length);

      expect(okm, equals(expectedOkm));
    });

    test('Empty salt & info, short OKM', () {
      // If salt (sharedSecret) is empty, we default to zeros for extract
      final sharedSecret = Uint8List(0);
      final ikm =
          Uint8List.fromList([170, 170, 170, 170, 170, 170]); // some random
      final info = Uint8List(0);
      const length = 16;

      final expectedOkm = Uint8List.fromList([
        46,
        68,
        28,
        247,
        164,
        218,
        252,
        66,
        89,
        246,
        166,
        116,
        6,
        9,
        179,
        193
      ]);

      final okm = extractAndExpand(sharedSecret, ikm, info, length);

      expect(okm, equals(expectedOkm));
    });
  });
  group('HPKE Tests', () {
    test(
        'hpkeAuthEncrypt and hpkeDecrypt - end-to-end encryption and decryption',
        () {
      final senderKeyPair = generateP256KeyPair();
      final receiverKeyPair = generateP256KeyPair();
      final receiverPublicKeyUncompressed = uncompressRawPublicKey(
        uint8ArrayFromHexString(receiverKeyPair.publicKey),
      );

      final plainText = 'Hello, this is a secure message!';
      final plainTextBuf = Uint8List.fromList(utf8.encode(plainText));

      final encryptedDataBuf = hpkeAuthEncrypt(
        plainTextBuf: plainTextBuf,
        targetKeyBuf: receiverPublicKeyUncompressed,
        senderPriv: senderKeyPair.privateKey,
      );

      final encryptedData = formatHpkeBuf(encryptedDataBuf);
      final data = jsonDecode(encryptedData);

      final decryptedData = hpkeDecrypt(
        ciphertextBuf: uint8ArrayFromHexString(data['ciphertext']),
        encappedKeyBuf: uint8ArrayFromHexString(data['encappedPublic']),
        receiverPriv: receiverKeyPair.privateKey,
      );

      final decryptedText = utf8.decode(decryptedData);

      expect(decryptedText, equals(plainText));
    });

    test('hpkeEncrypt and hpkeDecrypt - standard mode (ephemeral sender key)',
        () {
      final receiverKeyPair = generateP256KeyPair();
      final receiverPublicKeyUncompressed = uncompressRawPublicKey(
        uint8ArrayFromHexString(receiverKeyPair.publicKey),
      );

      final plainText =
          '6ab33bd6e4bdc73017233da0554f9616fe10ede5c3ce001e81b321d5a74199b7';
      final plainTextBuf = Uint8List.fromList(utf8.encode(plainText));

      final encryptedDataBuf = hpkeEncrypt(
        plainTextBuf: plainTextBuf,
        targetKeyBuf: receiverPublicKeyUncompressed,
      );

      final encryptedData = formatHpkeBuf(encryptedDataBuf);
      final data = jsonDecode(encryptedData);

      final decryptedData = hpkeDecrypt(
        ciphertextBuf: uint8ArrayFromHexString(data['ciphertext']),
        encappedKeyBuf: uint8ArrayFromHexString(data['encappedPublic']),
        receiverPriv: receiverKeyPair.privateKey,
      );

      final decryptedText = utf8.decode(decryptedData);
      final encappedPublicKey = uint8ArrayFromHexString(data['encappedPublic']);


      expect(decryptedText, equals(plainText));
      expect(encappedPublicKey.length, equals(65),
          reason: 'Uncompressed public key length should be 65 bytes');
      expect(encappedPublicKey[0], equals(0x04),
          reason: 'Uncompressed public key should have prefix 0x04');
    });
  });
}
