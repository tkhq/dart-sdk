import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_http/base.dart';
import 'package:turnkey_http/turnkey_http.dart';
import 'package:turnkey_sdk_flutter/src/internal/turnkey_helpers.dart';
import 'package:turnkey_sdk_flutter/src/utils/constants.dart';
import 'package:turnkey_sdk_flutter/src/utils/types.dart';
import 'package:uuid/uuid.dart';

import 'package:turnkey_sdk_flutter/src/internal/stamper.dart';
import 'package:turnkey_sdk_flutter/src/internal/storage.dart';
import 'package:crypto/crypto.dart';

part 'turnkey_auth_proxy.dart';
part 'turnkey_delegated_access.dart';
part 'turnkey_oauth.dart';
part 'turnkey_passkey.dart';
part 'turnkey_session.dart';
part 'turnkey_signing.dart';
part 'turnkey_user.dart';
part 'turnkey_wallet.dart';

class TurnkeyProvider with ChangeNotifier {
  // these are external
  Session? _session;
  TurnkeyClient? _client;
  v1User? _user;
  List<Wallet>? _wallets;
  AuthState _authState = AuthState.loading;

  // these are internal
  TurnkeyRuntimeConfig? _runtimeConfig;

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
  AuthState get authState => _authState;
  TurnkeyClient? get client => _client;
  v1User? get user => _user;
  List<Wallet>? get wallets => _wallets;

  // these are internally used
  TurnkeyRuntimeConfig? get runtimeConfig => _runtimeConfig;

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

