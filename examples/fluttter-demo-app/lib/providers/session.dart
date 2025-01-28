import 'dart:convert';
import 'package:elliptic/elliptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/crypto.dart';

import '../utils/helpers.dart';

enum StorageKey {
  //TODO: Naming scheme for dart
  EmbeddedKey,
  Session,
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

  Future<String> createEmbeddedKey() async {
    final keyPair = await generateP256KeyPair();
    final embeddedPrivateKey = keyPair.privateKey.toString();
    final publicKey = keyPair.publicKey.toString();

    await _saveEmbeddedKey(embeddedPrivateKey);

    return publicKey;
  }

  Future<void> _saveEmbeddedKey(String key) async {
    await _secureStorage.write(
        key: StorageKey.EmbeddedKey.toString(), value: key);
  }

  Future<String?> _getEmbeddedKey({bool deleteKey = true}) async {
    final key =
        await _secureStorage.read(key: StorageKey.EmbeddedKey.toString());
    if (deleteKey) {
      await _secureStorage.delete(key: StorageKey.EmbeddedKey.toString());
    }
    return key;
  }

  Future<Session> createSession(String bundle,
      {int expirySeconds = 900}) async {
    final embeddedKey = await _getEmbeddedKey();
    if (embeddedKey == null) {
      throw Exception('Embedded key not found.');
    }

    final privateKey = decryptCredentialBundle(
        credentialBundle: bundle, embeddedKey: embeddedKey);
    final expiry = DateTime.now().millisecondsSinceEpoch + expirySeconds * 1000;

    final ec = getP256();

    var ecPrivateKey = PrivateKey.fromHex(ec, privateKey);

    var publicKey = ec
        .privateToPublicKey(ecPrivateKey)
        .toString(); //TODO: Check if this is correct

    final session =
        Session(publicKey: publicKey, privateKey: privateKey, expiry: expiry);
    await _saveSession(session);

    return session;
  }

  Future<Session?> getSession() async {
    final sessionJson =
        await _secureStorage.read(key: StorageKey.Session.toString());
    if (sessionJson != null) {
      return Session.fromJson(jsonDecode(sessionJson));
    }
    return null;
  }

  Future<void> _saveSession(Session session) async {
    _session = session;
    notifyListeners();
    await _secureStorage.write(
        key: StorageKey.Session.toString(),
        value: jsonEncode(session.toJson()));
  }

  Future<void> clearSession() async {
    _session = null;
    notifyListeners();
    await _secureStorage.delete(key: StorageKey.Session.toString());
  }
}
