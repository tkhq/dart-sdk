part of 'turnkey.dart';

extension SessionExtension on TurnkeyProvider {
  /// Schedules the expiration of a session.
  ///
  /// Clears any existing timeout for the session to prevent duplicate timers.
  /// Determines the time remaining until the session expires.
  /// If the session is already expired, it triggers expiration immediately.
  /// Otherwise, schedules a timeout to expire the session at the appropriate time.
  /// Calls [clearSession] and invokes the [onSessionExpired] callback when the session expires.
  ///
  /// [sessionKey] The key of the session to schedule expiration for.
  /// [expiry] The expiration time in seconds.
  Future<void> _scheduleSessionExpiration(String sessionKey, int expiry) async {
    if (expiryTimers.isNotEmpty && expiryTimers.containsKey(sessionKey)) {
      expiryTimers[sessionKey]?.cancel();
      expiryTimers.remove(sessionKey);
    }

    final expireSession = () async {
      final expiredSession = await getSession(sessionKey: sessionKey);

      if (expiredSession == null) return;

      await clearSession(sessionKey: sessionKey);

      config.onSessionExpired?.call(expiredSession);
    };

    final timeUntilExpiry =
        (expiry * 1000) - DateTime.now().millisecondsSinceEpoch;

    if (timeUntilExpiry <= 0) {
      await expireSession();
    } else {
      expiryTimers.putIfAbsent(sessionKey, () {
        return Timer(Duration(milliseconds: timeUntilExpiry), expireSession);
      });
    }
  }

