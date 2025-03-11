import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

/// Retrieves the stored embedded key from secure storage.
/// Optionally deletes the key from storage after retrieval.
///
/// [deleteKey] Whether to remove the embedded key after retrieval. Defaults to `true`.
/// Returns the embedded private key if found, otherwise `null`.
/// Throws if retrieving or deleting the key fails.
Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
  final key = await _secureStorage.read(key: StorageKeys.EmbeddedKey.value);
  if (deleteKey) {
    await _secureStorage.delete(key: StorageKeys.EmbeddedKey.value);
  }

  return key;
}

/// Saves an embedded key securely in storage.
///
/// [key] The private key to store securely.
/// Throws if saving the key fails.
Future<void> saveEmbeddedKey(String key) async {
  await _secureStorage.write(key: StorageKeys.EmbeddedKey.value, value: key);
}

/// Retrieves a stored session from secure storage.
///
/// [sessionKey] The unique key identifying the session.
/// Returns the session object if found, otherwise `null`.
/// Throws if retrieving the session fails.
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
/// Throws if saving the session fails.
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
/// Throws if deleting the session fails.
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
/// Throws if retrieving the session key fails.
Future<String?> getSelectedSessionKey() async {
  try {
    return await _secureStorage.read(key: StorageKeys.SelectedSession.value);
  } catch (e) {
    throw Exception("Failed to get selected session: $e");
  }
}

/// Saves the selected session key to secure storage.
///
/// [sessionKey] The session key to mark as selected.
/// Throws if saving the session key fails.
Future<void> saveSelectedSessionKey(String sessionKey) async {
  try {
    await _secureStorage.write(
      key: StorageKeys.SelectedSession.value,
      value: sessionKey,
    );
  } catch (e) {
    throw Exception("Failed to save selected session: $e");
  }
}

/// Clears the selected session key from secure storage.
///
/// Throws if deleting the session key fails.
Future<void> clearSelectedSessionKey() async {
  try {
    await _secureStorage.delete(key: StorageKeys.SelectedSession.value);
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
/// Throws if the session key already exists or saving fails.
Future<void> addSessionKey(String sessionKey) async {
  try {
    final indexStr =
        await _secureStorage.read(key: StorageKeys.SessionKeys.value);

    List<String> keys = [];

    if (indexStr != null) {
      try {
        keys = List<String>.from(jsonDecode(indexStr));
      } catch (e) {
        throw Exception("Failed to parse session list: $e");
      }
    }

    if (keys.contains(sessionKey)) {
      return;
    }

    keys.add(sessionKey);
    await _secureStorage.write(
      key: StorageKeys.SessionKeys.value,
      value: jsonEncode(keys),
    );
  } catch (e) {
    throw Exception("Failed to add session key: $e");
  }
}

/// Retrieves all session keys stored in the session index.
///
/// Returns an array of session keys stored in secure storage.
/// Throws if retrieving the session list fails.
Future<List<String>> getSessionKeys() async {
  try {
    final indexStr =
        await _secureStorage.read(key: StorageKeys.SessionKeys.value);

    if (indexStr == null) {
      return [];
    }

    try {
      final keys = List<String>.from(jsonDecode(indexStr));

      return keys;
    } catch (e) {
      throw Exception("Failed to parse session list: $e");
    }
  } catch (e) {
    throw Exception("Failed to retrieve session list: $e");
  }
}

/// Removes a session key from the session index in secure storage.
///
/// - Fetches the existing session key index.
/// - Removes the specified session key.
/// - Saves the updated session index back to secure storage.
///
/// [sessionKey] The session key to remove from the index.
/// Throws if removing the session key fails.
Future<void> removeSessionKey(String sessionKey) async {
  try {
    final indexStr =
        await _secureStorage.read(key: StorageKeys.SessionKeys.value);

    List<String> keys = [];

    if (indexStr != null) {
      try {
        keys = List<String>.from(jsonDecode(indexStr));
      } catch (e) {
        throw Exception("Failed to parse session list: $e");
      }
    }

    final updatedKeys = keys.where((key) => key != sessionKey).toList();

    await _secureStorage.write(
      key: StorageKeys.SessionKeys.value,
      value: jsonEncode(updatedKeys),
    );
  } catch (e) {
    throw Exception("Failed to remove session key: $e");
  }
}
