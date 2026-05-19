part of 'turnkey.dart';

extension OAuthExtension on TurnkeyProvider {
  /// Builds a CreateSubOrgParams populated with secondary OAuth provider
  /// entries derived from the primary OIDC token. Returns null when there
  /// are no secondaries to register, so callers can pass it straight
  /// through (null means "use default sub-org params").
  CreateSubOrgParams? _buildOAuthCreateSubOrgParams({
    required String oidcToken,
    required String providerName,
    required List<String> secondaryClientIds,
  }) {
    final secondaries = buildSecondaryOAuthProviders(
      oidcToken: oidcToken,
      providerName: providerName,
      secondaryClientIds: secondaryClientIds,
    );
    if (secondaries.isEmpty) return null;

    final base = runtimeConfig?.authConfig.createSubOrgParams?.oAuth ??
        const CreateSubOrgParams();
    final existing = base.oauthProviders ?? const <v1OauthProviderParamsV2>[];
    return base.copyWith(oauthProviders: [...existing, ...secondaries]);
  }

  /// Handles the Google OAuth authentication flow.
  ///
  /// Initiates an in-app browser OAuth flow with the provided credentials and parameters.
  /// After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL
  /// and invokes `loginOrSignUpWithOAuth` or the provided onSuccess callback.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional Google web client ID override. Falls back to config values if not provided.
  /// [secondaryClientIds] Optional list of additional Google client IDs to register as
  /// secondary authenticators on sub-org creation. Per-call override; falls back to config values if not provided.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to TURNKEY_OAUTH_ORIGIN_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow.
  /// [sessionKey] Optional session key to store the session under. If null, uses the default session key.
  /// [invalidateExisting] Optional flag to invalidate existing sessions when logging in or signing up.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback function that receives the oidcToken, publicKey and providerName upon successful authentication, overrides default behavior.
  Future<void> handleGoogleOAuth({
    String? clientId,
    List<String>? secondaryClientIds,
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
      final googleProvider =
          runtimeConfig?.authConfig.oAuthConfig?.providers?.google;
      final googleClientId = clientId ??
          googleProvider?.primaryClientId?.webClientId ??
          (throw Exception("Missing webClientId for Google OAuth"));
      final resolvedRedirectUri = redirectUri ??
          googleProvider?.redirectUri ??
          (throw Exception("Missing redirectUri for Google OAuth"));
      final resolvedSecondaryClientIds = secondaryClientIds ??
          googleProvider?.secondaryClientIds ??
          const <String>[];

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
                createSubOrgParams: _buildOAuthCreateSubOrgParams(
                  oidcToken: idToken,
                  providerName: providerName,
                  secondaryClientIds: resolvedSecondaryClientIds,
                ),
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

  /// Handles native Apple Sign-In via [sign_in_with_apple].
  ///
  /// On iOS, this triggers the native Apple Sign-In sheet
  /// (`ASAuthorizationAppleIDProvider`). On Android (and other platforms
  /// without native Apple Sign-In support), the underlying package falls
  /// back to a web-based flow using the configured Services ID.
  ///
  /// To ensure cross-platform login works (a user signing up on one
  /// platform should be able to log in on another), this method registers
  /// both `serviceId` and `iosBundleId` as audiences on the new sub-org —
  /// whichever of the two isn't the token's primary `aud` gets added as a
  /// secondary.
  ///
  /// Throws an [Exception] if Apple Sign-In fails or required config is missing.
  ///
  /// [secondaryClientIds] Optional list of additional Apple client IDs to
  /// register as secondary authenticators on sub-org creation.
  /// [sessionKey] Optional session key to store the session under.
  /// [invalidateExisting] Optional flag to invalidate existing sessions.
  /// [publicKey] Optional public key to use for the session. If null, a new key pair is generated.
  /// [onSuccess] Optional callback invoked on successful authentication; bypasses internal login/signup flow.
  Future<void> handleAppleOAuth({
    List<String>? secondaryClientIds,
    String? sessionKey,
    bool? invalidateExisting,
    String? publicKey,
    void Function(
            {required String oidcToken,
            required String publicKey,
            required String providerName})?
        onSuccess,
  }) async {
    final providerName = 'apple';
    final appleProvider =
        runtimeConfig?.authConfig.oAuthConfig?.providers?.apple;
    final serviceId = appleProvider?.primaryClientId?.serviceId;
    final iosBundleId = appleProvider?.primaryClientId?.iosBundleId;
    final resolvedSecondaryClientIds = secondaryClientIds ??
        appleProvider?.secondaryClientIds ??
        const <String>[];

    // Android uses the web fallback inside sign_in_with_apple, which
    // requires a Services ID to function. Fail early with a clear message
    // rather than letting the underlying package raise an opaque error.
    if (Platform.isAndroid && (serviceId == null || serviceId.isEmpty)) {
      throw Exception("Missing serviceId for Apple OAuth on Android. Configure "
          "AppleOAuthProviderParams.primaryClientId.serviceId to use "
          "handleAppleOAuth on Android.");
    }

    final targetPublicKey = publicKey ?? await createApiKeyPair();

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: sha256.convert(utf8.encode(targetPublicKey)).toString(),
        // On Android, sign_in_with_apple requires webAuthenticationOptions
        // configured with the Services ID. We pass them so Android users
        // get a working web fallback.
        webAuthenticationOptions:
            (Platform.isAndroid && serviceId != null && serviceId.isNotEmpty)
                ? WebAuthenticationOptions(
                    clientId: serviceId,
                    redirectUri: Uri.parse(appleProvider?.redirectUri ?? ''),
                  )
                : null,
      );

      final oidcToken = credential.identityToken;
      if (oidcToken == null) {
        throw Exception('Apple Sign-In returned no identity token');
      }

      if (onSuccess != null) {
        onSuccess(
            oidcToken: oidcToken,
            publicKey: targetPublicKey,
            providerName: providerName);
        return;
      }

      // Determine which audience is in the token, and register the other
      // as a secondary so both end up on the sub-org.
      final tokenAud = decodeJwtPayload(oidcToken)?['aud'] as String?;
      final crossPlatformSecondaries = <String>{
        if (serviceId != null && serviceId.isNotEmpty && serviceId != tokenAud)
          serviceId,
        if (iosBundleId != null &&
            iosBundleId.isNotEmpty &&
            iosBundleId != tokenAud)
          iosBundleId,
        ...resolvedSecondaryClientIds,
      }.toList();

      await loginOrSignUpWithOAuth(
        oidcToken: oidcToken,
        publicKey: targetPublicKey,
        providerName: providerName,
        sessionKey: sessionKey,
        invalidateExisting: invalidateExisting,
        createSubOrgParams: _buildOAuthCreateSubOrgParams(
          oidcToken: oidcToken,
          providerName: providerName,
          secondaryClientIds: crossPlatformSecondaries,
        ),
      );
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login or signup with Apple: $error');
    }
  }

