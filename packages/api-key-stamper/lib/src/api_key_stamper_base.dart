import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:elliptic/elliptic.dart';
import 'package:ecdsa/ecdsa.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';
import 'package:turnkey_http/base.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';

class ApiKeyStamperConfig {
  final String apiPublicKey;

  final String apiPrivateKey;

  ApiKeyStamperConfig({
    required this.apiPublicKey,
    required this.apiPrivateKey,
  });
}

enum SignatureFormat {
  der,
  raw
}

String signWithApiKey(String publicKey, String privateKey, String content, {SignatureFormat format = SignatureFormat.der}) {
  var ec = getP256();

  var ecPrivateKey = PrivateKey.fromHex(ec, privateKey);

  var publicKeyString = ec.privateToPublicKey(ecPrivateKey).toCompressedHex();

  if (publicKeyString != publicKey) {
    throw Exception(
        'Bad API key. Expected to get public key $publicKey, got $publicKeyString');
  }

  var bytes = utf8.encode(content);
  var hash = sha256.convert(bytes);

  var sig = deterministicSign(ecPrivateKey, hash.bytes);

  // Enforce low S value. Parity with the JS implementation.
  var curveOrder = ec.n;
  var sBigInt = sig.S;

  sBigInt = curveOrder - sBigInt;
  sig.S = sBigInt;

  if (format == SignatureFormat.raw) {
    final rawBytes = fromDerSignature(sig.toDERHex());
    return uint8ArrayToHexString(rawBytes);
  } else if (format == SignatureFormat.der) {
    return (sig.toDERHex());
  } else {
    throw Exception('Unsupported signature format: $format');
  }
}

class ApiKeyStamper implements TStamper {
  final String apiPublicKey;
  final String apiPrivateKey;

  var stampHeaderName = "X-Stamp";

  ApiKeyStamper(ApiKeyStamperConfig config)
      : apiPublicKey = config.apiPublicKey,
        apiPrivateKey = config.apiPrivateKey;

  @override
  Future<TStamp> stamp(String content) async {
    var signature = signWithApiKey(apiPublicKey, apiPrivateKey, content);

    var stamp = {
      "publicKey": apiPublicKey,
      "scheme": "SIGNATURE_SCHEME_TK_API_P256",
      "signature": signature,
    };

    return TStamp(
      stampHeaderName: stampHeaderName,
      stampHeaderValue: stringToBase64urlString(jsonEncode(stamp)),
    );
  }

  Future<String> sign(String content, SignatureFormat format) async {
    return signWithApiKey(apiPublicKey, apiPrivateKey, content, format: format);
  }
}
