import 'package:elliptic/elliptic.dart';

class KeyPair {
  final String privateKey;
  final String publicKey;

  KeyPair({required this.privateKey, required this.publicKey});
}

Future<KeyPair> generateP256KeyPair() async {
  final ec = getP256();
  final privateKey = ec.generatePrivateKey();
  final publicKey = privateKey.publicKey;

  return KeyPair(
    privateKey: privateKey.toHex(),
    publicKey: publicKey.toHex(),
  );
}
