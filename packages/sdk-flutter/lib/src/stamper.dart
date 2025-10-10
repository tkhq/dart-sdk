import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

/// Stores private keys in secure storage and signs payloads.
class SecureStorageStamper implements TStamper {
  static const _storage = FlutterSecureStorage();

  /// Optional public key associated with this stamper instance.
  String? publicKey;

  /// Constructor — optionally pass a public key at initialization.
  SecureStorageStamper({this.publicKey});

  /// ✅ Update the public key later
  void setPublicKey(String newPublicKey) {
    publicKey = newPublicKey;
  }

  /// ✅ List all stored key pairs (public keys)
  static Future<List<String>> listKeyPairs() async {
    final all = await _storage.readAll();
    return all.keys.toList();
  }

  /// ✅ Delete all key pairs
  static Future<void> clearKeyPairs() async {
    final keys = await listKeyPairs();
    for (final key in keys) {
      await deleteKeyPair(key);
    }
  }

  /// ✅ Create a new key pair (or store an external one)
  static Future<String> createKeyPair({
    String? externalPublicKey,
    String? externalPrivateKey,
  }) async {
    String privateKey;
    String publicKey;

    if (externalPrivateKey != null && externalPublicKey != null) {
      privateKey = externalPrivateKey;
      publicKey = externalPublicKey;
    } else {
      final pair = await generateP256KeyPair();
      privateKey = pair.privateKey;
      publicKey = pair.publicKey;
    }

    // Store private key securely with public key as the identifier
    await _storage.write(key: publicKey, value: privateKey);
    return publicKey;
  }

  /// ✅ Delete a key pair by its public key
  static Future<void> deleteKeyPair(String publicKeyHex) async {
    await _storage.delete(key: publicKeyHex);
  }

  /// ✅ Get the private key associated with a public key
  static Future<String?> _getPrivateKey(String publicKeyHex) async {
    return await _storage.read(key: publicKeyHex);
  }

  /// ✅ Sign a payload with the key pair (stamping)
  ///
  /// If [publicKeyHex] is provided, it takes priority.
  /// Otherwise, the instance-level [publicKey] will be used.
  /// If neither is available, an exception is thrown.
  @override
  Future<TStamp> stamp(String payload, {String? publicKeyHex}) async {
    final keyToUse = publicKeyHex ?? publicKey;
    if (keyToUse == null) {
      throw Exception(
        "No public key provided. Pass one to `stamp()` or set it with `setPublicKey()`.",
      );
    }

    final privateKey = await _getPrivateKey(keyToUse);
    if (privateKey == null) {
      throw Exception("No private key found for public key: $keyToUse");
    }

    final stamper = ApiKeyStamper(
      ApiKeyStamperConfig(
        apiPublicKey: keyToUse,
        apiPrivateKey: privateKey,
      ),
    );

    final result = await stamper.stamp(payload);
    return TStamp(
      stampHeaderName: result.stampHeaderName,
      stampHeaderValue: result.stampHeaderValue,
    );
  }
}
