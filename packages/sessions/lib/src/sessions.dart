import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';

enum StorageKey {
  embeddedKey,
  session,
}

class Session {
  final String publicKey;
  final String privateKey;
  final int expiry;

  Session({
    required this.publicKey,
    required this.privateKey,
    required this.expiry,
  });

  Map<String, dynamic> toJson() => {
        'publicKey': publicKey,
        'privateKey': privateKey,
        'expiry': expiry,
      };

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      publicKey: json['publicKey'],
      privateKey: json['privateKey'],
      expiry: json['expiry'],
    );
  }
}

class SessionProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Session? _session;

  Session? get session => _session;

  SessionProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    await checkSession();
  }

  Future<String> createEmbeddedKey() async {
    final keyPair = await generateP256KeyPair();
    final embeddedPrivateKey = keyPair.privateKey;
    final publicKey = keyPair.publicKeyUncompressed;

    await _saveEmbeddedKey(embeddedPrivateKey);

    return publicKey;
  }

  Future<void> _saveEmbeddedKey(String key) async {
    await _secureStorage.write(
        key: StorageKey.embeddedKey.toString(), value: key);
  }

  Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
    final key =
        await _secureStorage.read(key: StorageKey.embeddedKey.toString());
    if (deleteKey) {
      await _secureStorage.delete(key: StorageKey.embeddedKey.toString());
    }
    return key;
  }

  Future<Session> createSession(String bundle,
      {int expirySeconds = 900, bool notifyListeners = true}) async {
    final embeddedKey = await getEmbeddedKey();
    if (embeddedKey == null) {
      throw Exception('Embedded key not found.');
    }

    final privateKey = decryptCredentialBundle(
        credentialBundle: bundle, embeddedKey: embeddedKey);
    final expiry = DateTime.now().millisecondsSinceEpoch + expirySeconds * 1000;

    var publicKey = uint8ArrayToHexString(getPublicKey(privateKey));

    final session =
        Session(publicKey: publicKey, privateKey: privateKey, expiry: expiry);
    await _saveSession(session, notifyListeners: notifyListeners);

    return session;
  }

  Future<Session?> getSession() async {
    final sessionJson =
        await _secureStorage.read(key: StorageKey.session.toString());
    if (sessionJson != null) {
      return Session.fromJson(jsonDecode(sessionJson));
    }
    return null;
  }

  Future<void> _saveSession(Session session,
      {bool notifyListeners = true}) async {
    _session = session;
    if (notifyListeners) {
      this.notifyListeners();
    }
    await _secureStorage.write(
        key: StorageKey.session.toString(),
        value: jsonEncode(session.toJson()));
  }

  Future<void> clearSession({bool notifyListeners = true}) async {
    _session = null;
    if (notifyListeners) {
      this.notifyListeners();
    }
    await _secureStorage.delete(key: StorageKey.session.toString());
  }

  Future<void> checkSession({bool notifyListeners = true}) async {
    final session = await getSession();

    if (session?.expiry != null &&
        session!.expiry > DateTime.now().millisecondsSinceEpoch) {
      _session = session;

      if (notifyListeners) {
        this.notifyListeners();
      }
    }
  }
}
