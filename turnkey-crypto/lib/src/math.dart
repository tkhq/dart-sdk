/// Compute the modular square root using the Tonelli-Shanks algorithm.
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

/// Test if a specific bit is set in a BigInt.
bool testBit(BigInt n, int i) {
  final m = BigInt.one << i;
  return (n & m) != BigInt.zero;
}

/// Compute the modular exponentiation.
BigInt modPow(BigInt b, BigInt exp, BigInt p) {
  if (exp == BigInt.zero) {
    return BigInt.one;
  }

  BigInt result = b %
      p; // Start with base reduced modulo p to ensure the initial value is within bounds, TODO: should we also do this in javascript?

  final exponentBitString = exp.toRadixString(2);

  for (int i = 1; i < exponentBitString.length; ++i) {
    result = (result * result) % p;
    if (exponentBitString[i] == '1') {
      result = (result * b) % p;
    }
  }
  return result;
}
