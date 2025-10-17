import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';
import 'package:uuid/uuid.dart';

import 'package:turnkey_sdk_flutter/src/stamper.dart';
import 'package:turnkey_sdk_flutter/src/storage.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'package:crypto/crypto.dart';

class TurnkeyProvider with ChangeNotifier {
  // these are external
  Session? _session;
  TurnkeyClient? _client;
  v1User? _user;
  List<Wallet>? _wallets;

  // these are internal
  TurnkeyConfig? _masterConfig;
  ProxyTGetWalletKitConfigResponse? _proxyAuthConfig;

  // immutable
  final TurnkeyConfig config;
  final SecureStorageStamper secureStorageStamper = SecureStorageStamper();
  final Map<String, Timer> expiryTimers = {};

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get ready => _initCompleter.future;

  TurnkeyProvider({required this.config}) {
    _init();
  }

  // these are externally used
  Session? get session => _session;
  TurnkeyClient? get client => _client;
  v1User? get user => _user;
  List<Wallet>? get wallets => _wallets;

  // these are internally used
  TurnkeyConfig? get masterConfig => _masterConfig;
  ProxyTGetWalletKitConfigResponse? get proxyAuthConfig => _proxyAuthConfig;

  // helper to get client or throw
  TurnkeyClient get requireClient {
    if (client == null) {
      throw StateError(
        'TurnkeyClient is not initialized. Make sure you have an active session '
        'and that `_client` was properly set before calling this method.',
      );
    }
    return client!;
  }

  // here we have setters that notify listeners
  // we do this for external properties only
  set session(Session? newSession) {
    _session = newSession;
    notifyListeners();
  }

  set client(TurnkeyClient? newClient) {
    _client = newClient;
    notifyListeners();
  }

