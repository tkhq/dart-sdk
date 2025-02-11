import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';

enum StorageKey {
  embeddedKey,
  session,
}

/// A class representing a session with public and private keys and an expiry time.
class Session {
  final String publicKey;
  final String privateKey;
  final int expiry;

  Session({
    required this.publicKey,
    required this.privateKey,
    required this.expiry,
  });

  /// Converts the session to a JSON map.
  Map<String, dynamic> toJson() => {
        'publicKey': publicKey,
        'privateKey': privateKey,
        'expiry': expiry,
      };

  /// Creates a session from a JSON map.
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      publicKey: json['publicKey'],
      privateKey: json['privateKey'],
      expiry: json['expiry'],
    );
  }
}

/// A provider class for managing sessions and securely storing keys.
class SessionProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  Session? _session;

  /// Gets the current session.
  Session? get session => _session;

  /// Initializes the session provider and checks for an existing session.
  SessionProvider() {
    _initialize();
  }

  /// Initializes the session provider by checking for an existing session.
  Future<void> _initialize() async {
    await checkSession();
  }

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

  /// Saves the embedded private key securely.
  Future<void> _saveEmbeddedKey(String key) async {
    await _secureStorage.write(
        key: StorageKey.embeddedKey.toString(), value: key);
  }

  /// Retrieves the embedded private key from secure storage.
  ///
  /// If [deleteKey] is true, the key will be deleted after retrieval.
  Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
    final key =
        await _secureStorage.read(key: StorageKey.embeddedKey.toString());
    if (deleteKey) {
      await _secureStorage.delete(key: StorageKey.embeddedKey.toString());
    }
    return key;
  }

  /// Creates a session using the provided credential bundle.
  ///
  /// [expirySeconds] specifies the session expiry time in seconds.
  /// If [notifyListeners] is true, listeners will be notified of changes.
  ///
  /// Returns the created session.
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

  /// Retrieves the current session from secure storage.
  ///
  /// Returns the session if it exists, otherwise null.
  Future<Session?> getSession() async {
    final sessionJson =
        await _secureStorage.read(key: StorageKey.session.toString());
    if (sessionJson != null) {
      return Session.fromJson(jsonDecode(sessionJson));
    }
    return null;
  }

  /// Saves the session to secure storage.
  ///
  /// If [notifyListeners] is true, listeners will be notified of changes.
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

  /// Clears the current session from secure storage.
  ///
  /// If [notifyListeners] is true, listeners will be notified of changes.
  Future<void> clearSession({bool notifyListeners = true}) async {
    _session = null;
    if (notifyListeners) {
      this.notifyListeners();
    }
    await _secureStorage.delete(key: StorageKey.session.toString());
  }

  /// Checks if there is a valid session in secure storage.
  ///
  /// If a valid session is found, it is loaded and listeners are notified if [notifyListeners] is true.
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
