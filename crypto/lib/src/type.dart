/// Represents a P-256 key pair.
class KeyPair {
  final String privateKey;
  final String publicKey;
  final String publicKeyUncompressed;

  KeyPair({
    required this.privateKey,
    required this.publicKey,
    required this.publicKeyUncompressed,
  });
}
