import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

/// Generates a new embedded key pair and securely stores the private key in secure storage.
///
/// Returns the public key corresponding to the generated embedded key pair.
Future<String> createEmbeddedKey() async {
  final keyPair = await generateP256KeyPair();
  final embeddedPrivateKey = keyPair.privateKey;
  final publicKey = keyPair.publicKeyUncompressed;

  await _saveEmbeddedKey(embeddedPrivateKey);

  return publicKey;
}

/// Retrieves the stored embedded key from secure storage.
/// Optionally deletes the key from storage after retrieval.
///
/// [deleteKey] Whether to remove the embedded key after retrieval. Defaults to `true`.
/// Returns the embedded private key if found, otherwise `null`.
Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
  final key = await _secureStorage.read(key: TURNKEY_EMBEDDED_KEY_STORAGE);
  if (deleteKey) {
    await _secureStorage.delete(key: TURNKEY_EMBEDDED_KEY_STORAGE);
  }

  return key;
}

/// Saves an embedded key securely in storage.
///
/// [key] The private key to store securely.
Future<void> _saveEmbeddedKey(String key) async {
  await _secureStorage.write(key: TURNKEY_EMBEDDED_KEY_STORAGE, value: key);
}

/// Retrieves a stored session from secure storage.
///
/// [sessionKey] The unique key identifying the session.
/// Returns the session object if found, otherwise `null`.
Future<Session?> getSession(String sessionKey) async {
  final sessionJson = await _secureStorage.read(key: sessionKey);

  if (sessionJson != null) {
    return Session.fromJson(jsonDecode(sessionJson));
  }
  return null;
}

/// Saves a session securely in storage.
///
/// [session] The session object to store securely.
/// [sessionKey] The unique key under which the session is stored.
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

/// Deletes a session from secure storage.
///
/// [sessionKey] The unique key identifying the session to reset.
Future<void> deleteSession(String sessionKey) async {
  try {
    await _secureStorage.delete(key: sessionKey);
  } catch (e) {
    throw Exception("Failed to reset session: $e");
  }
}

/// Retrieves the selected session key from secure storage.
///
/// Returns the selected session key as a string, or `null` if not found.
Future<String?> getSelectedSessionKey() async {
  try {
    return await _secureStorage.read(key: TURNKEY_SELECTED_SESSION);
  } catch (e) {
    throw Exception("Failed to get selected session: $e");
  }
}

/// Saves the selected session key to secure storage.
///
/// [sessionKey] The session key to mark as selected.
Future<void> saveSelectedSessionKey(String sessionKey) async {
  try {
    await _secureStorage.write(
      key: TURNKEY_SELECTED_SESSION,
      value: sessionKey,
    );
  } catch (e) {
    throw Exception("Failed to save selected session: $e");
  }
}

/// Clears the selected session key from secure storage.
Future<void> clearSelectedSessionKey() async {
  try {
    await _secureStorage.delete(key: TURNKEY_SELECTED_SESSION);
  } catch (e) {
    throw Exception("Failed to clear selected session: $e");
  }
}

/// Adds a session key to the session index in secure storage.
///
/// - Retrieves the existing session key index.
/// - Appends the new session key if it does not already exist.
/// - Stores the updated session index.
///
/// [sessionKey] The session key to add to the index.
Future<void> addSessionKeyToIndex(String sessionKey) async {
  try {
    final indexStr = await _secureStorage.read(key: TURNKEY_SESSION_KEYS_INDEX);
    List<String> keys =
        indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
    if (!keys.contains(sessionKey)) {
      keys.add(sessionKey);
      await _secureStorage.write(
          key: TURNKEY_SESSION_KEYS_INDEX, value: jsonEncode(keys));
    }
  } catch (error) {
    throw Exception("Failed to add session key to index: $error");
  }
}

/// Retrieves all session keys stored in the session index.
///
/// Returns an array of session keys stored in secure storage.
Future<List<String>> getSessionKeysIndex() async {
  try {
    final indexStr = await _secureStorage.read(key: TURNKEY_SESSION_KEYS_INDEX);
    return indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
  } catch (error) {
    throw Exception("Failed to get session keys index: $error");
  }
}

/// Removes a session key from the session index in secure storage.
///
/// - Fetches the existing session key index.
/// - Removes the specified session key.
/// - Saves the updated session index back to secure storage.
///
/// [sessionKey] The session key to remove from the index.
Future<void> removeSessionKeyFromIndex(String sessionKey) async {
  try {
    final indexStr = await _secureStorage.read(key: TURNKEY_SESSION_KEYS_INDEX);
    List<String> keys =
        indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
    keys = keys.where((key) => key != sessionKey).toList();
    await _secureStorage.write(
        key: TURNKEY_SESSION_KEYS_INDEX, value: jsonEncode(keys));
  } catch (error) {
    throw Exception("Failed to remove session key from index: $error");
  }
}
