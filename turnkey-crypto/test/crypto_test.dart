import 'package:test/test.dart';
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
}