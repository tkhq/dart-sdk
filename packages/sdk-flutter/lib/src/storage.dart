import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class SessionStorageManager {
  static Future<void> init() async {
    if (!Hive.isBoxOpen('turnkey_sessions')) {
      await Hive.initFlutter();
      await Hive.openBox('turnkey_sessions');
    }
  }

  static Box get _box => Hive.box('turnkey_sessions');

  /// Generic: store any JSON-serializable value
  static Future<void> setStorageValue(String key, dynamic value) async {
    await _box.put(key, jsonEncode(value));
  }

  /// Generic: retrieve a stored JSON value
  static Future<dynamic> getStorageValue(String key) async {
    final raw = _box.get(key);
    return raw != null ? jsonDecode(raw) : null;
  }

  /// Remove any storage value
  static Future<void> removeStorageValue(String key) async {
    await _box.delete(key);
  }

  /// ✅ Store a session from a JWT string
  static Future<void> storeSession(String jwtToken,
      {String? sessionKey}) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    final sessionWithMetadata = Session.fromJwt(jwtToken);
    await setStorageValue(sessionKey, sessionWithMetadata.toJson());

    final keys = await listSessionKeys();
    if (!keys.contains(sessionKey)) {
      keys.add(sessionKey);
      await setStorageValue(StorageKeys.AllSessionKeys.value, keys);
    }

    await setActiveSessionKey(sessionKey);
  }

  /// ✅ Get a session by key (returns a `Session`)
  static Future<Session?> getSession(String sessionKey) async {
    final raw = await getStorageValue(sessionKey);
    return raw != null ? Session.fromJson(raw) : null;
  }

  /// ✅ Set the active session key
  static Future<void> setActiveSessionKey(String sessionKey) async {
    await setStorageValue(StorageKeys.ActiveSessionKey.value, sessionKey);
  }

  /// ✅ Get the active session key
  static Future<String?> getActiveSessionKey() async {
    return await getStorageValue(StorageKeys.ActiveSessionKey.value);
  }

  /// ✅ Get the active session
  static Future<Session?> getActiveSession() async {
    final key = await getActiveSessionKey();
    return key != null ? getSession(key) : null;
  }

  /// ✅ List all stored session keys
  static Future<List<String>> listSessionKeys() async {
    final raw = await getStorageValue(StorageKeys.AllSessionKeys.value);
    return raw is List ? raw.cast<String>() : [];
  }

  /// ✅ Clear a single session
  static Future<void> clearSession(String sessionKey) async {
    await removeStorageValue(sessionKey);

    final keys = await listSessionKeys();
    final updated = keys.where((k) => k != sessionKey).toList();
    await setStorageValue(StorageKeys.AllSessionKeys.value, updated);

    final active = await getActiveSessionKey();
    if (active == sessionKey) {
      await removeStorageValue(StorageKeys.ActiveSessionKey.value);
    }
  }

  /// ✅ Clear all sessions
  static Future<void> clearAllSessions() async {
    final keys = await listSessionKeys();
    for (final k in keys) {
      await removeStorageValue(k);
    }
    await removeStorageValue(StorageKeys.AllSessionKeys.value);
    await removeStorageValue(StorageKeys.ActiveSessionKey.value);
  }
}
