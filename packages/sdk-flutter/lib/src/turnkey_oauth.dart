part of 'turnkey.dart';

extension OAuthExtension on TurnkeyProvider {
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
  /// [sessionKey] Optional session key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Optional flag to invalidate existing sessions when logging in or signing up.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback function that receives the oidcToken, publicKey and providerName upon successful authentication, overrides default behavior.
  Future<void> handleGoogleOAuth({
    String? clientId,
    String? originUri = TURNKEY_OAUTH_ORIGIN_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    String? publicKey,
    void Function(
            {required String oidcToken,
            required String publicKey,
            required String providerName})?
        onSuccess,
  }) async {
    final scheme = runtimeConfig?.appScheme;
    final providerName = 'google';
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = publicKey ?? await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final googleClientId = clientId ??
          runtimeConfig?.authConfig.oAuthConfig?.googleClientId ??
          (throw Exception("Google Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          runtimeConfig?.authConfig.oAuthConfig?.oauthRedirectUri ??
          '${TURNKEY_OAUTH_REDIRECT_URL}?scheme=${Uri.encodeComponent(scheme)}';

      final oauthUrl = originUri! +
          '?provider=${Uri.encodeComponent(providerName)}' +
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
              onSuccess(
                  oidcToken: idToken,
                  publicKey: targetPublicKey,
                  providerName: providerName);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: idToken,
                publicKey: targetPublicKey,
                providerName: providerName,
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

  /// Handles the Apple OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes `loginOrSignUpWithOAuth` or the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional client ID that overrides the default client ID passed into the config or pulled from the Wallet Kit dashboard for Apple OAuth.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to TURNKEY_OAUTH_ORIGIN_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow. Defaults to a constructed URI with the provided scheme.
  /// [sessionKey] Optional session key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Optional flag to invalidate existing sessions when logging in or signing up.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback function that receives the oidcToken, publicKey and providerName upon successful authentication, overrides default behavior.
  Future<void> handleAppleOAuth({
    String? clientId,
    String? originUri = TURNKEY_OAUTH_ORIGIN_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    String? publicKey,
    void Function(
            {required String oidcToken,
            required String publicKey,
            required String providerName})?
        onSuccess,
  }) async {
    final scheme = runtimeConfig?.appScheme;
    final providerName = 'apple';
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = publicKey ?? await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final appleClientId = clientId ??
          runtimeConfig?.authConfig.oAuthConfig?.appleClientId ??
          (throw Exception("Apple Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          runtimeConfig?.authConfig.oAuthConfig?.oauthRedirectUri ??
          '${TURNKEY_OAUTH_REDIRECT_URL}?scheme=${Uri.encodeComponent(scheme)}';

      final oauthUrl = originUri! +
          '?provider=${Uri.encodeComponent(providerName)}' +
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
              onSuccess(
                  oidcToken: idToken,
                  publicKey: targetPublicKey,
                  providerName: providerName);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: idToken,
                publicKey: targetPublicKey,
                providerName: providerName,
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
  /// [sessionKey] Optional session key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Optional flag to invalidate existing sessions when logging in or signing up.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback function that receives the oidcToken, publicKey and providerName upon successful authentication, overrides default behavior.
  Future<void> handleXOAuth({
    String? clientId,
    String? originUri = X_AUTH_URL,
    String? redirectUri,
    String? sessionKey,
    bool? invalidateExisting,
    String? publicKey,
    void Function(
            {required String oidcToken,
            required String publicKey,
            required String providerName})?
        onSuccess,
  }) async {
    final scheme = runtimeConfig?.appScheme;
    final providerName = 'x';
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = publicKey ?? await createApiKeyPair();

    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final xClientId = clientId ??
          runtimeConfig?.authConfig.oAuthConfig?.xClientId ??
          (throw Exception("X Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          runtimeConfig?.authConfig.oAuthConfig?.oauthRedirectUri ??
          '${runtimeConfig?.appScheme}://';

      final challengePair = await generateChallengePair();
      final verifier = challengePair.verifier;
      final codeChallenge = challengePair.codeChallenge;

      // random state
      final state = Uuid().v4();

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

          if (uri.queryParameters['state'] != state) {
            subscription?.cancel();
            throw Exception('Invalid state parameter received');
          }

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
              onSuccess(
                  oidcToken: oidcToken,
                  publicKey: targetPublicKey,
                  providerName: providerName);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: oidcToken,
                publicKey: targetPublicKey,
                providerName: providerName,
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
  /// [sessionKey] Optional session key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Optional flag to invalidate existing sessions when logging in or signing up.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback function that receives the oidcToken, publicKey and providerName upon successful authentication, overrides default behavior.
  Future<void> handleDiscordOAuth({
    String? clientId,
    String? originUri = DISCORD_AUTH_URL,
    String? redirectUri,
    String? sessionKey,
    String? invalidateExisting,
    String? publicKey,
    void Function(
            {required String oidcToken,
            required String publicKey,
            required String providerName})?
        onSuccess,
  }) async {
    final scheme = runtimeConfig?.appScheme;
    final providerName = 'discord';
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = publicKey ?? await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final discordClientId = clientId ??
          runtimeConfig?.authConfig.oAuthConfig?.discordClientId ??
          (throw Exception("Discord Client ID not configured"));
      final resolvedRedirectUri = redirectUri ??
          runtimeConfig?.authConfig.oAuthConfig?.oauthRedirectUri ??
          '${scheme}://';

      final challengePair = await generateChallengePair();
      final verifier = challengePair.verifier;
      final codeChallenge = challengePair.codeChallenge;

      // random state
      final state = Uuid().v4();

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

          if (uri.queryParameters['state'] != state) {
            subscription?.cancel();
            throw Exception('Invalid state parameter received');
          }

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
              onSuccess(
                  oidcToken: oidcToken,
                  publicKey: targetPublicKey,
                  providerName: providerName);
            } else {
              await loginOrSignUpWithOAuth(
                oidcToken: oidcToken,
                publicKey: targetPublicKey,
                providerName: providerName,
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