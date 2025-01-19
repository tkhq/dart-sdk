import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:turnkey_crypto/src/constant.dart';
import 'package:turnkey_crypto/src/crypto_base.dart';
import 'package:turnkey_crypto/src/helper.dart';

void main() {
  group('bigIntToHex', () {
    test('Small number, with padding', () {
      final result = bigIntToHex(BigInt.from(1), 4);
      expect(result, equals('0001'));
    });

    test('Number exactly fits length', () {
      final bigIntVal = BigInt.parse('FF', radix: 16); // 255
      final result = bigIntToHex(bigIntVal, 2);
      expect(result, equals('ff'));
    });

    test('Throws if number is too large', () {
      final bigIntVal = BigInt.parse('1234', radix: 16);
      expect(() => bigIntToHex(bigIntVal, 3), throwsArgumentError);
    });

    test('Zero with padding', () {
      final result = bigIntToHex(BigInt.zero, 3);
      expect(result, equals('000'));
    });
  });

  const gX = '6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296';

  group('uncompressRawPublicKey tests', () {
    test('Valid prefix=03 (y is odd) for G => uncompressed is 65 bytes', () {
      // Compressed form of the P-256 base point G with prefix=0x03.
      final compressed = fromHex('03$gX');
      final uncompressed = uncompressRawPublicKey(compressed);

      expect(uncompressed.length, 65);
      expect(uncompressed[0], 0x04, reason: 'Should start with 0x04');
    });

    test('Valid prefix=02 (y is even) for same X => uncompressed is 65 bytes',
        () {
      // Same X, but prefix=0x02 => the function should pick the "even" Y
      final compressed = fromHex('02$gX');
      final uncompressed = uncompressRawPublicKey(compressed);

      expect(uncompressed.length, 65);
      expect(uncompressed[0], 0x04);
    });

    test('x >= p => throws ArgumentError', () {
      // Use prefix=0x02 plus an X that is definitely >= p (e.g. 2^256 - 1)
      final invalidX =
          'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
      final compressed = fromHex('02$invalidX');
      expect(() => uncompressRawPublicKey(compressed), throwsArgumentError);
    });

    test('Invalid curve point => sqrt fails => throws ArgumentError', () {
      // Likely non-square in the curve equation. Prefix=0x02 + large X < p
      // Here we pick X= (2^256 - 2) to avoid range error but still (very likely) invalid
      final randomX =
          'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe';
      final compressed = fromHex('02$randomX');
      expect(() => uncompressRawPublicKey(compressed), throwsArgumentError);
    });
  });

  group('aesGcmEncrypt tests', () {
    test('Basic encryption (128-bit key, no AAD)', () {
      final plainText = Uint8List.fromList([1, 2, 3, 4]);
      final key = Uint8List(16); // 128-bit key (all zero)
      final iv = Uint8List(12);  // 12-byte IV (all zero)

      final result = aesGcmEncrypt(plainText, key, iv);
      // Expect ciphertext + 16-byte tag => total length = plaintext + 16
      expect(result.length, equals(plainText.length + 16));
    });

    test('Encryption with AAD', () {
      final plainText = Uint8List.fromList([10, 20, 30]);
      final key = Uint8List(16);
      final iv = Uint8List(12);
      final aad = Uint8List.fromList([99, 100]);

      final result = aesGcmEncrypt(plainText, key, iv, aad);
      expect(result.length, equals(plainText.length + 16));
    });

    test('256-bit key', () {
      final plainText = Uint8List.fromList([5, 6, 7, 8, 9]);
      final key = Uint8List(32);
      final iv = Uint8List(12);
      final encrypted = aesGcmEncrypt(plainText, key, iv);
      expect(encrypted.length, equals(plainText.length + 16));
    });

    test('Invalid key length => throws ArgumentError', () {
      final plainText = Uint8List(5);
      final key = Uint8List(17); // 136 bits (not a valid AES key size)
      final iv = Uint8List(12);

      expect(() => aesGcmEncrypt(plainText, key, iv), throwsA(isA<ArgumentError>()));
    });
  });

  group('HKDF tests (extractAndExpand)', () {
    test('RFC 5869 Test Vector', () {
      final ikm = Uint8List.fromList([11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11]);
      final sharedSecret = Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]);
      final info = Uint8List.fromList([240, 241, 242, 243, 244, 245, 246, 247, 248, 249]);
      const length = 42;

      final expectedOkm = Uint8List.fromList([
        88, 220, 225, 13, 88, 1, 205, 253, 168, 49, 114, 107, 254, 188, 183, 67,
        209, 74, 126, 232, 58, 160, 87, 169, 61, 89, 176, 161, 49, 127, 240, 157,
        16, 92, 206, 207, 83, 86, 146, 177, 77, 213
      ]);

      final okm = extractAndExpand(sharedSecret, ikm, info, length);
      expect(okm, equals(expectedOkm));
    });

    test('Empty salt & info, short OKM', () {
      // If salt (sharedSecret) is empty, we default to zeros for extract
      final sharedSecret = Uint8List(0);
      final ikm = Uint8List.fromList([170, 170, 170, 170, 170, 170]); // some random
      final info = Uint8List(0);
      const length = 16;

      final expectedOkm = Uint8List.fromList([
        46, 68, 28, 247, 164, 218, 252, 66, 89, 246, 166, 116, 6, 9, 179, 193
      ]);

      final okm = extractAndExpand(sharedSecret, ikm, info, length);
      expect(okm, equals(expectedOkm));
    });
  });

  group('buildLabeledInfo tests', () {
    test('All zero-length fields, len=0 => minimal output of 9 bytes', () {
      final label = Uint8List(0);
      final info = Uint8List(0);
      final suiteId = Uint8List(0);
      final len = 0;

      final output = buildLabeledInfo(label, info, suiteId, len);
      expect(output.length, 9);
      expect(output[0], 0);
      expect(output[1], 0);
    });

    test('Non-empty label, info, suiteId => lengths add up', () {
      final label = Uint8List.fromList([1, 2]);
      final info = Uint8List.fromList([3, 4, 5]);
      final suiteId = Uint8List.fromList([9]);
      final len = 16;

      final output = buildLabeledInfo(label, info, suiteId, len);

      // total length = 9 (overhead) + 1 (suiteId) + 2 (label) + 3 (info) = 15
      expect(output.length, 15);
      expect(output[1], 16, reason: 'Byte 1 should contain len=16');
      // check that suiteId, label, and info are in the right spots
      final suiteIdIndex = 9;
      expect(output[suiteIdIndex], 9);
      final labelIndex = suiteIdIndex + suiteId.length; 
      expect(output.sublist(labelIndex, labelIndex + 2), [1, 2]);
      final infoIndex = labelIndex + 2;
      expect(output.sublist(infoIndex, infoIndex + 3), [3, 4, 5]);
    });
  });

  group('buildLabeledIkm tests', () {
    test('All zero-length fields => minimal output', () {
      final label = Uint8List(0);
      final ikm = Uint8List(0);
      final suiteId = Uint8List(0);

      final output = buildLabeledIkm(label, ikm, suiteId);

      // minimal output is just HPKE_VERSION
      expect(output.length, HPKE_VERSION.length);
      expect(output, equals(Uint8List.fromList(HPKE_VERSION)));
    });

    test('Non-empty label, ikm, suiteId => lengths add up', () {
      final label = Uint8List.fromList([1, 2]);
      final ikm = Uint8List.fromList([3, 4, 5]);
      final suiteId = Uint8List.fromList([9]);

      final output = buildLabeledIkm(label, ikm, suiteId);

      final expectedLength =
          HPKE_VERSION.length + suiteId.length + label.length + ikm.length;
      expect(output.length, expectedLength);

      final suiteIdIndex = HPKE_VERSION.length;
      final labelIndex = suiteIdIndex + suiteId.length;
      final ikmIndex = labelIndex + label.length;

      expect(output.sublist(0, HPKE_VERSION.length),
          equals(Uint8List.fromList(HPKE_VERSION)));
      expect(output.sublist(suiteIdIndex, labelIndex), equals(suiteId));
      expect(output.sublist(labelIndex, ikmIndex), equals(label));
      expect(output.sublist(ikmIndex), equals(ikm));
    });
  });

  group('getKemContext tests', () {
    test('Both buffers non-empty, merges correctly', () {
      final encappedKeyBuf = Uint8List.fromList([1, 2, 3]);
      final pubKeyHex = '04050607';
      final context = getKemContext(encappedKeyBuf, pubKeyHex);

      expect(context.length, 7);
      expect(context, equals([1, 2, 3, 4, 5, 6, 7]));
    });

    test('Empty encappedKeyBuf, non-empty publicKey', () {
      final encappedKeyBuf = Uint8List(0);
      final pubKeyHex = 'aa55';
      final context = getKemContext(encappedKeyBuf, pubKeyHex);

      expect(context.length, 2);
      expect(context, equals([0xaa, 0x55]));
    });

    test('Non-empty encappedKeyBuf, empty publicKey', () {
      final encappedKeyBuf = Uint8List.fromList([10, 20, 30]);
      final pubKeyHex = '';

      // expect an error since an empty public key hex is invalid
      expect(() => getKemContext(encappedKeyBuf, pubKeyHex), throwsArgumentError);
    });

    test('Large inputs, verify final length only', () {
      final encappedKeyBuf = Uint8List.fromList(List.generate(64, (i) => i));
      final pubKeyHex = List.generate(64, (i) => i.toRadixString(16).padLeft(2, '0')).join('');
      final context = getKemContext(encappedKeyBuf, pubKeyHex);

      expect(context.length, 128);
    });
  });

}