  set user(v1User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  set wallets(List<Wallet>? newWallets) {
    _wallets = newWallets;
    notifyListeners();
  }

  Future<void> _init() async {
    await _boot();
    await SessionStorageManager.init();
    await _initializeSessions();
  }

  TurnkeyConfig _buildConfig({
    ProxyTGetWalletKitConfigResponse? proxyAuthConfig,
  }) {
    bool? _resolveMethod(bool? local, String providerKey) {
      if (local != null) return local;
      if (proxyAuthConfig == null) return null;
      return proxyAuthConfig.enabledProviders.contains(providerKey);
    }

    String? _resolveClientId(String? local, String proxyKey) {
      if (local != null && local.isNotEmpty) return local;
      return proxyAuthConfig?.oauthClientIds?[proxyKey];
    }

    String? _resolveRedirect(String? local) {
      if (local != null && local.isNotEmpty) return local;
      return proxyAuthConfig?.oauthRedirectUrl;
    }

    final usingAuthProxy = (config.authProxyConfigId ?? '').isNotEmpty;
    if (usingAuthProxy) {
      if (config.authConfig?.sessionExpirationSeconds != null) {
        stderr.writeln(
          'Turnkey SDK warning: `sessionExpirationSeconds` set directly in TurnkeyConfig will be ignored when using an auth proxy. Configure this in the Turnkey dashboard.',
        );
      }
      if (config.authConfig?.otpAlphanumeric != null) {
        stderr.writeln(
          'Turnkey SDK warning: `otpAlphanumeric` set directly in TurnkeyConfig will be ignored when using an auth proxy. Configure this in the Turnkey dashboard.',
        );
      }
      if (config.authConfig?.otpLength != null) {
        stderr.writeln(
          'Turnkey SDK warning: `otpLength` set directly in TurnkeyConfig will be ignored when using an auth proxy. Configure this in the Turnkey dashboard.',
        );
      }
    }

    // --- resolved methods ------------------------------------------------------
    final resolvedMethods = AuthMethods(
      emailOtpAuthEnabled: _resolveMethod(
          config.authConfig?.methods?.emailOtpAuthEnabled, 'email'),
      smsOtpAuthEnabled:
          _resolveMethod(config.authConfig?.methods?.smsOtpAuthEnabled, 'sms'),
      passkeyAuthEnabled: _resolveMethod(
          config.authConfig?.methods?.passkeyAuthEnabled, 'passkey'),
      walletAuthEnabled: _resolveMethod(
          config.authConfig?.methods?.walletAuthEnabled, 'wallet'),
      googleOauthEnabled: _resolveMethod(
          config.authConfig?.methods?.googleOauthEnabled, 'google'),
      xOauthEnabled:
          _resolveMethod(config.authConfig?.methods?.xOauthEnabled, 'x'),
      discordOauthEnabled: _resolveMethod(
          config.authConfig?.methods?.discordOauthEnabled, 'discord'),
      appleOauthEnabled: _resolveMethod(
          config.authConfig?.methods?.appleOauthEnabled, 'apple'),
      facebookOauthEnabled: _resolveMethod(
          config.authConfig?.methods?.facebookOauthEnabled, 'facebook'),
    );

    // --- resolved OAuth config -------------------------------------------------
    final resolvedOAuth = OAuthConfig(
      oauthRedirectUri:
          _resolveRedirect(config.authConfig?.oAuthConfig?.oauthRedirectUri),
      googleClientId: _resolveClientId(
          config.authConfig?.oAuthConfig?.googleClientId, 'google'),
      appleClientId: _resolveClientId(
          config.authConfig?.oAuthConfig?.appleClientId, 'apple'),
      facebookClientId: _resolveClientId(
          config.authConfig?.oAuthConfig?.facebookClientId, 'facebook'),
      xClientId:
          _resolveClientId(config.authConfig?.oAuthConfig?.xClientId, 'x'),
      discordClientId: _resolveClientId(
          config.authConfig?.oAuthConfig?.discordClientId, 'discord'),
    );

    // --- proxy-only settings (read from proxy when available) ------------------
    final sessionExpirationSeconds = proxyAuthConfig
            ?.sessionExpirationSeconds ??
        (usingAuthProxy ? null : config.authConfig?.sessionExpirationSeconds);

    final otpAlphanumeric = proxyAuthConfig?.otpAlphanumeric ??
        (usingAuthProxy ? null : config.authConfig?.otpAlphanumeric);

    final otpLength = proxyAuthConfig?.otpLength ??
        (usingAuthProxy ? null : config.authConfig?.otpLength);

    final resolvedAuth = AuthConfig(
      methods: resolvedMethods,
      oAuthConfig: resolvedOAuth,
      sessionExpirationSeconds: sessionExpirationSeconds,
      otpAlphanumeric: otpAlphanumeric,
      otpLength: otpLength,
    );

    return TurnkeyConfig(
      apiBaseUrl: config.apiBaseUrl,
      organizationId: config.organizationId,
      appScheme: config.appScheme,
      authConfig: resolvedAuth,
      authProxyBaseUrl: config.authProxyBaseUrl,
      authProxyConfigId: config.authProxyConfigId,
      onSessionCreated: config.onSessionCreated,
      onSessionSelected: config.onSessionSelected,
      onSessionExpired: config.onSessionExpired,
      onSessionCleared: config.onSessionCleared,
      onSessionRefreshed: config.onSessionRefreshed,
      onSessionEmpty: config.onSessionEmpty,
      onInitialized: config.onInitialized,
    );
  }

  Future<void> _boot() async {
    try {
      ProxyTGetWalletKitConfigResponse? proxy;
      if ((config.authProxyConfigId ?? '').isNotEmpty) {
        proxy = await _getAuthProxyConfig(
          config.authProxyConfigId!,
          config.authProxyBaseUrl,
        );
        _proxyAuthConfig = proxy;
        notifyListeners();
      }

      // we build the master config from  oAuthproxy (can be null)
      _masterConfig = _buildConfig(proxyAuthConfig: proxy);
      notifyListeners();
    } catch (e) {
      stderr.writeln("TurnkeyProvider boot failed: $e");
    }
  }

  Future<ProxyTGetWalletKitConfigResponse?> _getAuthProxyConfig(
      String configId, String? baseUrl) async {
    if (client == null) {
      _createClient(
        authProxyConfigId: configId,
        authProxyBaseUrl: baseUrl,
      );
    }

    return await requireClient.proxyGetWalletKitConfig(
      input: ProxyTGetWalletKitConfigBody(),
    );
  }

  /// Creates a new TurnkeyClient instance using the provided parameters.
  ///
  /// [organizationId] The ID of the organization to which the client will be associated.
  /// [publicKey] The public key to use for the client. If null, the existing public key in the stamper will be used.
  /// [apiBaseUrl] The base URL for the Turnkey API. If null, the value from the config or the default URL will be used.
  /// [authProxyConfigId] The configuration ID for the auth proxy. If null, the value from the config will be used.
  /// [authProxyBaseUrl] The base URL for the auth proxy. If null, the value from the config or the default URL will be used.
  /// Returns the newly created TurnkeyClient instance.
  TurnkeyClient _createClient(
      {String? organizationId,
      String? publicKey,
      String? apiBaseUrl,
      String? authProxyConfigId,
      String? authProxyBaseUrl}) {
    if (publicKey != null) secureStorageStamper.setPublicKey(publicKey);
    apiBaseUrl ??= config.apiBaseUrl ?? "https://api.turnkey.com";
    authProxyBaseUrl ??=
        config.authProxyBaseUrl ?? "https://auth-proxy.turnkey.com";
    authProxyConfigId ??= config.authProxyConfigId;
    organizationId ??= config.organizationId;

    final newClient = TurnkeyClient(
      config: THttpConfig(
        organizationId: organizationId,
        baseUrl: apiBaseUrl,
        authProxyConfigId: authProxyConfigId,
        authProxyBaseUrl: authProxyBaseUrl,
      ),
      stamper: secureStorageStamper,
    );

    client = newClient;
    return newClient;
  }

  /// Initializes stored sessions on mount.
  ///
  /// This function retrieves all stored session keys, validates their expiration status,
  /// removes expired sessions, and schedules expiration timers for active ones.
  /// Additionally, it loads the last selected session if it is still valid,
  /// otherwise it clears the session and triggers the session expiration callback.
  Future<void> _initializeSessions() async {
    // Reset current state
    session = null;

    try {
      _createClient();

      // we get all stored sessions
      final allSessions = await getAllSessions();
      if (allSessions == null || allSessions.isEmpty) {
        config.onSessionEmpty?.call();

        _initCompleter.complete();
        return;
      }

      // we iterate over all sessions and clean up expired ones
      for (final sessionKey in List<String>.from(allSessions.keys)) {
        final s = allSessions[sessionKey];

        if (s == null) continue;

        if (!isValidSession(s)) {
          await clearSession(sessionKey: sessionKey);

          allSessions.remove(sessionKey);
          continue;
        }

        await _scheduleSessionExpiration(sessionKey, s.expiry);
      }

      // we load the active session key (if it exists)
      final activeSessionKey = await getActiveSessionKey();
      if (activeSessionKey != null) {
        final activeSession = allSessions[activeSessionKey];
        if (activeSession != null) {
          session = activeSession;
          _createClient(
            publicKey: activeSession.publicKey,
            organizationId: activeSession.organizationId,
          );
          session = activeSession;

          await refreshUser();
          await refreshWallets();

          config.onSessionSelected?.call(activeSession);
        }
      } else {
        // if no active session, fire the empty callback
        config.onSessionEmpty?.call();
      }

      // we signal initialization complete
      _initCompleter.complete();
      config.onInitialized?.call(null);
    } catch (e, st) {
      stderr.writeln("TurnkeyProvider failed to initialize sessions: $e\n$st");
      _initCompleter.completeError(e, st);
      config.onInitialized?.call(e);
    }
  }

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

  /// Creates a new API key pair and optionally stores it as the active key.
  /// If `storeOverride` is true, the new key pair will replace the current active key in the client.
  ///
  /// [externalPublicKey] The external public key to use for the key pair. If null, a new key will be generated.
  /// [externalPrivateKey] The external private key to use for the key pair. If null, a new key will be generated.
  /// [isCompressed] Whether to create a key pair off of a compressed key pair. Defaults to true.
  /// [storeOverride] Whether to store the new key pair as the active key. Defaults to false.
  /// Returns the public key of the created key pair.
  Future<String> createApiKeyPair({
    String? externalPublicKey,
    String? externalPrivateKey,
    bool isCompressed = true,
    bool storeOverride = false,
  }) async {
    final publicKey = await SecureStorageStamper.createKeyPair(
      externalPublicKey: externalPublicKey,
      externalPrivateKey: externalPrivateKey,
      isCompressed: isCompressed,
    );

    // if `storeOverride` is true, we set the new key as the active key for this client instance
    if (storeOverride) {
      _createClient(
        publicKey: publicKey,
      );
    }

    return publicKey;
  }

  /// Deletes an API key pair from secure storage by its public key.
  /// [publicKey] The public key of the key pair to delete.
  Future<void> deleteApiKeyPair(String publicKey) async {
    await SecureStorageStamper.deleteKeyPair(publicKey);
  }

  /// Clears any key pairs that are not associated with an active session.
  Future<void> deleteUnusedKeyPairs() async {
    final publicKeys = await SecureStorageStamper.listKeyPairs();
    if (publicKeys.isEmpty) return;

    final sessionKeys = await SessionStorageManager.listSessionKeys();
    final activePublicKeys = <String>{};

    for (final key in sessionKeys) {
      final session = await SessionStorageManager.getSession(key);
      if (session != null) {
        activePublicKeys.add(session.publicKey);
      }
    }

    for (final pk in publicKeys) {
      if (!activePublicKeys.contains(pk)) {
        await SecureStorageStamper.deleteKeyPair(pk);
      }
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
    _createClient(
      publicKey: s.publicKey,
      organizationId: s.organizationId,
    );

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
    String expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? publicKey,
    bool invalidateExisting = false,
  }) async {
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
        _createClient(
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

  /// Logs in a user using a passkey.
  ///
  /// Generates or uses an existing API key pair for authentication.
  /// Stamps a login session with the provided relying party ID and optional parameters.
  /// Stores the session JWT and manages session state.
  /// Cleans up the generated key pair if it was not used for the session.
  ///
  /// [rpId] The relying party ID for the passkey authentication.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [expirationSeconds] The desired expiration time for the session in seconds.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [publicKey] An optional public key to use for the session. If null, a new key pair is generated.
  /// Returns a [LoginWithPasskeyResult] containing the session token if successful.
  /// Throws an [Exception] if the login process fails.
  Future<LoginWithPasskeyResult> loginWithPasskey({
    required String rpId,
    String? sessionKey,
    String expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? organizationId,
    String? publicKey,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    final apiBaseUrl = config.apiBaseUrl;

    String? generatedPublicKey;

    try {
      generatedPublicKey =
          publicKey ?? await createApiKeyPair(storeOverride: true);

      // TODO (Amir): We need to make it easier to create a passkeyclient. Maybe just expose it through the turnkeyProvider?
      final passkeyStamper = PasskeyStamper(PasskeyStamperConfig(rpId: rpId));
      final passkeyClient = TurnkeyClient(
          config: THttpConfig(
            baseUrl:
                apiBaseUrl ?? config.apiBaseUrl ?? "https://api.turnkey.com",
            organizationId: organizationId ?? config.organizationId,
          ),
          stamper: passkeyStamper);

      final loginResponse = await passkeyClient.stampLogin(
        input: TStampLoginBody(
          organizationId: organizationId,
          publicKey: generatedPublicKey,
          expirationSeconds: expirationSeconds,
        ),
      );

      final sessionToken = loginResponse.result?.session;
      if (sessionToken == null) {
        throw Exception('No session returned from stampLogin');
      }

      await storeSession(
        sessionJwt: sessionToken,
        sessionKey: sessionKey,
      );

      return LoginWithPasskeyResult(sessionToken: sessionToken);
    } catch (error) {
      deleteUnusedKeyPairs();
      throw Exception('Failed to login with passkey: $error');
    }
  }

  /// Signs up a new user using a passkey.
  ///
  /// Generates a temporary API key pair for one-tap passkey sign-up.
  /// Creates a passkey and uses it to create a new sub-organization user.
  /// Stamps a login session for the new user and stores the session JWT.
  /// Cleans up the generated key pairs after use.
  ///
  /// [rpId] The relying party ID for the passkey registration.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [expirationSeconds] The desired expiration time for the session in seconds.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [passkeyDisplayName] An optional display name for the passkey.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user.
  /// [invalidateExisting] Whether to invalidate existing sessions when signing up.
  /// Returns a [SignUpWithPasskeyResult] containing the session token and credential ID if successful.
  /// Throws an [Exception] if the sign-up process fails.
  Future<SignUpWithPasskeyResult> signUpWithPasskey({
    required String rpId,
    String? sessionKey,
    String expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? organizationId,
    String? passkeyDisplayName,
    CreateSubOrgParams? createSubOrgParams,
    bool invalidateExisting = false,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;

    String? generatedPublicKey;
    String? temporaryPublicKey;

    try {
      // for one-tap passkey sign-up, we generate a temporary API key pair
      // which is added as an authentication method for the new sub-org user
      // this allows us to stamp the session creation request immediately after
      // without prompting the user
      temporaryPublicKey = await createApiKeyPair(storeOverride: true);
      final passkeyName = passkeyDisplayName ??
          'passkey-${DateTime.now().millisecondsSinceEpoch}';

      // create a passkey
      final passkey = await createPasskey(
        PasskeyRegistrationConfig(
          rp: RelyingParty(
            id: rpId,
            name: 'Flutter App',
          ),
          user: WebAuthnUser(
            id: const Uuid().v4(),
            name: 'Anonymous User',
            displayName: 'Anonymous User',
          ),
          authenticatorName: passkeyName,
        ),
      );

      final encodedChallenge = passkey.encodedChallenge;
      final attestation = passkey.attestation;

      final overrideParams = PasskeyOverridedParams(
          passkeyName: passkeyName,
          attestation: attestation,
          encodedChallenge: encodedChallenge,
          temporaryPublicKey: temporaryPublicKey);
      final updatedCreateSubOrgParams =
          getCreateSubOrgParams(createSubOrgParams, config, overrideParams);

      final signUpBody =
          buildSignUpBody(createSubOrgParams: updatedCreateSubOrgParams);

      final res = await requireClient.proxySignup(input: signUpBody);

      final orgId = res.organizationId;
      if (orgId.isEmpty) {
        throw Exception("Sign up failed: No organizationId returned");
      }

      // now we generate a second key pair that will become the session keypair
      generatedPublicKey = await createApiKeyPair();

      final loginResponse = await requireClient.stampLogin(
        input: TStampLoginBody(
          organizationId: orgId,
          publicKey: generatedPublicKey,
          expirationSeconds: expirationSeconds.toString(),
          invalidateExisting: invalidateExisting,
        ),
      );

      final sessionToken = loginResponse.result?.session;
      if (sessionToken == null) {
        throw Exception('No session returned from stampLogin');
      }

      await storeSession(sessionJwt: sessionToken, sessionKey: sessionKey);

      return SignUpWithPasskeyResult(
        sessionToken: sessionToken,
        credentialId: attestation.credentialId,
      );
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to sign up with passkey: $error');
    }
  }

  /// Initializes an OTP (One-Time Password) request for the specified contact method.
  ///
  /// Sends a request to the backend to generate and send an OTP to the provided contact (email or phone number).
  /// Returns the OTP ID that can be used for subsequent verification.
  ///
  /// [otpType] The type of OTP to initialize (email or SMS).
  /// [contact] The contact information (email address or phone number) to send the OTP to.
  /// Returns a [String] representing the OTP ID.
  /// Throws an [Exception] if the OTP initialization fails.
  Future<String> initOtp(
      {required OtpType otpType, required String contact}) async {
    final res = await requireClient.proxyInitOtp(
        input: ProxyTInitOtpBody(
      contact: contact,
      otpType: otpType.value,
    ));

    return res.otpId;
  }

  /// Verifies an OTP code and retrieves a verification token and sub-organization ID.
  ///
  /// Throws an [Exception] if the OTP verification fails or if the account cannot be retrieved.
  ///
  /// [otpCode] The OTP code to verify.
  /// [otpId] The ID of the OTP to verify.
  /// [contact] The contact information (email or phone number) associated with the OTP.
  /// [otpType] The type of OTP (email or SMS).
  /// Returns a [VerifyOtpResult] containing the verification token and sub-organization ID.
  Future<VerifyOtpResult> verifyOtp(
      {required String otpCode,
      required String otpId,
      required String contact,
      required OtpType otpType}) async {
    final verifyOtpRes = await requireClient.proxyVerifyOtp(
        input: ProxyTVerifyOtpBody(
      otpCode: otpCode,
      otpId: otpId,
    ));

    if (verifyOtpRes.verificationToken.isEmpty) {
      throw Exception("Failed to verify OTP");
    }

    final accountRes = await requireClient.proxyGetAccount(
        input: ProxyTGetAccountBody(
            filterType: otpTypeToFilterTypeMap[otpType]!.value,
            filterValue: contact));

    final subOrganizationId = accountRes.organizationId;
    return VerifyOtpResult(
        subOrganizationId: subOrganizationId,
        verificationToken: verifyOtpRes.verificationToken);
  }

  /// Logs in a user using an OTP (One-Time Password) verification token.
  ///
  /// Generates or uses an existing API key pair for authentication.
  /// Sends a login request to the backend with the provided verification token and optional parameters.
  /// Stores the session JWT and manages session state.
  /// Cleans up the generated key pair if it was not used for the session.
  ///
  /// [verificationToken] The OTP verification token received after verifying the OTP code.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [invalidateExisting] Whether to invalidate existing sessions when logging in.
  /// [publicKey] An optional public key to use for the session. If null, a new key pair is generated.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// Returns a [LoginWithOtpResult] containing the session token if successful.
  /// Throws an [Exception] if the login process fails.
  Future<LoginWithOtpResult> loginWithOtp({
    required String verificationToken,
    String? organizationId,
    bool invalidateExisting = false,
    String? publicKey,
    String? sessionKey,
  }) async {
    String? generatedPublicKey;

    try {
      generatedPublicKey = publicKey ?? await createApiKeyPair();

      final res = await requireClient.proxyOtpLogin(
        input: ProxyTOtpLoginBody(
          organizationId: organizationId,
          publicKey: generatedPublicKey,
          verificationToken: verificationToken,
          invalidateExisting: invalidateExisting,
        ),
      );

      await storeSession(sessionJwt: res.session, sessionKey: sessionKey);

      return LoginWithOtpResult(
        sessionToken: res.session,
      );
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login with otp: $error');
    }
  }

  /// Signs up a new user using an OTP (One-Time Password) verification token.
  ///
  /// Generates a temporary API key pair for OTP sign-up.
  /// Creates a new sub-organization user with the provided contact information and verification token.
  /// Stamps a login session for the new user and stores the session JWT.
  /// Cleans up the generated key pair after use.
  ///
  /// [verificationToken] The OTP verification token received after verifying the OTP code.
  /// [contact] The contact information (email address or phone number) associated with the OTP.
  /// [otpType] The type of OTP (email or SMS).
  /// [publicKey] An optional public key to use for the session. If null, a new key pair is generated.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user.
  /// [invalidateExisting] Whether to invalidate existing sessions when signing up.
  /// Returns a [SignUpWithOtpResult] containing the session token if successful.
  /// Throws an [Exception] if the sign-up process fails.
  Future<SignUpWithOtpResult> signUpWithOtp({
    required String verificationToken,
    required String contact,
    required OtpType otpType,
    String? publicKey,
    String? sessionKey,
    CreateSubOrgParams? createSubOrgParams,
    bool invalidateExisting = false,
  }) async {
    final overrideParams = OtpOverriredParams(
      otpType: otpType,
      contact: contact,
      verificationToken: verificationToken,
    );
    final updatedCreateSubOrgParams =
        getCreateSubOrgParams(createSubOrgParams, config, overrideParams);

    final signUpBody =
        buildSignUpBody(createSubOrgParams: updatedCreateSubOrgParams);

    try {
      final res = await requireClient.proxySignup(input: signUpBody);

      final orgId = res.organizationId;
      if (orgId.isEmpty) {
        throw Exception("Sign up failed: No organizationId returned");
      }

      final response = await loginWithOtp(
        organizationId: orgId,
        verificationToken: verificationToken,
        sessionKey: sessionKey,
        invalidateExisting: invalidateExisting,
      );

      return SignUpWithOtpResult(sessionToken: response.sessionToken);
    } catch (e) {
      throw Exception("Sign up failed: $e");
    }
  }

  /// Completes the OTP (One-Time Password) authentication process.
  ///
  /// Verifies the provided OTP code and determines whether to log in an existing user or sign up a new user.
  /// If the user exists, logs them in and returns the session token.
  /// If the user does not exist, signs them up and returns the session token.
  /// Cleans up any generated key pairs after use.
  ///
  /// [otpId] The ID of the OTP to verify.
  /// [otpCode] The OTP code to verify.
  /// [contact] The contact information (email or phone number) associated with the OTP.
  /// [otpType] The type of OTP (email or SMS).
  /// [publicKey] An optional public key to use for the session. If null, a new key pair is generated.
  /// [invalidateExisting] Whether to invalidate existing sessions when logging in or signing up.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user during sign-up.
  /// Returns a [LoginOrSignUpOtpResult] containing the session token and action (login or signup) if successful.
  /// Throws an [Exception] if the OTP authentication process fails.
  Future<LoginOrSignUpWithOtpResult> loginOrSignUpWithOtp({
    required String otpId,
    required String otpCode,
    required String contact,
    required OtpType otpType,
    String? publicKey = null,
    bool invalidateExisting = false,
    String? sessionKey = null,
    CreateSubOrgParams? createSubOrgParams,
  }) async {
    try {
      final result = await verifyOtp(
          otpCode: otpCode, otpId: otpId, contact: contact, otpType: otpType);

      if (result.subOrganizationId != null &&
          result.subOrganizationId!.isNotEmpty) {
        final loginResp = await loginWithOtp(
          verificationToken: result.verificationToken,
          organizationId: result.subOrganizationId,
          invalidateExisting: invalidateExisting,
          publicKey: publicKey,
          sessionKey: sessionKey,
        );

        return LoginOrSignUpWithOtpResult(
            sessionToken: loginResp.sessionToken, action: AuthAction.login);
      } else {
        final signUpRes = await signUpWithOtp(
            verificationToken: result.verificationToken,
            contact: contact,
            otpType: otpType,
            publicKey: publicKey,
            sessionKey: sessionKey,
            createSubOrgParams: createSubOrgParams,
            invalidateExisting: invalidateExisting);

        return LoginOrSignUpWithOtpResult(
            sessionToken: signUpRes.sessionToken, action: AuthAction.signup);
      }
    } catch (e) {
      throw Exception("OTP authentication failed: $e");
    }
  }

  /// Logs in a user using an OAuth token.
  ///
  /// Sends a login request to the backend with the provided OIDC token and public key.
  /// Stores the session JWT and manages session state.
  ///
  /// [oidcToken] The OIDC token received from the OAuth provider.
  /// [publicKey] The public key to use for the session.
  /// [invalidateExisting] Whether to invalidate existing sessions when logging in.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// Returns a [LoginWithOAuthResult] containing the session token if successful.
  /// Throws an [Exception] if the login process fails.
  Future<LoginWithOAuthResult> loginWithOAuth({
    required String oidcToken,
    required String publicKey,
    bool? invalidateExisting = false,
    String? sessionKey,
  }) async {
    try {
      final loginRes = await requireClient.proxyOAuthLogin(
          input: ProxyTOAuthLoginBody(
              oidcToken: oidcToken,
              publicKey: publicKey,
              invalidateExisting: invalidateExisting));
      await storeSession(sessionJwt: loginRes.session, sessionKey: sessionKey);
      return LoginWithOAuthResult(sessionToken: loginRes.session);
    } catch (e) {
      throw Exception("OAuth login failed: $e");
    }
  }

  /// Signs up a new user using an OAuth token.
  ///
  /// Generates a temporary API key pair for OAuth sign-up.
  /// Creates a new sub-organization user with the provided OIDC token and provider name.
  /// Stamps a login session for the new user and stores the session JWT.
  /// Cleans up the generated key pair after use.
  ///
  /// [oidcToken] The OIDC token received from the OAuth provider.
  /// [publicKey] The public key to use for the session.
  /// [providerName] The name of the OAuth provider (e.g., "google", "x", "discord").
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user.
  /// Returns a [SignUpWithOAuthResult] containing the session token if successful.
  /// Throws an [Exception] if the sign-up process fails.
  Future<SignUpWithOAuthResult> signUpWithOAuth({
    required String oidcToken,
    required String publicKey,
    required String providerName,
    String? sessionKey,
    CreateSubOrgParams? createSubOrgParams,
  }) async {
    final overrideParams = OAuthOverridedParams(
      oidcToken: oidcToken,
      providerName: providerName,
    );
    final updatedCreateSubOrgParams =
        getCreateSubOrgParams(createSubOrgParams, config, overrideParams);

    final signUpBody =
        buildSignUpBody(createSubOrgParams: updatedCreateSubOrgParams);

    try {
      final res = await requireClient.proxySignup(input: signUpBody);

      final organizationId = res.organizationId;
      if (organizationId.isEmpty) {
        throw Exception("Sign up failed: No organizationId returned");
      }

      final response = await loginWithOAuth(
        oidcToken: oidcToken,
        publicKey: publicKey,
        sessionKey: sessionKey,
      );

      return SignUpWithOAuthResult(sessionToken: response.sessionToken);
    } catch (e) {
      throw Exception("Sign up failed: $e");
    }
  }

  /// Completes the OAuth authentication process.
  ///
  /// Verifies the provided OIDC token and determines whether to log in an existing user or sign up a new user.
  /// If the user exists, logs them in and returns the session token.
  /// If the user does not exist, signs them up and returns the session token.
  /// Cleans up any generated key pairs after use.
  ///
  /// [oidcToken] The OIDC token received from the OAuth provider.
  /// [publicKey] The public key to use for the session.
  /// [providerName] The name of the OAuth provider (e.g., "google", "x", "discord"). Required for sign-up.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Whether to invalidate existing sessions when logging in or signing up.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user during sign-up.
  /// Returns a [LoginOrSignUpOAuthResult] containing the session token and action (login or signup) if successful.
  /// Throws an [Exception] if the OAuth authentication process fails.
  Future<LoginOrSignUpWithOAuthResult> loginOrSignUpWithOAuth({
    required String oidcToken,
    required String publicKey,
    String? providerName,
    String? sessionKey,
    bool? invalidateExisting,
    CreateSubOrgParams? createSubOrgParams,
  }) async {
    try {
      final accountRes = await requireClient.proxyGetAccount(
          input: ProxyTGetAccountBody(
              filterType: "OIDC_TOKEN", filterValue: oidcToken));

      if (accountRes.organizationId?.isNotEmpty == true) {
        final loginRes = await loginWithOAuth(
          oidcToken: oidcToken,
          publicKey: publicKey,
          sessionKey: sessionKey,
          invalidateExisting: invalidateExisting,
        );
        return LoginOrSignUpWithOAuthResult(
            sessionToken: loginRes.sessionToken, action: AuthAction.login);
      } else {
        if (providerName == null || providerName.isEmpty) {
          throw Exception("Provider name is required for sign up");
        }
        final signUpRes = await signUpWithOAuth(
            oidcToken: oidcToken,
            publicKey: publicKey,
            providerName: providerName,
            sessionKey: sessionKey,
            createSubOrgParams: createSubOrgParams);

        return LoginOrSignUpWithOAuthResult(
            sessionToken: signUpRes.sessionToken, action: AuthAction.signup);
      }
    } catch (e) {
      throw Exception("OAuth authentication failed: $e");
    }
  }

  /// Handles the Google OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes `loginOrSignUpWithOAuth` or the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional client ID that overrides the default client ID passed into the config or pulled from the Wallet Kit dashboard for Google OAuth.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to TURNKEY_OAUTH_ORIGIN_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow. Defaults to a constructed URI with the provided scheme.
  /// [onSuccess] Optional callback function that receives the oidcToken upon successful authentication, overrides default behavior.
  Future<void> handleGoogleOAuth({
    String? clientId,
    String? originUri = TURNKEY_OAUTH_ORIGIN_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    void Function(String oidcToken)? onSuccess,
  }) async {
    final scheme = config.appScheme;
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final googleClientId = clientId ??
          masterConfig?.authConfig?.oAuthConfig?.googleClientId ??
          (throw Exception("Google Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          masterConfig?.authConfig?.oAuthConfig?.oauthRedirectUri ??
          '${TURNKEY_OAUTH_REDIRECT_URL}?scheme=${Uri.encodeComponent(scheme)}';

      final oauthUrl = originUri! +
          '?provider=google' +
          '&clientId=${Uri.encodeComponent(googleClientId)}' +
          '&redirectUri=${Uri.encodeComponent(resolvedRedirectUri)}' +
          '&nonce=${Uri.encodeComponent(nonce)}';

      // we create a completer to wait for the authentication result
      final Completer<void> authCompleter = Completer<void>();

      // set up a subscription for deep links
      StreamSubscription? subscription;
      subscription = appLinks.uriLinkStream.listen((Uri? uri) async {
        if (uri != null && uri.toString().startsWith(scheme)) {
          // we parse query parameters from the URI
          final idToken = uri.queryParameters['id_token'];

          if (idToken != null) {
            if (onSuccess != null) {
              onSuccess(idToken);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: idToken,
                publicKey: targetPublicKey,
                providerName: 'google',
                sessionKey: sessionKey,
                invalidateExisting: invalidateExisting,
              );
            }

            // complete the auth process
            // this runs the `whenComplete()` callback
            if (!authCompleter.isCompleted) {
              authCompleter.complete();
            }
          }
        }
      });

      try {
        final browser = _OAuthBrowser(
          onBrowserClosed: () {
            if (!authCompleter.isCompleted) {
              subscription?.cancel();
              authCompleter.complete();
              return;
            }
          },
        );

        await browser.open(
          url: WebUri(oauthUrl),
          settings: ChromeSafariBrowserSettings(
            showTitle: true,
            toolbarBackgroundColor: Colors.white,
          ),
        );

        // set a timeout for the authentication process
        await authCompleter.future.timeout(
          const Duration(minutes: 10),
          onTimeout: () {
            subscription?.cancel();
            throw Exception('Authentication timed out');
          },
        );

        await authCompleter.future.whenComplete(() async {
          await browser.close();
          subscription?.cancel();
        });
      } catch (e) {
        subscription.cancel();
        throw Exception('Google OAuth failed in browser: $e');
      }
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login or signup with Google: $error');
    }
  }

  Future<void> handleAppleOAuth({
    String? clientId,
    String? originUri = APPLE_AUTH_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    void Function(String oidcToken)? onSuccess,
  }) async {
    final scheme = config.appScheme;
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final appleClientId = clientId ??
          masterConfig?.authConfig?.oAuthConfig?.appleClientId ??
          (throw Exception("Apple Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          masterConfig?.authConfig?.oAuthConfig?.oauthRedirectUri ??
          '${TURNKEY_OAUTH_REDIRECT_URL}?scheme=${Uri.encodeComponent(scheme)}';

      final oauthUrl = originUri! +
          '?provider=apple' +
          '&clientId=${Uri.encodeComponent(appleClientId)}' +
          '&redirectUri=${Uri.encodeComponent(resolvedRedirectUri)}' +
          '&nonce=${Uri.encodeComponent(nonce)}';

      final Completer<void> authCompleter = Completer<void>();

      // set up a subscription for deep links
      StreamSubscription? subscription;
      subscription = appLinks.uriLinkStream.listen((Uri? uri) async {
        if (uri != null && uri.toString().startsWith(scheme)) {
          // we parse query parameters from the URI
          final idToken = uri.queryParameters['id_token'];

          if (idToken != null) {
            if (onSuccess != null) {
              onSuccess(idToken);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: idToken,
                publicKey: targetPublicKey,
                providerName: 'apple',
                sessionKey: sessionKey,
                invalidateExisting: invalidateExisting,
              );
            }

            // complete the auth process
            // this runs the `whenComplete()` callback
            if (!authCompleter.isCompleted) {
              authCompleter.complete();
            }
          }
        }
      });

      try {
        final browser = _OAuthBrowser(
          onBrowserClosed: () {
            if (!authCompleter.isCompleted) {
              subscription?.cancel();
              authCompleter.complete();
              return;
            }
          },
        );

        await browser.open(
          url: WebUri(oauthUrl),
          settings: ChromeSafariBrowserSettings(
            showTitle: true,
            toolbarBackgroundColor: Colors.white,
          ),
        );

        // set a timeout for the authentication process
        await authCompleter.future.timeout(
          const Duration(minutes: 10),
          onTimeout: () {
            subscription?.cancel();
            throw Exception('Authentication timed out');
          },
        );

        await authCompleter.future.whenComplete(() async {
          await browser.close();
          subscription?.cancel();
        });
      } catch (e) {
        subscription.cancel();
        throw Exception('Apple OAuth failed in browser: $e');
      }
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login or signup with Apple: $error');
    }
  }

  /// Handles the X (formerly Twitter) OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes `loginOrSignUpWithOAuth` or the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional client ID that overrides the default client ID passed into the config or pulled from the Wallet Kit dashboard for X OAuth.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to X_AUTH_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow. Defaults to a constructed URI with the provided scheme.
  /// [onSuccess] Optional callback function that receives the oidcToken upon successful authentication, overrides default behavior.
  Future<void> handleXOAuth({
    String? clientId,
    String? originUri = X_AUTH_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    void Function(String oidcToken)? onSuccess,
  }) async {
    final scheme = config.appScheme;
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = await createApiKeyPair();

    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final xClientId = clientId ??
          masterConfig?.authConfig?.oAuthConfig?.xClientId ??
          (throw Exception("X Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          masterConfig?.authConfig?.oAuthConfig?.oauthRedirectUri ??
          '${config.appScheme}://';

      final challengePair = await generateChallengePair();
      final verifier = challengePair.verifier;
      final codeChallenge = challengePair.codeChallenge;

      final state =
          'provider=twitter&flow=redirect&publicKey=${Uri.encodeComponent(targetPublicKey)}&nonce=${nonce}';

      final xAuthUrl = originUri! +
          '?client_id=${Uri.encodeComponent(xClientId)}' +
          '&redirect_uri=${Uri.encodeComponent(resolvedRedirectUri)}' +
          '&response_type=code' +
          '&code_challenge=${Uri.encodeComponent(codeChallenge)}' +
          '&code_challenge_method=S256' +
          '&scope=${Uri.encodeComponent("tweet.read users.read")}' +
          '&state=${Uri.encodeComponent(state)}';

      // we create a completer to wait for the authentication result
      final Completer<void> authCompleter = Completer<void>();

      // set up a subscription for deep links
      StreamSubscription? subscription;
      subscription = appLinks.uriLinkStream.listen((Uri? uri) async {
        if (uri != null && uri.toString().startsWith(scheme)) {
          // we parse query parameters from the URI
          final authCode = uri.queryParameters['code'];

          if (authCode != null) {
            final res = await requireClient.proxyOAuth2Authenticate(
                input: ProxyTOAuth2AuthenticateBody(
                    provider: v1Oauth2Provider.oauth2_provider_x,
                    authCode: authCode,
                    redirectUri: resolvedRedirectUri,
                    codeVerifier: verifier,
                    clientId: xClientId,
                    nonce: nonce));

            final oidcToken = res.oidcToken;

            if (onSuccess != null) {
              onSuccess(oidcToken);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: oidcToken,
                publicKey: targetPublicKey,
                providerName: 'x',
                sessionKey: sessionKey,
                invalidateExisting: invalidateExisting,
              );
            }

            // complete the auth process
            // this runs the `whenComplete()` callback
            if (!authCompleter.isCompleted) {
              authCompleter.complete();
            }
          }
        }
      });

      try {
        final browser = _OAuthBrowser(
          onBrowserClosed: () {
            if (!authCompleter.isCompleted) {
              subscription?.cancel();
              authCompleter.complete();
              return;
            }
          },
        );

        await browser.open(
          url: WebUri(xAuthUrl),
          settings: ChromeSafariBrowserSettings(
            showTitle: true,
            toolbarBackgroundColor: Colors.white,
          ),
        );

        // we set a timeout for the authentication process
        await authCompleter.future.timeout(
          const Duration(minutes: 10),
          onTimeout: () {
            subscription?.cancel();
            throw Exception('Authentication timed out');
          },
        );

        await authCompleter.future.whenComplete(() async {
          await browser.close();
          subscription?.cancel();
        });
      } catch (e) {
        subscription.cancel();
        throw Exception('X OAuth failed in browser: $e');
      }
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login or signup with X: $error');
    }
  }

  /// Handles the Discord OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes `loginOrSignUpWithOAuth` or the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional client ID that overrides the default client ID passed into the config or pulled from the Wallet Kit dashboard for Discord OAuth.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to DISCORD_AUTH_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow. Defaults to a constructed URI with the provided scheme.
  /// [onSuccess] Optional callback function that receives the oidcToken upon successful authentication, overrides default behavior.
  Future<void> handleDiscordOAuth({
    String? clientId,
    String? originUri = DISCORD_AUTH_URL,
    String? redirectUri,
    String? sessionKey,
    String? invalidateExisting,
    void Function(String oidcToken)? onSuccess,
  }) async {
    final scheme = config.appScheme;
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final discordClientId = clientId ??
          masterConfig?.authConfig?.oAuthConfig?.discordClientId ??
          (throw Exception("Discord Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          masterConfig?.authConfig?.oAuthConfig?.oauthRedirectUri ??
          '${scheme}://';

      final challengePair = await generateChallengePair();
      final verifier = challengePair.verifier;
      final codeChallenge = challengePair.codeChallenge;

      final state =
          'provider=discord&flow=redirect&publicKey=${Uri.encodeComponent(targetPublicKey)}&nonce=${nonce}';

      final discordAuthUrl = originUri! +
          '?client_id=${Uri.encodeComponent(discordClientId)}' +
          '&redirect_uri=${Uri.encodeComponent(resolvedRedirectUri)}' +
          '&response_type=code' +
          '&code_challenge=${Uri.encodeComponent(codeChallenge)}' +
          '&code_challenge_method=S256' +
          '&scope=${Uri.encodeComponent("identify email")}' +
          '&state=${Uri.encodeComponent(state)}';

      // we create a completer to wait for the authentication result
      final Completer<void> authCompleter = Completer<void>();

      // set up a subscription for deep links
      StreamSubscription? subscription;
      subscription = appLinks.uriLinkStream.listen((Uri? uri) async {
        if (uri != null && uri.toString().startsWith(scheme)) {
          // we parse query parameters from the URI
          final authCode = uri.queryParameters['code'];

          if (authCode != null) {
            final res = await requireClient.proxyOAuth2Authenticate(
                input: ProxyTOAuth2AuthenticateBody(
                    provider: v1Oauth2Provider.oauth2_provider_discord,
                    authCode: authCode,
                    redirectUri: resolvedRedirectUri,
                    codeVerifier: verifier,
                    clientId: discordClientId,
                    nonce: nonce));

            final oidcToken = res.oidcToken;

            if (onSuccess != null) {
              onSuccess(oidcToken);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: oidcToken,
                publicKey: targetPublicKey,
                providerName: 'discord',
              );
            }

            // complete the auth process
            // this runs the `whenComplete()` callback
            if (!authCompleter.isCompleted) {
              authCompleter.complete();
            }
          }
        }
      });

      try {
        final browser = _OAuthBrowser(
          onBrowserClosed: () {
            if (!authCompleter.isCompleted) {
              subscription?.cancel();
              authCompleter.complete();
              return;
            }
          },
        );

        await browser.open(
          url: WebUri(discordAuthUrl),
          settings: ChromeSafariBrowserSettings(
            showTitle: true,
            toolbarBackgroundColor: Colors.white,
          ),
        );

        // we set a timeout for the authentication process
        await authCompleter.future.timeout(
          const Duration(minutes: 10),
          onTimeout: () {
            subscription?.cancel();
            throw Exception('Authentication timed out');
          },
        );

        await authCompleter.future.whenComplete(() async {
          await browser.close();
          subscription?.cancel();
        });
      } catch (e) {
        subscription.cancel();
        throw Exception('Discord OAuth failed in browser: $e');
      }
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login or signup with Discord: $error');
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
    if (session == null) {
      throw Exception("Failed to refresh user. Sessions not initialized");
    }
    user = await fetchUser(
        requireClient, session!.organizationId, session!.userId);
  }

  /// Refreshes the current wallets data.
  ///
  /// Fetches the latest wallet details from the API using the current session's client.
  /// If the wallet data is successfully retrieved, updates the state with the new wallet information.
  ///
  /// Throws an [Exception] if the session is not initialized.
  Future<void> refreshWallets() async {
    if (session == null) {
      throw Exception("Failed to refresh wallets. No session initialized");
    }
    wallets = await fetchWallets(requireClient, session!.organizationId);
  }

  /// Creates a new wallet with the specified name and accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [walletName] The name of the wallet.
  /// [accounts] The accounts to create in the wallet.
  /// [mnemonicLength] The length of the mnemonic.
  Future<v1Activity> createWallet(
      {required String walletName,
      required List<v1WalletAccountParams> accounts,
      int? mnemonicLength}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.createWallet(
        input: TCreateWalletBody(
      accounts: accounts,
      walletName: walletName,
      mnemonicLength: mnemonicLength,
    ));
    final activity = response.activity;
    if (activity.result.createWalletResult?.walletId != null) {
      await refreshWallets();
    }

    return activity;
  }

  /// Imports a wallet using a provided mnemonic and creates accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [mnemonic] The mnemonic to import.
  /// [walletName] The name of the wallet.
  /// [accounts] The accounts to create in the wallet.
  Future<void> importWallet(
      {required String mnemonic,
      required String walletName,
      required List<v1WalletAccountParams> accounts}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    // this should never happen
    if (user == null) {
      throw Exception("No user found.");
    }

    final initResponse = await requireClient.initImportWallet(
        input: TInitImportWalletBody(userId: user!.userId));

    final importBundle =
        initResponse.activity.result.initImportWalletResult?.importBundle;

    if (importBundle == null) {
      throw Exception("Failed to get import bundle");
    }

    final encryptedBundle = await encryptWalletToBundle(
      mnemonic: mnemonic,
      importBundle: importBundle,
      userId: user!.userId,
      organizationId: session!.organizationId,
    );

    final response = await requireClient.importWallet(
        input: TImportWalletBody(
            userId: user!.userId,
            walletName: walletName,
            encryptedBundle: encryptedBundle,
            accounts: accounts));
    final activity = response.activity;
    if (activity.result.importWalletResult?.walletId != null) {
      await refreshWallets();
    }
  }

  /// Exports an existing wallet by decrypting the stored mnemonic phrase.
  ///
  /// Throws an [Exception] if the client, user, or export bundle is not initialized.
  ///
  /// [walletId] The ID of the wallet to export.
  Future<String> exportWallet({required String walletId}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final keyPair = await generateP256KeyPair();

    final response = await requireClient.exportWallet(
        input: TExportWalletBody(
            walletId: walletId,
            targetPublicKey: keyPair.publicKeyUncompressed));
    final exportBundle =
        response.activity.result.exportWalletResult?.exportBundle;

    if (exportBundle == null) {
      throw Exception("Export bundle, embedded key, or user not initialized");
    }

    await refreshWallets();

    return await decryptExportBundle(
        exportBundle: exportBundle,
        embeddedKey: keyPair.privateKey,
        organizationId: session!.organizationId,
        returnMnemonic: true);
  }

  /// Signs a raw payload using the specified signing key and encoding parameters.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [signWith] The key to sign with.
  /// [payload] The payload to sign.
  /// [encoding] The encoding of the payload.
  /// [hashFunction] The hash function to use.
  Future<v1SignRawPayloadResult> signRawPayload(
      {required String signWith,
      required String payload,
      required v1PayloadEncoding encoding,
      required v1HashFunction hashFunction}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.signRawPayload(
        input: TSignRawPayloadBody(
      signWith: signWith,
      payload: payload,
      encoding: encoding,
      hashFunction: hashFunction,
    ));

    final signRawPayloadResult = response.activity.result.signRawPayloadResult;
    if (signRawPayloadResult == null) {
      throw Exception("Failed to sign raw payload");
    }
    return signRawPayloadResult;
  }

  /// Signs a transaction using the specified signing key and transaction parameters.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [signWith] The key to sign with.
  /// [unsignedTransaction] The unsigned transaction to sign.
  /// [type] The type of the transaction from the [TransactionType] enum.
  Future<v1SignTransactionResult> signTransaction(
      {required String signWith,
      required String unsignedTransaction,
      required v1TransactionType type}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.signTransaction(
        input: TSignTransactionBody(
            signWith: signWith,
            unsignedTransaction: unsignedTransaction,
            type: type));

    final signTransactionResult =
        response.activity.result.signTransactionResult;
    if (signTransactionResult == null) {
      throw Exception("Failed to sign transaction");
    }
    return signTransactionResult;
  }
}

// we create a custom browser class to handle the onClosed event
class _OAuthBrowser extends ChromeSafariBrowser {
  final VoidCallback onBrowserClosed;

  _OAuthBrowser({required this.onBrowserClosed});

  @override
  void onClosed() {
    onBrowserClosed();
    super.onClosed();
  }
}
