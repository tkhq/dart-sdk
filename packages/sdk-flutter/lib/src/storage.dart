import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

/// Creates an embedded key pair and stores the private key securely.
///
/// Returns the public key.
Future<String> createEmbeddedKey() async {
  final keyPair = await generateP256KeyPair();
  final embeddedPrivateKey = keyPair.privateKey;
  final publicKey = keyPair.publicKeyUncompressed;

  await _saveEmbeddedKey(embeddedPrivateKey);

  return publicKey;
}

/// Retrieves the embedded private key from secure storage.
///
/// If [deleteKey] is true (default), the key will be deleted after retrieval.
Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
  final key = await _secureStorage.read(
      key: SessionKey.turnkeyEmbeddedKeyStorage.toString());
  if (deleteKey) {
    await _secureStorage.delete(
        key: SessionKey.turnkeyEmbeddedKeyStorage.toString());
  }

  return key;
}

/// Saves the embedded private key securely.
Future<void> _saveEmbeddedKey(String key) async {
  await _secureStorage.write(
      key: SessionKey.turnkeyEmbeddedKeyStorage.toString(), value: key);
}

/// Retrieves the current session from secure storage.
///
/// Returns the session if it exists, otherwise null.
Future<Session?> getSession(String sessionKey) async {
  final sessionJson = await _secureStorage.read(key: sessionKey);
  print('sessionJson: $sessionJson');
  if (sessionJson != null) {
    return Session.fromJson(jsonDecode(sessionJson));
  }
  return null;
}

/// Saves the session to secure storage.
Future<void> saveSession(
  Session session,
  String sessionKey,
) async {
  try {
    await _secureStorage.write(
        key: sessionKey, value: jsonEncode(session.toJson()));
  } catch (e) {
    throw Exception("Failed to save session: $e");
  }
}

Future<void> resetSession(String sessionKey) async {
  try {
    await _secureStorage.delete(key: sessionKey);
  } catch (e) {
    throw Exception("Failed to reset session: $e");
  }
}

Future<String?> getSelectedSessionKey() async {
  try {
    return await _secureStorage.read(
        key: SessionKey.turnkeySelectedSession.toString());
  } catch (e) {
    throw Exception("Failed to get selected session: $e");
  }
}

Future<void> saveSelectedSessionKey(String sessionKey) async {
  try {
    await _secureStorage.write(
      key: SessionKey.turnkeySelectedSession.toString(),
      value: sessionKey,
    );
  } catch (e) {
    throw Exception("Failed to save selected session: $e");
  }
}

Future<void> clearSelectedSessionKey() async {
  try {
    await _secureStorage.delete(
        key: SessionKey.turnkeySelectedSession.toString());
  } catch (e) {
    throw Exception("Failed to clear selected session: $e");
  }
}

Future<void> addSessionKeyToIndex(String sessionKey) async {
  try {
    final indexStr = await _secureStorage.read(
        key: SessionKey.turnkeySessionKeysIndex.toString());
    List<String> keys =
        indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
    if (!keys.contains(sessionKey)) {
      keys.add(sessionKey);
      await _secureStorage.write(
          key: SessionKey.turnkeySessionKeysIndex.toString(),
          value: jsonEncode(keys));
    }
  } catch (error) {
    throw Exception("Failed to add session key to index: $error");
  }
}

Future<List<String>> getSessionKeysIndex() async {
  try {
    final indexStr = await _secureStorage.read(
        key: SessionKey.turnkeySessionKeysIndex.toString());
    return indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
  } catch (error) {
    throw Exception("Failed to get session keys index: $error");
  }
}

Future<void> removeSessionKeyFromIndex(String sessionKey) async {
  try {
    final indexStr = await _secureStorage.read(
        key: SessionKey.turnkeySessionKeysIndex.toString());
    List<String> keys =
        indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
    keys = keys.where((key) => key != sessionKey).toList();
    await _secureStorage.write(
        key: SessionKey.turnkeySessionKeysIndex.toString(),
        value: jsonEncode(keys));
  } catch (error) {
    throw Exception("Failed to remove session key from index: $error");
  }
}
