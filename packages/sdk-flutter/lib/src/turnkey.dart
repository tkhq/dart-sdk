import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart'
    as turnkeyTypes;
import 'package:turnkey_http/base.dart';
import 'package:turnkey_http/turnkey_http.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

//TODO: Parity with react-native. Add rest of functions and make more general.
//Fix listeners an maybe have callback functions if possible. Replace secure storage with shared preferences for some functions.
//Add more comments and documentation.
//Seperate functions into different files
class TurnkeyProvider with ChangeNotifier {
  Session? _session;
  TurnkeyClient? _client;
  Map<String, Timer>? _expiryTimers;

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final TurnkeyConfig config;

  TurnkeyProvider({required this.config});

  Session? get session => _session;

  Future<Session?> setSelectedSession(String storageKey) async {
    final session = await getSession(storageKey);
    if (session != null &&
        session.expiry > DateTime.now().millisecondsSinceEpoch) {
      final client = createClient(
          session.publicKey, session.privateKey, config.apiBaseUrl);
      _client = client;
      _session = session;

      saveSelectedSessionKey(storageKey);
      notifyListeners();
      await _scheduleSessionExpiration(storageKey, session.expiry);

      return session;
    } else {
      await clearSession(storageKey: storageKey);
      notifyListeners();
      return null;
    }
  }

  Future<String?> getSelectedSessionKey() {
    try {
      return _secureStorage.read(
          key: StorageKey.turnkeySelectedSession.toString());
    } catch (e) {
      throw Exception("Failed to get selected session: $e");
    }
  }

  void saveSelectedSessionKey(String storageKey) {
    try {
      _secureStorage.write(
        key: StorageKey.turnkeySelectedSession.toString(),
        value: storageKey,
      );
    } catch (e) {
      throw Exception("Failed to save selected session: $e");
    }
  }

  void clearSelectedSessionKey() {
    try {
      _secureStorage.delete(key: StorageKey.turnkeySelectedSession.toString());
    } catch (e) {
      throw Exception("Failed to clear selected session: $e");
    }
  }

  Future<void> addSessionKeyToIndex(String sessionKey) async {
    try {
      final indexStr = await _secureStorage.read(
          key: StorageKey.turnkeySessionKeysIndex.toString());
      List<String> keys =
          indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
      if (!keys.contains(sessionKey)) {
        keys.add(sessionKey);
        await _secureStorage.write(
            key: StorageKey.turnkeySessionKeysIndex.toString(),
            value: jsonEncode(keys));
      }
    } catch (error) {
      throw Exception("Failed to add session key to index: $error");
    }
  }

  Future<List<String>> getSessionKeysIndex() async {
    try {
      final indexStr = await _secureStorage.read(
          key: StorageKey.turnkeySessionKeysIndex.toString());
      return indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
    } catch (error) {
      throw Exception("Failed to get session keys index: $error");
    }
  }

  Future<void> removeSessionKeyFromIndex(String sessionKey) async {
    try {
      final indexStr = await _secureStorage.read(
          key: StorageKey.turnkeySessionKeysIndex.toString());
      List<String> keys =
          indexStr != null ? List<String>.from(jsonDecode(indexStr)) : [];
      keys = keys.where((key) => key != sessionKey).toList();
      await _secureStorage.write(
          key: StorageKey.turnkeySessionKeysIndex.toString(),
          value: jsonEncode(keys));
    } catch (error) {
      throw Exception("Failed to remove session key from index: $error");
    }
  }

  Future<void> _scheduleSessionExpiration(String storageKey, int expiry) async {
    if (_expiryTimers != null && _expiryTimers![storageKey] != null) {
      _expiryTimers![storageKey]?.cancel();
    }

    final duration =
        Duration(milliseconds: expiry - DateTime.now().millisecondsSinceEpoch);

    if (duration > Duration.zero) {
      _expiryTimers![storageKey] = Timer(duration, () async {
        final expiredSession = await getSession(storageKey);
        if (expiredSession != null) {
          await clearSession(storageKey: storageKey);
        }
        notifyListeners();
        _expiryTimers!.remove(storageKey);

        debugPrint('Turnkey session expired. Listeners will be notified.');
      });
    } else {
      clearSession(storageKey: storageKey);
      notifyListeners();
      debugPrint('Turnkey session expired. Listeners will be notified.');
    }
  }

  void _clearTimeouts() {
    if (_expiryTimers != null) {
      _expiryTimers!.forEach((key, timer) {
        timer.cancel();
      });
    }
  }

