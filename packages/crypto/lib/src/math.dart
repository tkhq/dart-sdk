/// Test if a specific bit is set in a BigInt
bool testBit(BigInt n, int i) {
  final m = BigInt.one << i;
  return (n & m) != BigInt.zero;
}

/// Computes the modular square root using the Tonelli-Shanks algorithm.
///
/// Parameters:
/// - [x]: The value to compute the modular square root for.
/// - [p]: The prime modulus.
///
/// Returns:
/// - The modular square root of `x` modulo `p` as a [BigInt].
///
/// Throws:
/// - [ArgumentError]: If `p` is not positive or if a modular square root
///   cannot be found.
/// - [UnsupportedError]: If `p` does not satisfy the condition `p % 4 == 3`.
BigInt modSqrt(BigInt x, BigInt p) {
  if (p <= BigInt.zero) {
    throw ArgumentError("p must be positive");
  }
  final base = x % p;

  // Check if p % 4 == 3 (applies to NIST curves P-256, P-384, and P-521)
  if (testBit(p, 0) && testBit(p, 1)) {
    final q = (p + BigInt.one) >> 2;
    final squareRoot = modPow(base, q, p);
    if ((squareRoot * squareRoot) % p != base) {
      throw ArgumentError("could not find a modular square root");
    }
    return squareRoot;
  }

  // Other elliptic curve types not supported
  throw UnsupportedError("unsupported modulus value");
}

/// Computes modular exponentiation.
///
/// Parameters:
/// - [b]: The base as a [BigInt].
/// - [exp]: The exponent as a [BigInt].
/// - [p]: The modulus as a [BigInt].
///
/// Returns:
/// - The result of `(b^exp) % p` as a [BigInt].
BigInt modPow(BigInt b, BigInt exp, BigInt p) {
  if (exp == BigInt.zero) {
    return BigInt.one;
  }

  BigInt result = b % p;
  final exponentBitString = exp.toRadixString(2);
  for (int i = 1; i < exponentBitString.length; ++i) {
    result = (result * result) % p;
    if (exponentBitString[i] == '1') {
      result = (result * b) % p;
    }
  }
  return result;
}