  /// Handles the Apple OAuth authentication flow via the system web browser.
  ///
  /// This is the web-based fallback that does NOT use native Apple Sign-In.
  /// Most consumers should use [handleAppleOAuth] (native) instead. This
  /// method remains available for cases where the web flow is explicitly
  /// preferred or required.
  ///
  /// Initiates an in-app browser OAuth flow, extracts the oidcToken from
  /// the callback URL, and invokes `loginOrSignUpWithOAuth` or the provided
  /// onSuccess callback. Auto-prepends the iOS bundle ID (if configured) to
  /// `secondaryClientIds` so that users who sign up via this flow can later
  /// log in on iOS through native Apple Sign-In.
  ///
  /// Throws an [Exception] if the authentication process fails or times out.
  ///
  /// [clientId] Optional Apple Services ID override. Falls back to runtimeConfig.
  /// [secondaryClientIds] Optional list of additional Apple client IDs to register.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to TURNKEY_OAUTH_ORIGIN_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow.
  /// [sessionKey] Optional session key to store the session under.
  /// [invalidateExisting] Optional flag to invalidate existing sessions.
  /// [publicKey] Optional public key to use for the session.
  /// [onSuccess] Optional callback invoked on successful authentication.
  Future<void> handleAppleWebOAuth({
    String? clientId,
    List<String>? secondaryClientIds,
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
      final appleProvider =
          runtimeConfig?.authConfig.oAuthConfig?.providers?.apple;
      final appleClientId = clientId ??
          appleProvider?.primaryClientId?.serviceId ??
          (throw Exception("Missing serviceId for Apple OAuth"));
      final resolvedRedirectUri = redirectUri ??
          appleProvider?.redirectUri ??
          (throw Exception("Missing redirectUri for Apple OAuth"));
      final resolvedSecondaryClientIds = secondaryClientIds ??
          appleProvider?.secondaryClientIds ??
          const <String>[];

      // The web flow's primary audience is the Services ID. Prepend the iOS
      // bundle ID (if configured) as a secondary so a user signing up via
      // the web flow can later log in via native Apple Sign-In on iOS.
      final iosBundleId = appleProvider?.primaryClientId?.iosBundleId;
      final allSecondaryClientIds = <String>[
        if (iosBundleId != null && iosBundleId.isNotEmpty) iosBundleId,
        ...resolvedSecondaryClientIds,
      ];

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
                createSubOrgParams: _buildOAuthCreateSubOrgParams(
                  oidcToken: idToken,
                  providerName: providerName,
                  secondaryClientIds: allSecondaryClientIds,
                ),
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
  /// [clientId] Optional X client ID override. Falls back to
  /// `runtimeConfig.authConfig.oAuthConfig.providers.x.primaryClientId`.
  /// [secondaryClientIds] Optional list of additional X client IDs to register as
  /// secondary authenticators on sub-org creation.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to X_AUTH_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow.
  /// [sessionKey] Optional session key to store the session under.
  /// [invalidateExisting] Optional flag to invalidate existing sessions.
  /// [publicKey] Optional public key to use for the session.
  /// [onSuccess] Optional callback invoked on successful authentication.
  Future<void> handleXOAuth({
    String? clientId,
    List<String>? secondaryClientIds,
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
      final xProvider = runtimeConfig?.authConfig.oAuthConfig?.providers?.x;
      final xClientId = clientId ??
          xProvider?.primaryClientId ??
          (throw Exception("Missing primaryClientId for X OAuth"));
      final resolvedRedirectUri = redirectUri ??
          xProvider?.redirectUri ??
          (throw Exception("Missing redirectUri for X OAuth"));
      final resolvedSecondaryClientIds = secondaryClientIds ??
          xProvider?.secondaryClientIds ??
          const <String>[];

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
                createSubOrgParams: _buildOAuthCreateSubOrgParams(
                  oidcToken: oidcToken,
                  providerName: providerName,
                  secondaryClientIds: resolvedSecondaryClientIds,
                ),
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
  /// [clientId] Optional Discord client ID override. Falls back to
  /// `runtimeConfig.authConfig.oAuthConfig.providers.discord.primaryClientId`.
  /// [secondaryClientIds] Optional list of additional Discord client IDs to register as
  /// secondary authenticators on sub-org creation.
  /// [originUri] Optional base URI to start the OAuth flow. Defaults to DISCORD_AUTH_URL.
  /// [redirectUri] Optional redirect URI for the OAuth flow.
  /// [sessionKey] Optional session key to store the session under.
  /// [invalidateExisting] Optional flag to invalidate existing sessions.
  /// [publicKey] Optional public key to use for the session.
  /// [onSuccess] Optional callback invoked on successful authentication.
  Future<void> handleDiscordOAuth({
    String? clientId,
    List<String>? secondaryClientIds,
    String? originUri = DISCORD_AUTH_URL,
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
    final providerName = 'discord';
    if (scheme == null) {
      throw Exception(
          "App scheme is not configured. Please set `appScheme` in TurnkeyConfig.");
    }

    final AppLinks appLinks = AppLinks();

    final targetPublicKey = publicKey ?? await createApiKeyPair();
    try {
      final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();
      final discordProvider =
          runtimeConfig?.authConfig.oAuthConfig?.providers?.discord;
      final discordClientId = clientId ??
          discordProvider?.primaryClientId ??
          (throw Exception("Missing primaryClientId for Discord OAuth"));
      final resolvedRedirectUri = redirectUri ??
          discordProvider?.redirectUri ??
          (throw Exception("Missing redirectUri for Discord OAuth"));
      final resolvedSecondaryClientIds = secondaryClientIds ??
          discordProvider?.secondaryClientIds ??
          const <String>[];

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
                sessionKey: sessionKey,
                invalidateExisting: invalidateExisting,
                createSubOrgParams: _buildOAuthCreateSubOrgParams(
                  oidcToken: oidcToken,
                  providerName: providerName,
                  secondaryClientIds: resolvedSecondaryClientIds,
                ),
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