  TurnkeyClient createClient(String publicKey, String privateKey, apiBaseUrl) {
    final stamper = ApiKeyStamper(
      ApiKeyStamperConfig(apiPrivateKey: privateKey, apiPublicKey: publicKey),
    );

    return TurnkeyClient(
      config: THttpConfig(baseUrl: apiBaseUrl),
      stamper: stamper,
    );
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
        key: StorageKey.turnkeyEmbeddedKeyStorage.toString(), value: key);
  }

  /// Retrieves the embedded private key from secure storage.
  ///
  /// If [deleteKey] is true (default), the key will be deleted after retrieval.
  Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
    final key = await _secureStorage.read(
        key: StorageKey.turnkeyEmbeddedKeyStorage.toString());
    if (deleteKey) {
      await _secureStorage.delete(
          key: StorageKey.turnkeyEmbeddedKeyStorage.toString());
    }

    return key;
  }

  /// Creates a session using the provided credential bundle.
  ///
  /// [expirySeconds] specifies the session expiry time in seconds.
  /// If [notifyListeners] is true (default), listeners will be notified of changes.
  ///
  /// Returns the created session.
  Future<Session> createSession(String bundle,
      {int expirySeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
      String? storageKey,
      bool notifyListeners = true}) async {
    final embeddedKey = await getEmbeddedKey();
    if (embeddedKey == null) {
      throw Exception('Embedded key not found.');
    }

    final privateKey = decryptCredentialBundle(
        credentialBundle: bundle, embeddedKey: embeddedKey);
    final publicKey = uint8ArrayToHexString(getPublicKey(privateKey));
    final expiry = DateTime.now().millisecondsSinceEpoch + expirySeconds * 1000;

    final client = createClient(publicKey, privateKey, config.apiBaseUrl);
    _client = client;

    final user = await fetchUser(client, config.organizationId);

    if (user != null) {
      throw Exception("Failed to fetch user");
    }

    final session = Session(
        storageKey: storageKey ?? StorageKey.turnkeySessionStorage.toString(),
        publicKey: publicKey,
        privateKey: privateKey,
        expiry: expiry,
        user: user);

    await _saveSession(session, session.storageKey,
        notifyListeners: notifyListeners);

    await _scheduleSessionExpiration(session.storageKey, expiry);
    saveSelectedSessionKey(session.storageKey);
    addSessionKeyToIndex(
        storageKey ?? StorageKey.turnkeySessionStorage.toString());

    return session;
  }

  /// Retrieves the current session from secure storage.
  ///
  /// Returns the session if it exists, otherwise null.
  Future<Session?> getSession(String storageKey) async {
    final sessionJson = await _secureStorage.read(key: storageKey);
    if (sessionJson != null) {
      return Session.fromJson(jsonDecode(sessionJson));
    }
    return null;
  }

  /// Saves the session to secure storage.
  ///
  /// If [notifyListeners] is true (default), listeners will be notified of changes.
  Future<void> _saveSession(Session session, String storageKey,
      {bool notifyListeners = true}) async {
    try {
      _session = session;
      await _secureStorage.write(
          key: storageKey, value: jsonEncode(session.toJson()));
    } catch (e) {
      throw Exception("Failed to save session: $e");
    }

    if (notifyListeners) {
      this.notifyListeners();
    }
  }

  /// Clears the current session from secure storage.
  ///
  /// If [notifyListeners] is true (default), listeners will be notified of changes.
  Future<Session?> clearSession(
      {String? storageKey, bool notifyListeners = true}) async {
    storageKey ??= StorageKey.turnkeySessionStorage
        .toString(); //TOOD: Does this work? It should set default value if storageKey is null

    try {
      final clearedSession = await getSession(
          storageKey); //TODO: We should make this known to listeners somehow

      if (session!.storageKey == storageKey) {
        _session = null;
        _client = null;
        clearSelectedSessionKey();
      }

      removeSessionKeyFromIndex(storageKey);
      await _secureStorage.delete(key: storageKey);
      _expiryTimers![storageKey]?.cancel();
      return clearedSession;
    } catch (e) {
      throw Exception("Failed to clear session: $e");
    }
  }

  Future<User?> fetchUser(TurnkeyClient client, String organizationId) async {
    if (session != null) {
      final whoami = await client.getWhoami(
          input: turnkeyTypes.GetWhoamiRequest(
        organizationId: config.organizationId,
      ));

      if (whoami.userId != null && whoami.organizationId != null) {
        final walletsResponse = await client.getWallets(
          input: turnkeyTypes.GetWalletsRequest(
              organizationId: whoami.organizationId),
        );
        final userResponse = await client.getUser(
          input: turnkeyTypes.GetUserRequest(
            organizationId: whoami.organizationId,
            userId: whoami.userId,
          ),
        );

        final wallets =
            await Future.wait(walletsResponse.wallets.map((wallet) async {
          final accountsResponse = await client.getWalletAccounts(
              input: turnkeyTypes.GetWalletAccountsRequest(
                  organizationId: whoami.organizationId,
                  walletId: wallet.walletId));
          return Wallet(
            name: wallet.walletName,
            id: wallet.walletId,
            accounts: accountsResponse.accounts
                .map((account) => WalletAccount(
                    id: account.walletAccountId,
                    curve: account.curve,
                    pathFormat: account.pathFormat,
                    path: account.path,
                    addressFormat: account.addressFormat,
                    address: account.address,
                    createdAt: account.createdAt,
                    updatedAt: account.updatedAt))
                .toList(),
          );
        }).toList());

        final user = userResponse.user;
        //TODO: Notify listeners?

        notifyListeners();
        return User(
          id: user.userId,
          userName: user.userName,
          email: user.userEmail,
          phoneNumber: user.userPhoneNumber,
          organizationId: whoami.organizationId,
          wallets: wallets,
        );
      }
    }
  }

  Future<void> refreshUser() async {
    if (_client == null || session == null) {
      throw Exception(
          "Failed to refresh user. Client or sessions not initialized");
    }

    final updatedUser = await fetchUser(_client!, config.organizationId);

    if (updatedUser != null) {
      final updatedSession = Session(
        storageKey: session!.storageKey,
        publicKey: session!.publicKey,
        privateKey: session!.privateKey,
        expiry: session!.expiry,
        user: updatedUser,
      );

      await _saveSession(updatedSession, updatedSession.storageKey);
      _session = updatedSession;
    }
  }

  Future<turnkeyTypes.Activity> updateUser(BuildContext context,
      {String? email, String? phone}) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final parameters = turnkeyTypes.UpdateUserIntent(
      userId: session!.user!.id,
      userTagIds: [],
      userPhoneNumber: phone?.trim().isNotEmpty == true ? phone : null,
      userEmail: email?.trim().isNotEmpty == true ? email : null,
    );

    final response = await _client!.updateUser(
      input: turnkeyTypes.UpdateUserRequest(
        type: turnkeyTypes.UpdateUserRequestType.activityTypeUpdateUser,
        timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
        organizationId: session!.user!.organizationId,
        parameters: parameters,
      ),
    );

    final activity = response.activity;
    if (activity.result.updateUserResult?.userId != null) {
      await refreshUser();
    }

    return activity;
  }

  Future<void> logout(BuildContext context) async {
    await this.clearSession();
  }

  Future<turnkeyTypes.SignRawPayloadResult> signRawPayload(BuildContext context,
      turnkeyTypes.SignRawPayloadIntentV2 parameters) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.signRawPayload(
        input: turnkeyTypes.SignRawPayloadRequest(
            type: turnkeyTypes
                .SignRawPayloadRequestType.activityTypeSignRawPayloadV2,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: parameters));

    final signRawPayloadResult = response.activity.result.signRawPayloadResult;
    if (signRawPayloadResult == null) {
      throw Exception("Failed to sign raw payload");
    }
    return signRawPayloadResult;
  }

  Future<turnkeyTypes.Activity> createWallet(
      BuildContext context, turnkeyTypes.CreateWalletIntent parameters) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.createWallet(
        input: turnkeyTypes.CreateWalletRequest(
            type: turnkeyTypes.CreateWalletRequestType.activityTypeCreateWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: parameters));
    final activity = response.activity;
    if (activity.result.createWalletResult?.walletId != null) {
      await refreshUser();
    }

    return activity;
  }

  Future<void> importWallet(
      BuildContext context,
      String mnemonic,
      String walletName,
      List<turnkeyTypes.WalletAccountParams> accounts) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }
    final initResponse = await _client!.initImportWallet(
        input: turnkeyTypes.InitImportWalletRequest(
            type: turnkeyTypes
                .InitImportWalletRequestType.activityTypeInitImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: turnkeyTypes.InitImportWalletIntent(
                userId: session!.user!.id)));

    final importBundle =
        initResponse.activity.result.initImportWalletResult?.importBundle;

    if (importBundle == null) {
      throw Exception("Failed to get import bundle");
    }

    final encryptedBundle = await encryptWalletToBundle(
      mnemonic: mnemonic,
      importBundle: importBundle,
      userId: session!.user!.id,
      organizationId: session!.user!.organizationId,
    );

    final response = await _client!.importWallet(
        input: turnkeyTypes.ImportWalletRequest(
            type: turnkeyTypes.ImportWalletRequestType.activityTypeImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: turnkeyTypes.ImportWalletIntent(
                userId: session!.user!.id,
                walletName: walletName,
                encryptedBundle: encryptedBundle,
                accounts: accounts)));
    final activity = response.activity;
    if (activity.result.importWalletResult?.walletId != null) {
      await refreshUser();
    }
  }

  Future<String> exportWallet(BuildContext context, String walletId) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final targetPublicKey = await this.createEmbeddedKey();

    final response = await _client!.exportWallet(
        input: turnkeyTypes.ExportWalletRequest(
            type: turnkeyTypes.ExportWalletRequestType.activityTypeExportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: turnkeyTypes.ExportWalletIntent(
                walletId: walletId, targetPublicKey: targetPublicKey)));
    final exportBundle =
        response.activity.result.exportWalletResult?.exportBundle;

    final embeddedKey = await this.getEmbeddedKey();
    if (exportBundle == null || embeddedKey == null) {
      throw Exception("Export bundle, embedded key, or user not initialized");
    }

    return await decryptExportBundle(
        exportBundle: exportBundle,
        embeddedKey: embeddedKey,
        organizationId: session!.user!.organizationId,
        returnMnemonic: true);
  }
}