  /// Stores a new session in secure storage.
  ///
  /// Parses the provided session JWT and stores it under the specified session key.
  /// Creates a new client instance using the session's organization ID and public key.
  ///
  /// [sessionJwt] The JWT string representing the session to store.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// Returns the stored session if successful.
  /// Throws an [Exception] if the session cannot be stored or parsed.
  Future<Session> storeSession({
    required String sessionJwt,
    String? sessionKey,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;

    // we enforce a session limit
    final existingSessionKeys = await SessionStorageManager.listSessionKeys();
    if (existingSessionKeys.length >= MAX_SESSIONS) {
      throw Exception(
        'Maximum session limit of $MAX_SESSIONS reached. Please clear an existing session before creating a new one.',
      );
    }

    // we make sure the session key is unique
    if (existingSessionKeys.contains(sessionKey)) {
      clearSession(sessionKey: sessionKey);
      throw Exception(
        'Session key "$sessionKey" already exists. Please choose a unique session key or clear the existing session.',
      );
    }

    // we store and parse the session JWT
    await SessionStorageManager.storeSession(sessionJwt,
        sessionKey: sessionKey);
    final session = await SessionStorageManager.getSession(sessionKey);
    if (session == null) {
      throw Exception("Failed to store or parse session");
    }

    // we mark the session as active if this is the first session
    final isFirstSession = existingSessionKeys.isEmpty;
    if (isFirstSession) {
      await setActiveSession(sessionKey: sessionKey);
      authState = AuthState
          .authenticated; // We can set authstate here since we have a valid session and it is active
    }

    // we fetch the user information
    await refreshUser();
    await refreshWallets();
    if (user == null) {
      throw Exception("Failed to fetch user");
    }

    // we schedule the session expiration
    await _scheduleSessionExpiration(sessionKey, session.expiry);

    await deleteUnusedKeyPairs();

    config.onSessionCreated?.call(session);

    return session;
  }

  /// Sets the active session by its key.
  /// [sessionKey] The key of the session to set as active.
  Future<void> setActiveSession({required String sessionKey}) async {
    await SessionStorageManager.setActiveSessionKey(sessionKey);
    final s = await SessionStorageManager.getSession(sessionKey);

    if (s == null) {
      throw Exception("No session found with key: $sessionKey");
    }

    session = s;
    createClient(
      publicKey: s.publicKey,
      organizationId: s.organizationId,
    );

    authState = AuthState.authenticated;
    config.onSessionSelected?.call(s);
  }

  /// Gets the key of the currently active session.
  /// Returns the active session key if it exists, otherwise `null`.
  Future<String?> getActiveSessionKey() async {
    return await SessionStorageManager.getActiveSessionKey();
  }

  /// Gets a stored session by its key.
  /// [sessionKey] An optional key to retrieve the session from. If null, uses the default session key.
  /// Returns the session if found, otherwise `null`.
  Future<Session?> getSession({String? sessionKey}) async {
    final key = sessionKey ?? await SessionStorageManager.getActiveSessionKey();
    if (key == null) return null;
    return await SessionStorageManager.getSession(key);
  }

  /// Retrieves all stored sessions from secure storage.
  /// Returns a map of session keys to their corresponding session objects.
  Future<Map<String, Session>?> getAllSessions() async {
    final keys = await SessionStorageManager.listSessionKeys();
    if (keys.isEmpty) return null;

    final sessions = <String, Session>{};
    for (final key in keys) {
      final session = await SessionStorageManager.getSession(key);
      if (session != null) {
        sessions[key] = session;
      }
    }
    return sessions;
  }

  /// Refreshes the specified or active session.
  ///
  /// Uses the existing session to stamp a new login session and extend its validity.
  /// Generates a new key pair if no public key is provided.
  /// Stores the refreshed session JWT and updates the current session state only
  /// if it matches the active session key.
  ///
  /// [sessionKey] The key of the session to refresh. If null, uses the active session.
  /// [expirationSeconds] The desired expiration time for the new session in seconds.
  /// [publicKey] An optional public key to use for the new session. If null, a new key pair is generated.
  /// [invalidateExisting] Whether to invalidate existing sessions when refreshing.
  /// Returns the refreshed session result if successful, otherwise `null`.
  /// Throws an [Exception] if the session cannot be refreshed.
  Future<v1StampLoginResult?> refreshSession({
    String? sessionKey,
    String? expirationSeconds,
    String? publicKey,
    bool invalidateExisting = false,
  }) async {
    expirationSeconds ??= masterConfig?.authConfig?.sessionExpirationSeconds;

    try {
      final activeKey = await getActiveSessionKey();
      final key = sessionKey ?? activeKey;
      if (key == null) throw Exception("No active session to refresh");

      final currentSession = await getSession(sessionKey: key);
      if (currentSession == null)
        throw Exception("Session not found for key: $key");

      // generate or use provided public key
      final newPublicKey = publicKey ?? await createApiKeyPair();

      // create a new session using the current session
      final response = await requireClient.stampLogin(
        input: TStampLoginBody(
          organizationId: currentSession.organizationId,
          publicKey: newPublicKey,
          expirationSeconds: expirationSeconds,
          invalidateExisting: invalidateExisting,
        ),
      );

      final result = response.activity.result.stampLoginResult;
      if (result?.session == null) {
        throw Exception("No session found in refresh response");
      }

      // store the new session JWT
      // TODO (Amir): Does this need to be the helper function?
      await SessionStorageManager.storeSession(
        result?.session as String,
        sessionKey: key,
      );

      final newSession = await SessionStorageManager.getSession(key);
      if (newSession == null) {
        throw Exception("Failed to store or parse new session");
      }

      // we only update the in-memory client/session if this is the active session
      if (key == activeKey) {
        session = newSession;
        createClient(
          organizationId: newSession.organizationId,
          publicKey: newSession.publicKey,
        );
      }

      await _scheduleSessionExpiration(key, newSession.expiry);

      config.onSessionRefreshed?.call(newSession);

      return result;
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to refresh session: $error');
    }
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
  ///
  /// [sessionKey] The key of the session to clear.
  Future<void> clearSession({String? sessionKey}) async {
    final activeSessionKey = await getActiveSessionKey();
    final key = sessionKey ?? activeSessionKey;
    if (key == null) {
      throw Exception("No active session to clear");
    }

    final sessionToClear = await SessionStorageManager.getSession(key);
    if (sessionToClear == null) {
      throw Exception("No session found with key: $key");
    }

    final activeKey = await getActiveSessionKey();
    if (key == activeKey) {
      session = null;
      user = null;
      wallets = null;
      client = createClient();
      authState = AuthState.unauthenticated;
    }

    // delete the keypair
    await deleteApiKeyPair(sessionToClear.publicKey);

    // remove the session from storage
    await SessionStorageManager.clearSession(key);

    config.onSessionCleared?.call(sessionToClear);
  }

  /// Clears all stored sessions from secure storage.
  ///
  /// Retrieves all session keys and clears each session individually.
  /// Calls [clearSession] for each stored session, which handles deletion
  /// of associated API key pairs and invokes session cleared callbacks.
  /// If no sessions are found, the method returns without performing any operations.
  Future<void> clearAllSessions() async {
    final sessionKeys = await SessionStorageManager.listSessionKeys();
    if (sessionKeys.isEmpty) return;

    for (final key in sessionKeys) {
      await clearSession(sessionKey: key);
    }
  }
}