  set authState(AuthState next) {
    if (_authState == next) return;
    _authState = next;
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

  TurnkeyRuntimeConfig _buildConfig({
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
    final sessionExpirationSeconds =
        proxyAuthConfig?.sessionExpirationSeconds  ??
        AUTH_DEFAULT_EXPIRATION_SECONDS;

    final otpAlphanumeric = proxyAuthConfig?.otpAlphanumeric;

    final otpLength = proxyAuthConfig?.otpLength;

    final resolvedAuth = RuntimeAuthConfig(
      methods: resolvedMethods,
      oAuthConfig: resolvedOAuth,
      sessionExpirationSeconds: sessionExpirationSeconds,
      otpAlphanumeric: otpAlphanumeric,
      otpLength: otpLength,
      autoFetchWalletKitConfig:
          config.authConfig?.autoFetchWalletKitConfig ?? true,
      autoRefreshManagedState:
          config.authConfig?.autoRefreshManagedState ?? true,
    );

    // Note: it's not always possible to use runtimeConfig to get base urls. You'll notice in functions like createClient, we do this logic again. runtimeConfig is only available after boot so it's not safe to use it there.
    final resolvedApiBaseUrl = config.apiBaseUrl ?? "https://api.turnkey.com";
    final resolvedAuthProxyBaseUrl =
        config.authProxyBaseUrl ?? "https://authproxy.turnkey.com";

    return TurnkeyRuntimeConfig(
      apiBaseUrl: resolvedApiBaseUrl,
      organizationId: config.organizationId,
      appScheme: config.appScheme,
      authConfig: resolvedAuth,
      passkeyConfig: config.passkeyConfig,
      authProxyBaseUrl: resolvedAuthProxyBaseUrl,
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
      authState = AuthState.loading;
      ProxyTGetWalletKitConfigResponse? proxy;
      if ((config.authProxyConfigId ?? '').isNotEmpty &&
          config.authConfig?.autoFetchWalletKitConfig == true) {
        proxy = await _getAuthProxyConfig(
          config.authProxyConfigId!,
          config.authProxyBaseUrl,
        );
        notifyListeners();
      }

      // we build the runtime config from Authproxy (can be null)
      _runtimeConfig = _buildConfig(proxyAuthConfig: proxy);
      notifyListeners();
    } catch (e) {
      stderr.writeln("TurnkeyProvider boot failed: $e");
    }
  }

  Future<ProxyTGetWalletKitConfigResponse?> _getAuthProxyConfig(
      String configId, String? baseUrl) async {
    if (client == null) {
      createClient(
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
  /// [publicKey] The public key to use for stamping. A key pair with this public key must exist in secure storage before passing it here. You can ensure the key pair exists using the createApiKeyPair method. If null, the existing public key in the stamper will be used.
  /// [apiBaseUrl] The base URL for the Turnkey API. If null, the value from the config or the default URL will be used.
  /// [authProxyConfigId] The configuration ID for the auth proxy. If null, the value from the config will be used.
  /// [authProxyBaseUrl] The base URL for the auth proxy. If null, the value from the config or the default URL will be used.
  /// [overrideExisting] Whether to override the existing client instance with the newly created one. Defaults to true.
  /// Returns the newly created TurnkeyClient instance.
  TurnkeyClient createClient(
      {String? organizationId,
      String? publicKey,
      String? apiBaseUrl,
      String? authProxyConfigId,
      String? authProxyBaseUrl,
      bool? overrideExisting = true}) {
    if (publicKey != null) secureStorageStamper.setPublicKey(publicKey);
    apiBaseUrl ??= runtimeConfig?.apiBaseUrl ?? "https://api.turnkey.com";
    authProxyBaseUrl ??=
        runtimeConfig?.authProxyBaseUrl ?? "https://authproxy.turnkey.com";
    authProxyConfigId ??= runtimeConfig?.authProxyConfigId;
    organizationId ??= runtimeConfig?.organizationId;

    final newClient = TurnkeyClient(
      config: THttpConfig(
        organizationId: organizationId,
        baseUrl: apiBaseUrl,
        authProxyConfigId: authProxyConfigId,
        authProxyBaseUrl: authProxyBaseUrl,
      ),
      stamper: secureStorageStamper,
    );

    if (overrideExisting == true) client = newClient;

    return newClient;
  }

  /// Creates a TurnkeyClient configured for Passkey stamping.
  /// [organizationId] The ID of the organization to which the client will be associated. If null, the value from the config will be used.
  /// [apiBaseUrl] The base URL for the Turnkey API. If null, the value from the config or the default URL will be used.
  /// [authProxyConfigId] The configuration ID for the auth proxy. If null, the value from the config will be used.
  /// [authProxyBaseUrl] The base URL for the auth proxy. If null, the value from the config or the default URL will be used.
  /// [rpId] The Relying Party ID to use for Passkey authentication. If null, the value from the config's PasskeyStamperConfig will be used.
  /// [overrideExisting] Whether to override the existing client instance with the newly created one. If true, all helper functions within the TurnkeyProvider will be using this client and thus, will be stamping using a passkey. Defaults to false.
  /// Returns the newly created TurnkeyClient instance configured for Passkey stamping.
  TurnkeyClient createPasskeyClient(
      {String? organizationId,
      String? apiBaseUrl,
      String? authProxyConfigId,
      String? authProxyBaseUrl,
      PasskeyStamperConfig? passkeyStamperConfig,
      bool? overrideExisting = false}) {
    final rpId = passkeyStamperConfig?.rpId ?? runtimeConfig?.passkeyConfig?.rpId;
    if (rpId == null || rpId.isEmpty) {
      throw Exception(
        'Relying Party ID (rpId) must be provided either in the passkeyStamperConfig parameter or in the TurnkeyConfig.passkeyConfig property.',
      );
    }

    apiBaseUrl ??= runtimeConfig?.apiBaseUrl ?? "https://api.turnkey.com";
    authProxyBaseUrl ??=
        runtimeConfig?.authProxyBaseUrl ?? "https://authproxy.turnkey.com";
    authProxyConfigId ??= runtimeConfig?.authProxyConfigId;
    organizationId ??= runtimeConfig?.organizationId;

    final passkeyStamper = PasskeyStamper(
      passkeyStamperConfig != null
          ? PasskeyStamperConfig(
              rpId: rpId,
              timeout: passkeyStamperConfig.timeout,
              userVerification: passkeyStamperConfig.userVerification,
              allowCredentials: passkeyStamperConfig.allowCredentials,
              mediation: passkeyStamperConfig.mediation,
              preferImmediatelyAvailableCredentials:
                  passkeyStamperConfig.preferImmediatelyAvailableCredentials,
            )
          : PasskeyStamperConfig(rpId: rpId),
    );

    final passkeyClient = TurnkeyClient(
        config: THttpConfig(
          organizationId: organizationId,
          baseUrl: apiBaseUrl,
          authProxyConfigId: authProxyConfigId,
          authProxyBaseUrl: authProxyBaseUrl,
        ),
        stamper: passkeyStamper);

    if (overrideExisting == true) client = passkeyClient;

    return passkeyClient;
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
      createClient();

      // we get all stored sessions
      final allSessions = await getAllSessions();
      if (allSessions == null || allSessions.isEmpty) {
        runtimeConfig?.onSessionEmpty?.call();
        authState = AuthState.unauthenticated;

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
          createClient(
            publicKey: activeSession.publicKey,
            organizationId: activeSession.organizationId,
          );
          session = activeSession;

          // We have a valid session + client: mark authenticated before fetching user/wallets.
          authState = AuthState.authenticated;

          await refreshUser();
          await refreshWallets();

          runtimeConfig?.onSessionSelected?.call(activeSession);
        }
      } else {
        // if no active session, fire the empty callback
        runtimeConfig?.onSessionEmpty?.call();
        authState = AuthState.unauthenticated;
      }

      // we signal initialization complete
      _initCompleter.complete();
      runtimeConfig?.onInitialized?.call(null);
    } catch (e, st) {
      stderr.writeln("TurnkeyProvider failed to initialize sessions: $e\n$st");
      authState = AuthState.unauthenticated;
      _initCompleter.completeError(e, st);
      runtimeConfig?.onInitialized?.call(e);
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
      createClient(
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
}
