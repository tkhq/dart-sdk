import 'package:test/test.dart';
import 'package:turnkey_crypto/crypto.dart';

void main() {
  group('modSqrt tests (p % 4 == 3)', () {
    test('Basic case: p=3, x=1 => result=1', () {
      final p = BigInt.from(3);
      final x = BigInt.one;
      final sqrtX = modSqrt(x, p);

      expect((sqrtX * sqrtX) % p, equals(x));
      expect(sqrtX, equals(BigInt.one));
    });

    test('p=7, x=2 => result could be 3 or 4', () {
      final p = BigInt.from(7);
      final x = BigInt.from(2);
      final sqrtX = modSqrt(x, p);

      expect((sqrtX * sqrtX) % p, equals(x));
      // Usually returns 3, but 4 is also valid in modular arithmetic.
      expect(sqrtX == BigInt.from(3) || sqrtX == BigInt.from(4), isTrue);
    });

    test('Non-residue: p=7, x=3 => throws ArgumentError', () {
      final p = BigInt.from(7);
      final x = BigInt.from(3);
      expect(() => modSqrt(x, p), throwsArgumentError);
    });
  });

  group('Unsupported prime (p % 4 != 3)', () {
    test('p=5 => throws UnsupportedError', () {
      final p = BigInt.from(5);
      expect(() => modSqrt(BigInt.one, p), throwsA(isA<UnsupportedError>()));
    });
  });

  group('Edge cases & invalid inputs', () {
    test('p <= 0 => throws ArgumentError', () {
      expect(() => modSqrt(BigInt.one, BigInt.zero),
          throwsA(isA<ArgumentError>()));
      expect(() => modSqrt(BigInt.one, BigInt.from(-11)),
          throwsA(isA<ArgumentError>()));
    });

    test('x < 0 => still interpreted mod p but might be non-residue', () {
      final p = BigInt.from(7);
      // -1 mod 7 = 6, which is a known non-residue.
      expect(() => modSqrt(BigInt.from(-1), p), throwsArgumentError);
    });
  });
}
