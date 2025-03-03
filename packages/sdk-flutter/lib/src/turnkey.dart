import 'dart:async';
import 'package:flutter/material.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart'
    as turnkeyTypes;
import 'package:turnkey_http/turnkey_http.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class TurnkeyProvider with ChangeNotifier {
  Session? _session;
  TurnkeyClient? _client;
  Map<String, Timer>? _expiryTimers;

  final TurnkeyConfig config;

  TurnkeyProvider({required this.config}) {
    initializeSessions();
  }

  Session? get session => _session;
  TurnkeyClient? get client => _client;

  set session(Session? newSession) {
    print('SETTING SESSION!!!!: ${newSession!.user!.id}');
    _session = newSession;
    notifyListeners();
  }

  set client(TurnkeyClient? newClient) {
    _client = newClient;
    notifyListeners();
  }

  Future<void> initializeSessions() async {
    print('Good morning');
    final sessionKeys = await getSessionKeysIndex();

    await Future.wait(sessionKeys.map((sessionKey) async {
      final session = await getSession(sessionKey);

      if (session == null ||
          session.expiry <= DateTime.now().millisecondsSinceEpoch) {
        await clearSession(sessionKey: sessionKey);
        await removeSessionKeyFromIndex(sessionKey);
        return;
      }

      await _scheduleSessionExpiration(sessionKey, session.expiry);
    }));

    final selectedSessionKey = await getSelectedSessionKey();

    if (selectedSessionKey != null) {
      final selectedSession = await getSession(selectedSessionKey);

      if (selectedSession != null &&
          selectedSession.expiry > DateTime.now().millisecondsSinceEpoch) {
        final clientInstance = createClient(
          selectedSession.publicKey,
          selectedSession.privateKey,
          config.apiBaseUrl,
        );

        session = selectedSession;
        client = clientInstance;

        config.onSessionCreated?.call(selectedSession);
      } else {
        await clearSession(sessionKey: selectedSessionKey);

        config.onSessionExpired?.call(
          selectedSession ??
              (Session(
                  key: selectedSessionKey,
                  publicKey: "",
                  privateKey: "",
                  expiry: 0)),
        );
      }
    }
  }

  Future<Session?> setSelectedSession(String sessionKey) async {
    print('hello $sessionKey');
    final session = await getSession(sessionKey);
    print('Done get sessison');
    if (session != null &&
        session.expiry > DateTime.now().millisecondsSinceEpoch) {
      print('Setting selected session: $sessionKey');
      final client = createClient(
          session.publicKey, session.privateKey, config.apiBaseUrl);
      this.client = client;
      this.session = session;

      await saveSelectedSessionKey(sessionKey);
      notifyListeners();

      config.onSessionCreated?.call(session);
      return session;
    } else {
      await clearSession(sessionKey: sessionKey);
      notifyListeners();

      return null;
    }
  }

  Future<void> _scheduleSessionExpiration(String sessionKey, int expiry) async {
    if (_expiryTimers != null && _expiryTimers![sessionKey] != null) {
      _expiryTimers![sessionKey]?.cancel();
    }
    print('Scheduling session expiration for $sessionKey');

    final expireSession = () async {
      print('Expiring session $sessionKey');
      final expiredSession = await getSession(sessionKey);
      print('Expired session: $expiredSession');
      if (expiredSession == null) return;

      await clearSession(sessionKey: sessionKey);

      config.onSessionExpired?.call(expiredSession);
      _expiryTimers!.remove(sessionKey);
    };

    final timeUntilExpiry = expiry - DateTime.now().millisecondsSinceEpoch;

    if (timeUntilExpiry <= 0) {
      await expireSession();
    } else {
      _expiryTimers?.putIfAbsent(
          sessionKey,
          Timer(Duration(milliseconds: timeUntilExpiry), expireSession) as Timer
              Function()); //TODO: make sure this cast works
    }
  }

  void _clearTimeouts() {
    if (_expiryTimers != null) {
      _expiryTimers!.forEach((key, timer) {
        timer.cancel();
      });
    }
  }

  /// Creates a session using the provided credential bundle.
  ///
  /// [expirySeconds] specifies the session expiry time in seconds.
  ///
  /// Returns the created session.
  Future<Session> createSession(String bundle,
      {int expirySeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
      String? sessionKey}) async {
    sessionKey ??= SessionKey.turnkeySessionStorage.toString();
    final embeddedKey = await getEmbeddedKey();
    if (embeddedKey == null) {
      throw Exception('Embedded key not found.');
    }

    final privateKey = decryptCredentialBundle(
        credentialBundle: bundle, embeddedKey: embeddedKey);
    final publicKey = uint8ArrayToHexString(getPublicKey(privateKey));
    final expiry = DateTime.now().millisecondsSinceEpoch + expirySeconds * 1000;

    final client = createClient(publicKey, privateKey, config.apiBaseUrl);
    this.client = client;

    final user = await fetchUser(client, config.organizationId);

    if (user == null) {
      throw Exception("Failed to fetch user");
    }

    final session = Session(
        key: sessionKey,
        publicKey: publicKey,
        privateKey: privateKey,
        expiry: expiry,
        user: user);

    print("Session created: $session");
    await saveSession(
      session,
      session.key,
    );
    print("Session saved: $session");
    await addSessionKeyToIndex(sessionKey);
    print('Session key added: $sessionKey');
    await _scheduleSessionExpiration(session.key, expiry);
    print("Session scheduled: $session");

    final sessionKeys = await getSessionKeysIndex();
    final isFirstSession = sessionKeys.length == 1;
    print("Session keys: $sessionKeys");

    if (isFirstSession) {
      await setSelectedSession(sessionKey);
    }
    print('Selected session: $sessionKey');

    config.onSessionCreated?.call(session);
    return session;
  }

  /// Clears the current session from secure storage.
  Future<Session?> clearSession({String? sessionKey}) async {
    sessionKey ??= SessionKey.turnkeySessionStorage
        .toString(); //TOOD: Does this work? It should set default value if sessionKey is null

    try {
      final clearedSession = await getSession(sessionKey);

      if (session!.key == sessionKey) {
        session = null;
        client = null;
        await clearSelectedSessionKey();
      }

      await resetSession(sessionKey);
      await removeSessionKeyFromIndex(sessionKey);
      _expiryTimers![sessionKey]?.cancel();

      config.onSessionCleared?.call(clearedSession ??
          Session(key: sessionKey, publicKey: "", privateKey: "", expiry: 0));
      return clearedSession;
    } catch (e) {
      throw Exception("Failed to clear session: $e");
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
        key: session!.key,
        publicKey: session!.publicKey,
        privateKey: session!.privateKey,
        expiry: session!.expiry,
        user: updatedUser,
      );

      await saveSession(updatedSession, updatedSession.key);
      session = updatedSession;
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

    final targetPublicKey = await createEmbeddedKey();

    final response = await _client!.exportWallet(
        input: turnkeyTypes.ExportWalletRequest(
            type: turnkeyTypes.ExportWalletRequestType.activityTypeExportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: turnkeyTypes.ExportWalletIntent(
                walletId: walletId, targetPublicKey: targetPublicKey)));
    final exportBundle =
        response.activity.result.exportWalletResult?.exportBundle;

    final embeddedKey = await getEmbeddedKey();
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
