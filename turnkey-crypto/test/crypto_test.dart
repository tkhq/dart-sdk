import 'dart:typed_data';
import 'package:encoding/encoding.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'package:turnkey_crypto/src/constant.dart';
import 'package:turnkey_crypto/src/crypto_base.dart';

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

  group('compressRawPublicKey tests', () {
    test('Valid uncompressed key => compressed key with prefix=03 (y is odd)',
        () {
      final uncompressed = uint8ArrayFromHexString(
          '04d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee54051621044114ddc57ee52866a83d8156cd509fa68a2916466d812431781262de37855ef');
      final expectedCompressed = uint8ArrayFromHexString(
          '03d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee540516210');

      final compressed = compressRawPublicKey(uncompressed);

      expect(compressed, equals(expectedCompressed));
    });

    test('Valid uncompressed key => compressed key with prefix=02 (y is even)',
        () {
      final uncompressed = uint8ArrayFromHexString(
          '048c36835fb4a73bbf433e4a92c16d35d2625d0f9e5490ec0d4238094ece23dbfc7e2e07a9b3a51e709da1d727b1ef20c0115fc2fdc6c9e05bb6cba0d9b1e9c7af');
      final expectedCompressed = uint8ArrayFromHexString(
          '038c36835fb4a73bbf433e4a92c16d35d2625d0f9e5490ec0d4238094ece23dbfc');

      final compressed = compressRawPublicKey(uncompressed);

      expect(compressed, equals(expectedCompressed));
    });

    test('Invalid uncompressed public key format => throws ArgumentError', () {
      final invalidKey = uint8ArrayFromHexString(
          '03d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee540516210');

      expect(() => compressRawPublicKey(invalidKey), throwsArgumentError);
    });

    test('Empty uncompressed public key => throws ArgumentError', () {
      final emptyKey = Uint8List(0);

      expect(() => compressRawPublicKey(emptyKey), throwsArgumentError);
    });

    test('Compress and decompress round trip', () {
      final uncompressed = uint8ArrayFromHexString(
          '04d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee54051621044114ddc57ee52866a83d8156cd509fa68a2916466d812431781262de37855ef');
      final compressed = compressRawPublicKey(uncompressed);
      final decompressed = uncompressRawPublicKey(compressed);

      expect(decompressed, equals(uncompressed));
    });
  });

  group('uncompressRawPublicKey tests', () {
    const gX =
        '6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c296';

    test('Valid prefix=03 (y is odd) for G => uncompressed is 65 bytes', () {
      // Compressed form of the P-256 base point G with prefix=0x03.
      final compressed = uint8ArrayFromHexString('03$gX');
      final uncompressed = uncompressRawPublicKey(compressed);

      expect(uncompressed.length, 65);
      expect(uncompressed[0], 0x04, reason: 'Should start with 0x04');
    });

    test('Valid prefix=02 (y is even) for same X => uncompressed is 65 bytes',
        () {
      // Same X, but prefix=0x02 => the function should pick the "even" Y
      final compressed = uint8ArrayFromHexString('02$gX');
      final uncompressed = uncompressRawPublicKey(compressed);

      expect(uncompressed.length, 65);
      expect(uncompressed[0], 0x04);
    });

    test('x >= p => throws ArgumentError', () {
      // Use prefix=0x02 plus an X that is definitely >= p (e.g. 2^256 - 1)
      final invalidX =
          'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
      final compressed = uint8ArrayFromHexString('02$invalidX');
      expect(() => uncompressRawPublicKey(compressed), throwsArgumentError);
    });

    test('Invalid curve point => sqrt fails => throws ArgumentError', () {
      // Likely non-square in the curve equation. Prefix=0x02 + large X < p
      // Here we pick X= (2^256 - 2) to avoid range error but still (very likely) invalid
      final randomX =
          'fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe';
      final compressed = uint8ArrayFromHexString('02$randomX');
      expect(() => uncompressRawPublicKey(compressed), throwsArgumentError);
    });
  });

  group('aesGcmEncrypt tests', () {
    test('Basic encryption (128-bit key, no AAD)', () {
      final plainText = Uint8List.fromList([1, 2, 3, 4]);
      final key = Uint8List(16);
      final iv = Uint8List(12);

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

      expect(() => aesGcmEncrypt(plainText, key, iv),
          throwsA(isA<ArgumentError>()));
    });
  });

  group('aesGcmDecrypt tests', () {
    test('Basic round-trip (128-bit key, no AAD)', () {
      final plainText = Uint8List.fromList([1, 2, 3, 4]);
      final key = Uint8List(16);
      final iv = Uint8List(12);

      final encrypted = aesGcmEncrypt(plainText, key, iv);
      final decrypted = aesGcmDecrypt(encrypted, key, iv);

      expect(decrypted, equals(plainText));
    });

    test('With AAD => must match original plaintext', () {
      final plainText = Uint8List.fromList([10, 20, 30]);
      final key = Uint8List(16);
      final iv = Uint8List(12);
      final aad = Uint8List.fromList([99, 100]);

      final encrypted = aesGcmEncrypt(plainText, key, iv, aad);
      final decrypted = aesGcmDecrypt(encrypted, key, iv, aad);
      expect(decrypted, equals(plainText));
    });

    test('Tampered ciphertext => throws Exception on decrypt', () {
      final plainText = Uint8List.fromList([5, 6, 7, 8]);
      final key = Uint8List(16);
      final iv = Uint8List(12);

      final encrypted = aesGcmEncrypt(plainText, key, iv);

      encrypted[0] ^= 0xFF;
      expect(() => aesGcmDecrypt(encrypted, key, iv), throwsException);
    });

    test('Tampered tag => throws Exception', () {
      final plainText = Uint8List.fromList([5, 6, 7, 8]);
      final key = Uint8List(16);
      final iv = Uint8List(12);

      final encrypted = aesGcmEncrypt(plainText, key, iv);

      encrypted[encrypted.length - 1] ^= 0xFF;
      expect(() => aesGcmDecrypt(encrypted, key, iv), throwsException);
    });

    test('Invalid key length => throws ArgumentError', () {
      final encrypted = Uint8List(16); // dummy
      final key = Uint8List(17); // invalid
      final iv = Uint8List(12);
      expect(() => aesGcmDecrypt(encrypted, key, iv), throwsArgumentError);
    });
  });

  group('HKDF tests (extractAndExpand)', () {
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

      expect(
          () => getKemContext(encappedKeyBuf, pubKeyHex), throwsArgumentError);
    });

    test('Large inputs, verify final length only', () {
      final encappedKeyBuf = Uint8List.fromList(List.generate(64, (i) => i));
      final pubKeyHex =
          List.generate(64, (i) => i.toRadixString(16).padLeft(2, '0'))
              .join('');
      final context = getKemContext(encappedKeyBuf, pubKeyHex);

      expect(context.length, 128);
    });
  });

  group('deriveSS tests (generated)', () {
    test('Valid ephemeral + recipient private => known shared secret', () {
      final ephemeralPubCompressed = uint8ArrayFromHexString(
          '042429bc20c6ef6d8bed8eff26f62b10457e6dbb0fe743c95aea929cfb20955e20a8b69ba9d98dc8eac7ef99b0ee94ff4a1bbe2f730e5940db1fc9daa48490f2a6');
      final recipientPrivHex =
          '62ee85b30bd2605ca3b6dc4ec541fdb0ff89ce50745eaf888ee14d5ec2cd372e';

      final expectedSharedHex =
          '70a8c462e00bbf0a6a25ee63adfe4d5dc968b9f94424af21473bb852191efe96';
      final expectedShared = uint8ArrayFromHexString(expectedSharedHex);

      final got = deriveSS(ephemeralPubCompressed, recipientPrivHex);
      expect(got, equals(expectedShared));
    });

    test('Another valid ephemeral + recipient private => known shared secret',
        () {
      final ephemeralPubCompressed = uint8ArrayFromHexString(
          '045434d861d587351c84b531cb7006d9aa80e62b6789f628159504cf966cdb13ca9669eabdf99faede322359779a4e72d235c6f9d728dff19f2b98631a4d475c3f');
      final recipientPrivHex =
          '4fd172c0ae1a32f3f4b2a2a1f531178cfb7cfd96f85a98051b08ab4fe09b749a';

      final expectedSharedHex =
          'a82c0eec81f8f59f96adfc56d558ff652199dae905585861ccc6160a5c0d8d33';
      final expectedShared = uint8ArrayFromHexString(expectedSharedHex);

      final got = deriveSS(ephemeralPubCompressed, recipientPrivHex);
      expect(got, equals(expectedShared));
    });

    test('Invalid ephemeral public key => throws ArgumentError', () {
      final invalidPub =
          uint8ArrayFromHexString('03'); // Invalid compressed public key
      final priv = '01';
      expect(() => deriveSS(invalidPub, priv), throwsArgumentError);
    });

    test('Corrupted ephemeral public key => bad prefix => throws ArgumentError',
        () {
      final invalidPub = Uint8List(33); // Corrupted public key
      invalidPub[0] = 0x07; // Invalid prefix
      final priv = '01';
      expect(() => deriveSS(invalidPub, priv), throwsArgumentError);
    });

    test(
        'Uncompressed ephemeral => known 65-byte input => correct derived length',
        () {
      final ephemeralPubUncomp = uint8ArrayFromHexString(
          '044bf0ee44fed86067171d327958bfa5da6260533b81f4a5a431a112164f1b396a9bf22ce0190bf90382fa2f88db4f1fa304cc1651dc7ed3d2fbb17ec44a76ada4');
      final recipientPrivHex =
          'abcb1042ef9dff49908d90d721ae3d5325dbfb26bcf0878e88f87cb608bc9048';

      final expectedSharedHex =
          '281d3a091d25b0990f2d9cb13af2a48afc0f95ae78f540eb1035a9bd5c3ef48c';
      final expectedShared = uint8ArrayFromHexString(expectedSharedHex);

      final got = deriveSS(ephemeralPubUncomp, recipientPrivHex);
      expect(got, equals(expectedShared));
    });

    test('Very small private key => throws ArgumentError', () {
      final ephemeralPubCompressed = uint8ArrayFromHexString(
          '0472f15632f7a654032950ca563a70cda11c3a92b43a2a7a35e372c3d68df54b04a7ec89abf4a8fe3bee092c05a66521eb3dabfd18e66b2b83dbfffb2ab4ab8abf');
      final smallPrivHex = '01';

      expect(() => deriveSS(ephemeralPubCompressed, smallPrivHex),
          throwsArgumentError);
    });
  });

  group('buildAdditionalAssociatedData tests', () {
    test('Concatenates non-empty sender and receiver public buffers', () {
      final senderPubBuf = Uint8List.fromList([1, 2, 3, 4]);
      final receiverPubBuf = Uint8List.fromList([5, 6, 7, 8]);

      final expected = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      final result =
          buildAdditionalAssociatedData(senderPubBuf, receiverPubBuf);

      expect(result, equals(expected));
    });

    test('Handles empty sender public buffer', () {
      final senderPubBuf = Uint8List.fromList([]);
      final receiverPubBuf = Uint8List.fromList([9, 10, 11, 12]);

      final expected = Uint8List.fromList([9, 10, 11, 12]);
      final result =
          buildAdditionalAssociatedData(senderPubBuf, receiverPubBuf);

      expect(result, equals(expected));
    });

    test('Handles empty receiver public buffer', () {
      final senderPubBuf = Uint8List.fromList([13, 14, 15, 16]);
      final receiverPubBuf = Uint8List.fromList([]);

      final expected = Uint8List.fromList([13, 14, 15, 16]);
      final result =
          buildAdditionalAssociatedData(senderPubBuf, receiverPubBuf);

      expect(result, equals(expected));
    });

    test('Handles both sender and receiver buffers being empty', () {
      final senderPubBuf = Uint8List.fromList([]);
      final receiverPubBuf = Uint8List.fromList([]);

      final expected = Uint8List.fromList([]);
      final result =
          buildAdditionalAssociatedData(senderPubBuf, receiverPubBuf);

      expect(result, equals(expected));
    });
  });

  group('getPublicKey tests', () {
    test('Valid 32-byte hex => compressed public key', () {
      final privHex =
          'd10d5ab30f9ec176728a2e996058b925a0edf14e4df0876c1005293b889b5e83';
      final pubCompressed = getPublicKey(privHex, isCompressed: true);
      final expectedCompressedHex =
          '03d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee540516210';

      expect(pubCompressed.length, 33);
      expect(pubCompressed, uint8ArrayFromHexString(expectedCompressedHex));
    });

    test('Valid 32-byte hex => uncompressed public key', () {
      final privHex =
          'd10d5ab30f9ec176728a2e996058b925a0edf14e4df0876c1005293b889b5e83';
      final pubUncompressed = getPublicKey(privHex, isCompressed: false);
      final expectedUncompressedHex =
          '04d73cd9e1b629651fc1d94efc9f51df1f1d20e86ea1081744e5d66ee54051621044114ddc57ee52866a83d8156cd509fa68a2916466d812431781262de37855ef';

      expect(pubUncompressed.length, 65);
      expect(pubUncompressed, uint8ArrayFromHexString(expectedUncompressedHex));
    });

    test('Valid 32-byte Uint8List => compressed public key', () {
      final privBytes = uint8ArrayFromHexString(
          'b9517a3082352ac11004c2ad2f0e725b04075cfe8c94fa8764f1455808b1de5e');
      final pubCompressed = getPublicKey(privBytes, isCompressed: true);
      final expectedCompressedHex =
          '028c36835fb4a73bbf433e4a92c16d35d2625d0f9e5490ec0d4238094ece23dbfc';

      expect(pubCompressed.length, 33);
      expect(pubCompressed, uint8ArrayFromHexString(expectedCompressedHex));
    });

    test('Invalid hex length => throws ArgumentError', () {
      final shortHex = 'aabbcc';

      expect(() => getPublicKey(shortHex), throwsArgumentError);
    });

    test('Invalid Uint8List length => throws ArgumentError', () {
      final invalidBytes = Uint8List(31);

      expect(() => getPublicKey(invalidBytes), throwsArgumentError);
    });

    test('Compare with known ephemeral private key => uncompressed match', () {
      final ephemeralPrivHex =
          '99a7734ccc510e4a69519714950023d17e203a636606fb8e8eb74acbacadbe77';
      final expectedPubHex =
          '0490d6737d301376272cfe66e567482ec0c24ab4855f77b1d9409d503ec48bdb72c41332defbac1dae7415bc4d637c8d1e11ee7522c02ce861c1cd79c0be88a5b8';

      final gotPub = getPublicKey(ephemeralPrivHex, isCompressed: false);
      final expectedPub = uint8ArrayFromHexString(expectedPubHex);

      expect(gotPub, equals(expectedPub));
    });
  });
  group('decryptCredentialBundle Tests', () {
    const mockSenderPrivateKey =
        "67ee05fc3bdf4161bc70701c221d8d77180294cefcfcea64ba83c4d4c732fcb9";
    const mockPrivateKey =
        "20fa65df11f24833790ae283fc9a0c215eecbbc589549767977994dc69d05a56";
    const mockCredentialBundle =
        "w99a5xV6A75TfoAUkZn869fVyDYvgVsKrawMALZXmrauZd8hEv66EkPU1Z42CUaHESQjcA5bqd8dynTGBMLWB9ewtXWPEVbZvocB4Tw2K1vQVp7uwjf";

    test('decryptCredentialBundle successfully decrypts a valid bundle', () {
      final decryptedData = decryptCredentialBundle(
        credentialBundle: mockCredentialBundle,
        embeddedKey: mockPrivateKey,
      );

      expect(decryptedData, mockSenderPrivateKey);
    });

    test('decryptCredentialBundle throws an error for invalid bundle', () {
      const invalidBundle = "invalidBase58CheckData";

      expect(
        () => decryptCredentialBundle(
          credentialBundle: invalidBundle,
          embeddedKey: mockPrivateKey,
        ),
        throwsException,
      );
    });

    test('decryptCredentialBundle throws an error for incorrect private key',
        () {
      const incorrectPrivateKey =
          "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

      expect(
        () => decryptCredentialBundle(
          credentialBundle: mockCredentialBundle,
          embeddedKey: incorrectPrivateKey,
        ),
        throwsException,
      );
    });
  });

  group('loadPublicKey Tests', () {
    test('Valid public key bytes => returns ECPublicKey', () {
      final validPublicKeyBytes = Uint8List.fromList([
        4,
        215,
        60,
        217,
        225,
        182,
        41,
        101,
        31,
        193,
        217,
        78,
        252,
        159,
        81,
        223,
        31,
        29,
        32,
        232,
        110,
        161,
        8,
        23,
        68,
        229,
        214,
        110,
        229,
        64,
        81,
        98,
        16,
        68,
        17,
        77,
        220,
        87,
        238,
        82,
        134,
        106,
        131,
        216,
        21,
        108,
        213,
        9,
        250,
        104,
        162,
        145,
        100,
        102,
        216,
        18,
        67,
        23,
        129,
        38,
        45,
        227,
        120,
        85,
        239
      ]);
      final publicKey = loadPublicKey(validPublicKeyBytes);

      expect(publicKey, isA<ECPublicKey>());
      expect(publicKey.Q!.x, isNotNull);
      expect(publicKey.Q!.y, isNotNull);
    });

    test('Invalid public key bytes => throws ArgumentError', () {
      final invalidPublicKeyBytes = Uint8List.fromList([0x02, 0x01, 0x02]);

      expect(() => loadPublicKey(invalidPublicKeyBytes), throwsArgumentError);
    });

    test('Empty public key bytes => throws ArgumentError', () {
      final emptyPublicKeyBytes = Uint8List(0);

      expect(() => loadPublicKey(emptyPublicKeyBytes), throwsArgumentError);
    });

    test('Compressed public key bytes => throws ArgumentError', () {
      final compressedPublicKeyBytes = Uint8List.fromList([
        2,
        215,
        60,
        217,
        225,
        182,
        41,
        101,
        31,
        193,
        217,
        78,
        252,
        159,
        81,
        223,
        31,
        29,
        32,
        232,
        110,
        161,
        8,
        23,
        68,
        229,
        214,
        110,
        229,
        64,
        81,
        98
      ]);

      expect(
          () => loadPublicKey(compressedPublicKeyBytes), throwsArgumentError);
    });
  });

  group('fromDerSignature Tests', () {
    test('Valid DER signature => normalized r and s components', () {
      final derSignature =
          '304402201a8bc9bf9ae2745b6db1f3b073b8cf36c9c3f792e5d2ec182d96f86e26eaf0420220609d4b5145d4e9b1d745eb57c1532a98f541f5c72b6b7ad8c0a2e8471d96f5c5';
      final expectedResult = Uint8List.fromList([
        26,
        139,
        201,
        191,
        154,
        226,
        116,
        91,
        109,
        177,
        243,
        176,
        115,
        184,
        207,
        54,
        201,
        195,
        247,
        146,
        229,
        210,
        236,
        24,
        45,
        150,
        248,
        110,
        38,
        234,
        240,
        66,
        96,
        157,
        75,
        81,
        69,
        212,
        233,
        177,
        215,
        69,
        235,
        87,
        193,
        83,
        42,
        152,
        245,
        65,
        245,
        199,
        43,
        107,
        122,
        216,
        192,
        162,
        232,
        71,
        29,
        150,
        245,
        197
      ]);
      final result = fromDerSignature(derSignature);

      expect(result, equals(expectedResult));
    });

    test(
        'Invalid DER signature - invalid r tag => normalized r and s components',
        () {
      final invalidDerSignature =
          '304402201a8bc9bf9ae2745b6db1f3b073b8cf36c9c3f792e5d2ec182d96f86e26eaf0020220609d4b5145d4e9b1d745eb57c1532a98f541f5c72b6b7ad8c0a2e8471d96f5c5';
      final expectedResult = Uint8List.fromList([
        26,
        139,
        201,
        191,
        154,
        226,
        116,
        91,
        109,
        177,
        243,
        176,
        115,
        184,
        207,
        54,
        201,
        195,
        247,
        146,
        229,
        210,
        236,
        24,
        45,
        150,
        248,
        110,
        38,
        234,
        240,
        2,
        96,
        157,
        75,
        81,
        69,
        212,
        233,
        177,
        215,
        69,
        235,
        87,
        193,
        83,
        42,
        152,
        245,
        65,
        245,
        199,
        43,
        107,
        122,
        216,
        192,
        162,
        232,
        71,
        29,
        150,
        245,
        197
      ]);
      final result = fromDerSignature(invalidDerSignature);

      expect(result, equals(expectedResult));
    });

    test('Invalid DER signature - invalid s tag => throws ArgumentError', () {
      final invalidDerSignature =
          '304402201a8bc9bf9ae2745b6db1f3b073b8cf36c9c3f792e5d2ec182d96f86e26eaf0420230609d4b5145d4e9b1d745eb57c1532a98f541f5c72b6b7ad8c0a2e8471d96f5c5';

      expect(() => fromDerSignature(invalidDerSignature), throwsArgumentError);
    });

    test('Short DER signature => throws ArgumentError', () {
      final shortDerSignature = '30440220';

      expect(() => fromDerSignature(shortDerSignature), throwsArgumentError);
    });

    test('Valid DER signature with short r or s => correctly padded', () {
      final derSignature = '3022020100020100';
      final expectedResult = Uint8List.fromList([
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]);
      final result = fromDerSignature(derSignature);

      expect(result, equals(expectedResult));
    });
  });

  group('verifyEnclaveSignature Tests', () {
    const validEnclaveQuorumPublic =
        '04595ed0c8b500e3ce5c7ad1c904a5cde7f29e53ef253e8949182d9806a06d89fe0bf17d0da776b4031e2a90a2ff9710efd082d623b97b2856ca9f5a11c3b7ef43';
    const validPublicSignature =
        '30440220257e9689b54d355709f93876219bc95133eb62ea8c6013492a42dc9889fc2d5902203e2a8772dce41ea457790de0e32f6e56379290e3e39ca7cdd6a16a772a0e0388';
    const validSignedData =
        '86a3c2c1b359cd89bdb707f221bc0c93eab9d10bc16cc301e91ecbb700fbcf71';

    const invalidEnclaveQuorumPublic =
        '048eef6caa4e098cc1c3dcb9ad6a7b5b69b1e734a08c19fd326f7485a8e45c03d7b460de7a1bf314f2a550a23f3e02a1d4dc124f29395e2c7ed9c5c91a76077157';
    const invalidPublicSignature =
        '3045022100b2f5c3b83914c837ff5a8e7d5f3f2c6317b59a23768e2a4df8e0f73d47f3e97a0220049d5dbff61985d43480ac31304eeb1cd98cde7f539e9fbb640f7807eaa7e64a';

    test('Valid signature with matching public key', () {
      final result = verifyEnclaveSignature(
        enclaveQuorumPublic: validEnclaveQuorumPublic,
        publicSignature: validPublicSignature,
        signedData: validSignedData,
        dangerouslyOverrideSignerPublicKey: validEnclaveQuorumPublic,
      );
      expect(result, isTrue);
    });

    test('Invalid signature with mismatched public key => throws ArgumentError',
        () {
      expect(
        () => verifyEnclaveSignature(
          enclaveQuorumPublic: invalidEnclaveQuorumPublic,
          publicSignature: validPublicSignature,
          signedData: validSignedData,
          dangerouslyOverrideSignerPublicKey: validEnclaveQuorumPublic,
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Valid signature but incorrect signed data => returns false', () {
      const incorrectSignedData =
          'e1a24f1cb1e2f96d6b1cf7f63e2816d6c89e49e576b1618c5db4f19e23909c7a';

      final result = verifyEnclaveSignature(
        enclaveQuorumPublic: validEnclaveQuorumPublic,
        publicSignature: validPublicSignature,
        signedData: incorrectSignedData,
        dangerouslyOverrideSignerPublicKey: validEnclaveQuorumPublic,
      );
      expect(result, isFalse);
    });

    // I'm not sure if this makes sense. The signature is invalid, should it return false or throw an error?
    // TODO: Investigate what the javascript implementation does
    test('Invalid signature format => returns false', () {
      final result = verifyEnclaveSignature(
        enclaveQuorumPublic: validEnclaveQuorumPublic,
        publicSignature: invalidPublicSignature,
        signedData: validSignedData,
        dangerouslyOverrideSignerPublicKey: validEnclaveQuorumPublic,
      );

      expect(result, isFalse);
    });
  });

  // TODO: Add tests for other cases
  group('decryptExportBundle Tests', () {
  test('decryptExportBundle successfully decrypts a valid bundle - mnemonic ', () async {
    const exportBundle = '''
      {
        "version": "v1.0.0",
        "data": "7b22656e6361707065645075626c6963223a2230343434313065633837653566653266666461313561313866613337376132316133633431633334373666383631333362343238306164373631303266343064356462326463353362343730303763636139336166666330613535316464353134333937643039373931636664393233306663613330343862313731663364363738222c2263697068657274657874223a22656662303538626633666634626534653232323330326266326636303738363062343237346232623031616339343536643362613638646135613235363236303030613839383262313465306261663061306465323966353434353461333739613362653664633364386339343938376131353638633764393566396663346239316265663232316165356562383432333361323833323131346431373962646664636631643066376164656231353766343131613439383430222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437227d",
        "dataSignature": "304502203a7dc258590a637e76f6be6ed1a2080eed5614175060b9073f5e36592bdaf610022100ab9955b603df6cf45408067f652da48551652451b91967bf37dd094d13a7bdd4",
        "enclaveQuorumPublic": "04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"
      }
    ''';

    const privateKey =
        'ffc6090f14bcf260e5dfe63f45412e60a477bb905956d7cc90195b71c2a544b3';

    const expectedMnemonic =
        'leaf lady until indicate praise final route toast cake minimum insect unknown';

    final result = await decryptExportBundle(
      exportBundle: exportBundle,
      embeddedKey: privateKey,
      organizationId: 'f9a31c64-d604-42e4-9bef-a773096afad7',
      keyFormat: 'HEXADECIMAL',
      returnMnemonic: true,
    );

    expect(result, expectedMnemonic);
  });
});

test('decryptExportBundle successfully decrypts a valid bundle - non-mnemonic', () async {
    const exportBundle = '''
      {
        "version": "v1.0.0",
        "data": "7b22656e6361707065645075626c6963223a2230343434313065633837653566653266666461313561313866613337376132316133633431633334373666383631333362343238306164373631303266343064356462326463353362343730303763636139336166666330613535316464353134333937643039373931636664393233306663613330343862313731663364363738222c2263697068657274657874223a22656662303538626633666634626534653232323330326266326636303738363062343237346232623031616339343536643362613638646135613235363236303030613839383262313465306261663061306465323966353434353461333739613362653664633364386339343938376131353638633764393566396663346239316265663232316165356562383432333361323833323131346431373962646664636631643066376164656231353766343131613439383430222c226f7267616e697a6174696f6e4964223a2266396133316336342d643630342d343265342d396265662d613737333039366166616437227d",
        "dataSignature": "304502203a7dc258590a637e76f6be6ed1a2080eed5614175060b9073f5e36592bdaf610022100ab9955b603df6cf45408067f652da48551652451b91967bf37dd094d13a7bdd4",
        "enclaveQuorumPublic": "04cf288fe433cc4e1aa0ce1632feac4ea26bf2f5a09dcfe5a42c398e06898710330f0572882f4dbdf0f5304b8fc8703acd69adca9a4bbf7f5d00d20a5e364b2569"
      }
    ''';

    const privateKey =
        'ffc6090f14bcf260e5dfe63f45412e60a477bb905956d7cc90195b71c2a544b3';

    const expectedNonMnemonic =
        '6c656166206c61647920756e74696c20696e646963617465207072616973652066696e616c20726f75746520746f6173742063616b65206d696e696d756d20696e7365637420756e6b6e6f776e';

    final result = await decryptExportBundle(
      exportBundle: exportBundle,
      embeddedKey: privateKey,
      organizationId: 'f9a31c64-d604-42e4-9bef-a773096afad7',
      keyFormat: 'HEXADECIMAL',
      returnMnemonic: false,
    );

    expect(result, expectedNonMnemonic);
  });


}
