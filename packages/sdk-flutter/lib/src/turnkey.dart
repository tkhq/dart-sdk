import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:turnkey_http/__generated__/models.dart';

import 'package:turnkey_sdk_flutter/src/stamper.dart';
import 'package:turnkey_sdk_flutter/src/storage.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class TurnkeyProvider with ChangeNotifier {
  Session? _session;
  TurnkeyClient? _client;
  // TODO (Amir): Maybe we can make these public. Also, do they need to be async initted?
  SecureStorageStamper _secureStorageStamper = SecureStorageStamper();
  Map<String, Timer> _expiryTimers = {};

  final TurnkeyConfig config;

  final Completer<void> _initCompleter = Completer<void>();
  Future<void> get ready => _initCompleter.future;

  TurnkeyProvider({required this.config}) {
    _init();
  }

  Session? get session => _session;
  TurnkeyClient? get client => _client;
  SecureStorageStamper get secureStorageStamper => _secureStorageStamper;

  set session(Session? newSession) {
    _session = newSession;
    notifyListeners();
  }

  set client(TurnkeyClient? newClient) {
    _client = newClient;
    notifyListeners();
  }

  Future<void> _init() async {
    print("🔑 Initializing TurnkeyProvider...");
    await SessionStorageManager.init();
    print("🔑 Session storage initialized.");
    await initializeSessions();
    print("🔑 Sessions initialized.");
  }

  /// Initializes stored sessions on mount.
  ///
  /// This function retrieves all stored session keys, validates their expiration status,
  /// removes expired sessions, and schedules expiration timers for active ones.
  /// Additionally, it loads the last selected session if it is still valid,
  /// otherwise it clears the session and triggers the session expiration callback.
  Future<void> initializeSessions() async {
    // Reset current state
    _session = null;
    notifyListeners();

    try {
      createClient(
        config.apiBaseUrl,
      );
      // 1. Get all stored sessions
      final allSessions = await getAllSessions();
      if (allSessions == null || allSessions.isEmpty) {
        config.onSessionEmpty?.call();

        _initCompleter.complete();
        return;
      }

      // 2. Iterate over all sessions and clean up expired ones
      for (final sessionKey in List<String>.from(allSessions.keys)) {
        final session = allSessions[sessionKey];

        if (session == null) continue;

        if (!isValidSession(session)) {
          await clearSession(sessionKey: sessionKey);

          final activeKey = await getActiveSessionKey();
          if (sessionKey == activeKey) {
            _session = null;
          }

          allSessions.remove(sessionKey);
          continue;
        }

        await _scheduleSessionExpiration(sessionKey, session.expiry);
      }

      // 4. Load the active session key (if exists)
      final activeSessionKey = await getActiveSessionKey();
      if (activeSessionKey != null) {
        final activeSession = allSessions[activeSessionKey];
        if (activeSession != null) {
          // 5. Swap public key
          createClient(
            config.apiBaseUrl,
            publicKey: activeSession.publicKey,
          );
          _session = activeSession;

          await fetchUser(_client!,
              config.organizationId); // TODO (Amir): Store user if needed
          // await refreshWallets(); // TODO (Amir): Implement if needed

          config.onSessionSelected?.call(activeSession);
        }
      } else {
        // If no active session, fire the empty callback
        config.onSessionEmpty?.call();
      }

      // 6. Signal initialization complete
      _initCompleter
          .complete(); // TODO (Amir): I think this should be moved out of this function
      config.onInitialized?.call(null);
    } catch (e, st) {
      debugPrint("TurnkeyProvider failed to initialize sessions: $e\n$st");
      _initCompleter.completeError(e, st);
      config.onInitialized?.call(e);
    }
  }

  Future<void> setActiveSession({required String sessionKey}) async {
    print("🔑 Setting active session: $sessionKey");
    await SessionStorageManager.setActiveSessionKey(sessionKey);
    final session = await SessionStorageManager.getSession(sessionKey);
    print("🔑 Active session loaded: $session");
    if (session == null)
      throw Exception("No session found with key: $sessionKey");
    else {
      _session = session;
      print("🔑 calling callback: $_session");
      config.onSessionSelected?.call(session);
      createClient(
        config.apiBaseUrl,
        publicKey: session.publicKey,
      );
    }
  }

  Future<String?> getActiveSessionKey() async {
    return await SessionStorageManager.getActiveSessionKey();
  }

  Future<Session?> getSession({String? sessionKey}) async {
    final key = sessionKey ?? await SessionStorageManager.getActiveSessionKey();
    if (key == null) return null;
    return await SessionStorageManager.getSession(key);
  }

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

  Future<void> clearUnusedKeyPairs() async {
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

  Future<String> createApiKeyPair({
    String? externalPublicKey,
    String? externalPrivateKey,
    bool isCompressed = true,
    bool storeOverride = false,
  }) async {
    final publicKey = await SecureStorageStamper.createKeyPair(
      externalPublicKey: externalPublicKey,
      externalPrivateKey: externalPrivateKey,
      isCompressesd: isCompressed,
    );

    if (storeOverride) {
      // Swap the client to use this new key
      createClient(
        config.apiBaseUrl,
        publicKey: publicKey,
      );
    }

    return publicKey;
  }

  Future<void> deleteApiKeyPair(String publicKey) async {
    await SecureStorageStamper.deleteKeyPair(publicKey);
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
    if (_expiryTimers.isNotEmpty && _expiryTimers.containsKey(sessionKey)) {
      _expiryTimers[sessionKey]?.cancel();
      _expiryTimers.remove(sessionKey);
    }

    final expireSession = () async {
      final expiredSession = await getSession(sessionKey: sessionKey);

      if (expiredSession == null) return;

      await clearSession(sessionKey: sessionKey);

      config.onSessionExpired?.call(expiredSession);
    };

    final timeUntilExpiry =
        (expiry * 1000) - DateTime.now().millisecondsSinceEpoch;
    print(
        "🔑 Scheduling expiration for session $sessionKey in $timeUntilExpiry ms");

    if (timeUntilExpiry <= 0) {
      await expireSession();
    } else {
      _expiryTimers.putIfAbsent(sessionKey, () {
        return Timer(Duration(milliseconds: timeUntilExpiry), expireSession);
      });
    }
  }

  Future<Session> storeSession({
    required String sessionJwt,
    String? sessionKey,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;

    // 1. Enforce session limit
    final existingSessionKeys = await SessionStorageManager.listSessionKeys();
    if (existingSessionKeys.length >= MAX_SESSIONS) {
      throw Exception(
        'Maximum session limit of $MAX_SESSIONS reached. Please clear an existing session before creating a new one.',
      );
    }
    if (existingSessionKeys.contains(sessionKey)) {
      throw Exception(
        'Session key "$sessionKey" already exists. Please choose a unique session key or clear the existing session.',
      );
    }

    // 2. Store and parse session JWT
    await SessionStorageManager.storeSession(sessionJwt,
        sessionKey: sessionKey);
    final session = await SessionStorageManager.getSession(sessionKey);
    if (session == null) {
      throw Exception("Failed to store or parse session");
    }

    // 4. Fetch user information
    final user = await fetchUser(
        _client!, config.organizationId); // TODO (Amir): This does nothing atm
    if (user == null) {
      throw Exception("Failed to fetch user");
    }

    // 5. Schedule session expiration
    await _scheduleSessionExpiration(sessionKey, session.expiry);

    // 6. Mark as active if this is the first session
    final isFirstSession = existingSessionKeys.isEmpty;
    if (isFirstSession) {
      await setActiveSession(sessionKey: sessionKey);
    }

    await clearUnusedKeyPairs();

    // 7. Invoke callback
    config.onSessionCreated?.call(session);

    return session;
  }

  TurnkeyClient createClient(String apiBaseUrl, {String? publicKey}) {
    if (publicKey != null) secureStorageStamper.setPublicKey(publicKey);

    final newClient = TurnkeyClient(
      config: THttpConfig(baseUrl: apiBaseUrl),
      stamper: secureStorageStamper,
    );

    _client = newClient;
    return newClient;
  }

  Future<v1StampLoginResult?> refreshSession({
    String? sessionKey,
    int expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? publicKey,
    bool invalidateExisting = false,
  }) async {
    final key = sessionKey ?? await SessionStorageManager.getActiveSessionKey();
    if (key == null) throw Exception("No active session to refresh");

    final session = await SessionStorageManager.getSession(key);
    if (session == null) throw Exception("Session not found for key: $key");

    if (_client == null) throw Exception("HTTP client not initialized");

    // 1. Generate or use provided public key
    final newPublicKey =
        publicKey ?? await SecureStorageStamper.createKeyPair();

    // 2. Stamp login to refresh the session
    final response = await _client!.stampLogin(
      input: TStampLoginBody(
        organizationId: session.organizationId,
        publicKey: newPublicKey,
        expirationSeconds: expirationSeconds.toString(),
        invalidateExisting: invalidateExisting,
      ),
    );

    final result = response.activity.result.stampLoginResult;

    if (result?.session == null)
      throw Exception("No session found in refresh response");

    // 3. Store the new session JWT
    await SessionStorageManager.storeSession(
      result?.session as String,
      sessionKey: key,
    );

    return result;
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
    final key = sessionKey ?? StorageKeys.DefaultSession.value;

    final session = await SessionStorageManager.getSession(key);
    if (session == null) {
      throw Exception("No session found with key: $key");
    }

    // 1. Delete the keypair
    await SecureStorageStamper.deleteKeyPair(session.publicKey);

    // 2. Remove the session from storage
    await SessionStorageManager.clearSession(key);

    config.onSessionCleared?.call(session);
  }

  Future<void> clearAllSessions() async {
    final sessionKeys = await SessionStorageManager.listSessionKeys();
    if (sessionKeys.isEmpty) return;

    for (final key in sessionKeys) {
      await clearSession(sessionKey: key);
    }
  }

  // /// Refreshes the current user data.
  // ///
  // /// Fetches the latest user details from the API using the current session's client.
  // /// If the user data is successfully retrieved, updates the session with the new user details.
  // /// Saves the updated session and updates the state.
  // ///
  // /// Throws an [Exception] if the session or client is not initialized.
  // Future<void> refreshUser() async {
  //   if (_client == null || session == null) {
  //     throw Exception(
  //         "Failed to refresh user. Client or sessions not initialized");
  //   }

  //   final updatedUser = await fetchUser(_client!, config.organizationId);

  //   if (updatedUser != null) {
  //     final updatedSession = Session(
  //       key: session!.key,
  //       publicKey: session!.publicKey,
  //       privateKey: session!.privateKey,
  //       expiry: session!.expiry,
  //       user: updatedUser,
  //     );

  //     await saveSession(updatedSession, updatedSession.key);
  //     session = updatedSession;
  //   }
  // }

  // /// Updates the current user's information.
  // ///
  // /// Sends a request to update the user's email and/or phone number.
  // /// If the update is successful, refreshes the user data to reflect changes.
  // ///
  // /// Throws an [Exception] if the client or session is not initialized.
  // ///
  // /// [email] The new email address of the user.
  // /// [phone] The new phone number of the user.
  // Future<Activity> updateUser({String? email, String? phone}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }

  //   final parameters = UpdateUserIntent(
  //     userId: session!.user!.id,
  //     userTagIds: [],
  //     userPhoneNumber: phone?.trim().isNotEmpty == true ? phone : null,
  //     userEmail: email?.trim().isNotEmpty == true ? email : null,
  //   );

  //   final response = await _client!.updateUser(
  //     input: UpdateUserRequest(
  //       type: UpdateUserRequestType.activityTypeUpdateUser,
  //       timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //       organizationId: session!.user!.organizationId,
  //       parameters: parameters,
  //     ),
  //   );

  //   final activity = response.activity;
  //   if (activity.result.updateUserResult?.userId != null) {
  //     await refreshUser();
  //   }

  //   return activity;
  // }

  // /// Signs a raw payload using the specified signing key and encoding parameters.
  // ///
  // /// Throws an [Exception] if the client or user is not initialized.
  // ///
  // /// [signWith] The key to sign with.
  // /// [payload] The payload to sign.
  // /// [encoding] The encoding of the payload.
  // /// [hashFunction] The hash function to use.
  // Future<SignRawPayloadResult> signRawPayload(
  //     {required String signWith,
  //     required String payload,
  //     required PayloadEncoding encoding,
  //     required HashFunction hashFunction}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }

  //   final parameters = SignRawPayloadIntentV2(
  //     signWith: signWith,
  //     payload: payload,
  //     encoding: encoding,
  //     hashFunction: hashFunction,
  //   );

  //   final response = await _client!.signRawPayload(
  //       input: SignRawPayloadRequest(
  //           type: SignRawPayloadRequestType.activityTypeSignRawPayloadV2,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: parameters));

  //   final signRawPayloadResult = response.activity.result.signRawPayloadResult;
  //   if (signRawPayloadResult == null) {
  //     throw Exception("Failed to sign raw payload");
  //   }
  //   return signRawPayloadResult;
  // }

  // /// Signs a transaction using the specified signing key and transaction parameters.
  // ///
  // /// Throws an [Exception] if the client or user is not initialized.
  // ///
  // /// [signWith] The key to sign with.
  // /// [unsignedTransaction] The unsigned transaction to sign.
  // /// [type] The type of the transaction from the [TransactionType] enum.
  // Future<SignTransactionResult> signTransaction(
  //     {required String signWith,
  //     required String unsignedTransaction,
  //     required TransactionType type}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }

  //   final parameters = SignTransactionIntentV2(
  //       signWith: signWith,
  //       unsignedTransaction: unsignedTransaction,
  //       type: type);

  //   final response = await _client!.signTransaction(
  //       input: SignTransactionRequest(
  //           type: SignTransactionRequestType.activityTypeSignTransactionV2,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: parameters));

  //   final signTransactionResult =
  //       response.activity.result.signTransactionResult;
  //   if (signTransactionResult == null) {
  //     throw Exception("Failed to sign transaction");
  //   }
  //   return signTransactionResult;
  // }

  // /// Creates a new wallet with the specified name and accounts.
  // ///
  // /// Throws an [Exception] if the client or user is not initialized.
  // ///
  // /// [walletName] The name of the wallet.
  // /// [accounts] The accounts to create in the wallet.
  // /// [mnemonicLength] The length of the mnemonic.
  // Future<Activity> createWallet(
  //     {required String walletName,
  //     required List<WalletAccountParams> accounts,
  //     int? mnemonicLength}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }
  //   final parameters = CreateWalletIntent(
  //     accounts: accounts,
  //     walletName: walletName,
  //     mnemonicLength: mnemonicLength,
  //   );

  //   final response = await _client!.createWallet(
  //       input: CreateWalletRequest(
  //           type: CreateWalletRequestType.activityTypeCreateWallet,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: parameters));
  //   final activity = response.activity;
  //   if (activity.result.createWalletResult?.walletId != null) {
  //     await refreshUser();
  //   }

  //   return activity;
  // }

  // /// Imports a wallet using a provided mnemonic and creates accounts.
  // ///
  // /// Throws an [Exception] if the client or user is not initialized.
  // ///
  // /// [mnemonic] The mnemonic to import.
  // /// [walletName] The name of the wallet.
  // /// [accounts] The accounts to create in the wallet.
  // Future<void> importWallet(
  //     {required String mnemonic,
  //     required String walletName,
  //     required List<WalletAccountParams> accounts}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }
  //   final initResponse = await _client!.initImportWallet(
  //       input: InitImportWalletRequest(
  //           type: InitImportWalletRequestType.activityTypeInitImportWallet,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: InitImportWalletIntent(userId: session!.user!.id)));

  //   final importBundle =
  //       initResponse.activity.result.initImportWalletResult?.importBundle;

  //   if (importBundle == null) {
  //     throw Exception("Failed to get import bundle");
  //   }

  //   final encryptedBundle = await encryptWalletToBundle(
  //     mnemonic: mnemonic,
  //     importBundle: importBundle,
  //     userId: session!.user!.id,
  //     organizationId: session!.user!.organizationId,
  //   );

  //   final response = await _client!.importWallet(
  //       input: ImportWalletRequest(
  //           type: ImportWalletRequestType.activityTypeImportWallet,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: ImportWalletIntent(
  //               userId: session!.user!.id,
  //               walletName: walletName,
  //               encryptedBundle: encryptedBundle,
  //               accounts: accounts)));
  //   final activity = response.activity;
  //   if (activity.result.importWalletResult?.walletId != null) {
  //     await refreshUser();
  //   }
  // }

  // /// Exports an existing wallet by decrypting the stored mnemonic phrase.
  // ///
  // /// Throws an [Exception] if the client, user, or export bundle is not initialized.
  // ///
  // /// [walletId] The ID of the wallet to export.
  // Future<String> exportWallet({required String walletId}) async {
  //   if (_client == null || session == null || session!.user == null) {
  //     throw Exception("Client or user not initialized");
  //   }

  //   final targetPublicKey = await createEmbeddedKey();

  //   final response = await _client!.exportWallet(
  //       input: ExportWalletRequest(
  //           type: ExportWalletRequestType.activityTypeExportWallet,
  //           timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
  //           organizationId: session!.user!.organizationId,
  //           parameters: ExportWalletIntent(
  //               walletId: walletId, targetPublicKey: targetPublicKey)));
  //   final exportBundle =
  //       response.activity.result.exportWalletResult?.exportBundle;

  //   final embeddedKey = await getEmbeddedKey();
  //   if (exportBundle == null || embeddedKey == null) {
  //     throw Exception("Export bundle, embedded key, or user not initialized");
  //   }

  //   return await decryptExportBundle(
  //       exportBundle: exportBundle,
  //       embeddedKey: embeddedKey,
  //       organizationId: session!.user!.organizationId,
  //       returnMnemonic: true);
  // }

  /// Handles the Google OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] The client ID for Google OAuth.
  /// [nonce] A random nonce for the OAuth flow.
  /// [scheme] The app's custom URL scheme.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to TURNKEY_OAUTH_ORIGIN_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow. Defaults to a constructed URI with the provided scheme.
  /// [onSuccess] Callback function that receives the oidcToken upon successful authentication.
  Future<void> handleGoogleOAuth({
    required String clientId,
    required String nonce,
    required String scheme,
    String? originUri = TURNKEY_OAUTH_ORIGIN_URL,
    String? redirectUri,
    required void Function(String oidcToken) onSuccess,
  }) async {
    final AppLinks appLinks = AppLinks();

    redirectUri ??=
        '${TURNKEY_OAUTH_REDIRECT_URL}?scheme=${Uri.encodeComponent(scheme)}';

    final oauthUrl = originUri! +
        '?provider=google' +
        '&clientId=${Uri.encodeComponent(clientId)}' +
        '&redirectUri=${Uri.encodeComponent(redirectUri)}' +
        '&nonce=${Uri.encodeComponent(nonce)}';

    // Create a completer to wait for the authentication result
    final Completer<void> authCompleter = Completer<void>();

    // Set up a subscription for deep links
    StreamSubscription? subscription;
    subscription = appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null && uri.toString().startsWith(scheme)) {
        // Parse query parameters from the URI
        final idToken = uri.queryParameters['id_token'];

        if (idToken != null) {
          onSuccess(idToken);

          // Complete the auth process. Runs the whenComplete callback
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

      // Set a timeout for the authentication process
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
      throw Exception('Google OAuth failed: $e');
    }
  }
}

// We create a custom browser class to handle the onClosed event
class _OAuthBrowser extends ChromeSafariBrowser {
  final VoidCallback onBrowserClosed;

  _OAuthBrowser({required this.onBrowserClosed});

  @override
  void onClosed() {
    onBrowserClosed();
    super.onClosed();
  }
}
