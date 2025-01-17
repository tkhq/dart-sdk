import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:elliptic/elliptic.dart';
import 'package:ecdsa/ecdsa.dart';

String signWithApiKey(String publicKey, String privateKey, String content) {
  
  var ec = getP256();

  var ecPrivateKey = PrivateKey.fromHex(ec, privateKey);

  var publicKeyString = ec.privateToPublicKey(ecPrivateKey).toCompressedHex();    

  if (publicKeyString != publicKey) {
    throw Exception(
      'Bad API key. Expected to get public key $publicKey, got $publicKeyString'
    );
  }

  var bytes = utf8.encode(content);
  var hash = sha256.convert(bytes);

  var sig = deterministicSign(ecPrivateKey, hash.bytes);

  // Enforce low S value
  var curveOrder = ec.n;
  var sBigInt = sig.S;

  sBigInt = curveOrder - sBigInt;
  sig.S = sBigInt;

  return(sig.toDERHex());

}