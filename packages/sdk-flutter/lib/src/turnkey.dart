import 'dart:async';
import 'package:flutter/material.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_encoding/turnkey_encoding.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class TurnkeyProvider with ChangeNotifier {
  Session? _session;
  TurnkeyClient? _client;
  Map<String, Timer> _expiryTimers = {};

  final TurnkeyConfig config;

  TurnkeyProvider({required this.config}) {
    initializeSessions();
  }

  Session? get session => _session;
  TurnkeyClient? get client => _client;

  set session(Session? newSession) {
    _session = newSession;
    notifyListeners();
  }

  set client(TurnkeyClient? newClient) {
    _client = newClient;
    notifyListeners();
  }

  /// Initializes stored sessions on mount.
  ///
  /// This function retrieves all stored session keys, validates their expiration status,
  /// removes expired sessions, and schedules expiration timers for active ones.
  /// Additionally, it loads the last selected session if it is still valid,
  /// otherwise it clears the session and triggers the session expiration callback.
  Future<void> initializeSessions() async {
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

        config.onSessionSelected?.call(selectedSession);
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

  /// Sets the selected session and updates the client instance.
  ///
  /// Retrieves the session associated with the given [sessionKey].
  /// If the session is valid, initializes a new [TurnkeyClient] and updates the state.
  /// Saves the selected session key and triggers [onSessionSelected] if provided.
  /// If the session is expired or invalid, clears the session and triggers [onSessionExpired].
  ///
  /// Returns the selected session if valid, otherwise `null`.
  Future<Session?> setSelectedSession(String sessionKey) async {
    final session = await getSession(sessionKey);

    if (session != null &&
        session.expiry > DateTime.now().millisecondsSinceEpoch) {
      final client = createClient(
          session.publicKey, session.privateKey, config.apiBaseUrl);
      this.client = client;
      this.session = session;

      await saveSelectedSessionKey(sessionKey);

      config.onSessionSelected?.call(session);
      return session;
    } else {
      await clearSession(sessionKey: sessionKey);
      notifyListeners();

      return null;
    }
  }

  /// Schedules the expiration of a session.
  ///
  /// Clears any existing timeout for the session to prevent duplicate timers.
  /// Determines the time remaining until the session expires.
  /// If the session is already expired, it triggers expiration immediately.
  /// Otherwise, schedules a timeout to expire the session at the appropriate time.
  /// Calls [clearSession] and invokes the [onSessionExpired] callback when the session expires.
  Future<void> _scheduleSessionExpiration(String sessionKey, int expiry) async {
    if (_expiryTimers.isNotEmpty && _expiryTimers.containsKey(sessionKey)) {
      _expiryTimers[sessionKey]?.cancel();
    }

    final expireSession = () async {
      final expiredSession = await getSession(sessionKey);

      if (expiredSession == null) return;

      await clearSession(sessionKey: sessionKey);

      config.onSessionExpired?.call(expiredSession);
      _expiryTimers.remove(sessionKey);
    };

    final timeUntilExpiry = expiry - DateTime.now().millisecondsSinceEpoch;

    if (timeUntilExpiry <= 0) {
      await expireSession();
    } else {
      _expiryTimers.putIfAbsent(sessionKey, () {
        return Timer(Duration(milliseconds: timeUntilExpiry), expireSession);
      });
    }
  }

  /// Clears all scheduled session expiration timeouts.
  ///
  /// Iterates over the currently tracked expiration timers and clears each one.
  /// Resets the [_expiryTimers] object to an empty state.
  void _clearTimeouts() {
    if (_expiryTimers.isNotEmpty) {
      _expiryTimers.forEach((key, timer) {
        timer.cancel();
      });
    }
  }

  /// Creates a new session and securely stores it.
  ///
  /// Retrieves the embedded private key from secure storage.
  /// Decrypts the provided session bundle using the embedded key.
  /// Extracts the public key from the decrypted private key.
  /// Creates a new Turnkey API client using the derived credentials.
  /// Fetches user information associated with the session.
  /// Constructs and saves the session in secure storage.
  /// Schedules session expiration handling.
  /// If this is the first session, it is automatically set as the selected session.
  /// Calls [onSessionCreated] callback if provided.
  ///
  /// Returns the created session.
  /// Throws an [Exception] if the embedded key or user data cannot be retrieved.
  Future<Session> createSession(String bundle,
      {int expirySeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
      String sessionKey = TURNKEY_DEFAULT_SESSION_STORAGE}) async {
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

    await saveSession(
      session,
      session.key,
    );

    await addSessionKeyToIndex(sessionKey);

    await _scheduleSessionExpiration(session.key, expiry);

    final sessionKeys = await getSessionKeysIndex();
    final isFirstSession = sessionKeys.length == 1;

    if (isFirstSession) {
      await setSelectedSession(sessionKey);
    }

    config.onSessionCreated?.call(session);
    return session;
  }

  /// Clears the current session from secure storage.
  ///
  /// Retrieves the session associated with the given [sessionKey].
  /// If the session being cleared is the currently selected session, it resets the state.
  /// Deletes the session from secure storage.
  /// Removes the session key from the session index.
  /// Calls [onSessionCleared] callback if provided.
  ///
  /// Returns the cleared session if successful, otherwise `null`.
  /// Throws an [Exception] if the session cannot be cleared.
  Future<Session?> clearSession(
      {String sessionKey = TURNKEY_DEFAULT_SESSION_STORAGE}) async {
    try {
      final clearedSession = await getSession(sessionKey);

      if (session?.key == sessionKey) {
        session = null;

        client = null;

        await clearSelectedSessionKey();
      }

      await deleteSession(sessionKey);

      await removeSessionKeyFromIndex(sessionKey);

      _expiryTimers[sessionKey]?.cancel();

      config.onSessionCleared?.call(clearedSession ??
          Session(key: sessionKey, publicKey: "", privateKey: "", expiry: 0));
      return clearedSession;
    } catch (e) {
      throw Exception("Failed to clear session: $e");
    }
  }

  /// Clears all sessions from secure storage.
  ///
  /// Retrieves all stored session keys and clears each session.
  /// Clears all scheduled session expiration timeouts.
  /// Throws an [Exception] if any session cannot be cleared.
  Future<void> clearAllSessions() async {
    try {
      final sessionKeys = await getSessionKeysIndex();

      for (final sessionKey in sessionKeys) {
        await clearSession(sessionKey: sessionKey);
      }

      _clearTimeouts();
    } catch (e) {
      throw Exception("Failed to clear all sessions: $e");
    }
  }

  /// Refreshes the current user data.
  ///
  /// Fetches the latest user details from the API using the current session's client.
  /// If the user data is successfully retrieved, updates the session with the new user details.
  /// Saves the updated session and updates the state.
  ///
  /// Throws an [Exception] if the session or client is not initialized.
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

  /// Updates the current user's information.
  ///
  /// Sends a request to update the user's email and/or phone number.
  /// If the update is successful, refreshes the user data to reflect changes.
  ///
  /// Throws an [Exception] if the client or session is not initialized.
  Future<Activity> updateUser(BuildContext context,
      {String? email, String? phone}) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final parameters = UpdateUserIntent(
      userId: session!.user!.id,
      userTagIds: [],
      userPhoneNumber: phone?.trim().isNotEmpty == true ? phone : null,
      userEmail: email?.trim().isNotEmpty == true ? email : null,
    );

    final response = await _client!.updateUser(
      input: UpdateUserRequest(
        type: UpdateUserRequestType.activityTypeUpdateUser,
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

  /// Signs a raw payload using the specified signing key and encoding parameters.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  Future<SignRawPayloadResult> signRawPayload(
      BuildContext context, SignRawPayloadIntentV2 parameters) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.signRawPayload(
        input: SignRawPayloadRequest(
            type: SignRawPayloadRequestType.activityTypeSignRawPayloadV2,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: parameters));

    final signRawPayloadResult = response.activity.result.signRawPayloadResult;
    if (signRawPayloadResult == null) {
      throw Exception("Failed to sign raw payload");
    }
    return signRawPayloadResult;
  }

  /// Creates a new wallet with the specified name and accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  Future<Activity> createWallet(
      BuildContext context, CreateWalletIntent parameters) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.createWallet(
        input: CreateWalletRequest(
            type: CreateWalletRequestType.activityTypeCreateWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: parameters));
    final activity = response.activity;
    if (activity.result.createWalletResult?.walletId != null) {
      await refreshUser();
    }

    return activity;
  }

  /// Imports a wallet using a provided mnemonic and creates accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  Future<void> importWallet(BuildContext context, String mnemonic,
      String walletName, List<WalletAccountParams> accounts) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }
    final initResponse = await _client!.initImportWallet(
        input: InitImportWalletRequest(
            type: InitImportWalletRequestType.activityTypeInitImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: InitImportWalletIntent(userId: session!.user!.id)));

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
        input: ImportWalletRequest(
            type: ImportWalletRequestType.activityTypeImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: ImportWalletIntent(
                userId: session!.user!.id,
                walletName: walletName,
                encryptedBundle: encryptedBundle,
                accounts: accounts)));
    final activity = response.activity;
    if (activity.result.importWalletResult?.walletId != null) {
      await refreshUser();
    }
  }

  /// Exports an existing wallet by decrypting the stored mnemonic phrase.
  ///
  /// Throws an [Exception] if the client, user, or export bundle is not initialized.
  Future<String> exportWallet(BuildContext context, String walletId) async {
    if (_client == null || session == null || session!.user == null) {
      throw Exception("Client or user not initialized");
    }

    final targetPublicKey = await createEmbeddedKey();

    final response = await _client!.exportWallet(
        input: ExportWalletRequest(
            type: ExportWalletRequestType.activityTypeExportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: session!.user!.organizationId,
            parameters: ExportWalletIntent(
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
