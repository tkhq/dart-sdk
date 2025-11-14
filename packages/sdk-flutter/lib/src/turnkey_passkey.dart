part of 'turnkey.dart';

extension PasskeyExtension on TurnkeyProvider {
  
  /// Logs in a user using a passkey.
  ///
  /// Generates or uses an existing API key pair for authentication.
  /// Stamps a login session with the provided relying party ID and optional parameters.
  /// Stores the session JWT and manages session state.
  /// Cleans up the generated key pair if it was not used for the session.
  ///
  /// [rpId] An optional relying party ID for the passkey stamping.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [expirationSeconds] The desired expiration time for the session in seconds.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [publicKey] An optional public key to use for the session. If null, a new key pair is generated.
  /// Returns a [LoginWithPasskeyResult] containing the session token if successful.
  /// Throws an [Exception] if the login process fails.
  Future<LoginWithPasskeyResult> loginWithPasskey({
    String? rpId,
    String? sessionKey,
    String? expirationSeconds,
    String? organizationId,
    String? publicKey,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    rpId ??= runtimeConfig?.passkeyConfig?.rpId;
    expirationSeconds ??= runtimeConfig?.authConfig.sessionExpirationSeconds;

    final apiBaseUrl = runtimeConfig?.apiBaseUrl;

    String? generatedPublicKey;

    try {
      if (rpId == null || rpId.isEmpty) {
        throw Exception(
            "Relying Party ID (rpId) must be provided either in the method call or in the TurnkeyConfig.passkeyConfig");
      }

      generatedPublicKey =
          publicKey ?? await createApiKeyPair(storeOverride: true);

      final passkeyClient = createPasskeyClient(
          organizationId: organizationId,
          apiBaseUrl: apiBaseUrl,
          passkeyStamperConfig: PasskeyStamperConfig(rpId: rpId));

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
  /// [rpId] An optional relying party ID for the passkey registration.
  /// [rpName] An optional relying party name for the passkey registration.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [expirationSeconds] The desired expiration time for the session in seconds.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [passkeyDisplayName] An optional display name for the passkey.
  /// [challenge] An optional challenge string for the passkey registration.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user.
  /// [invalidateExisting] Whether to invalidate existing sessions when signing up.
  /// Returns a [SignUpWithPasskeyResult] containing the session token and credential ID if successful.
  /// Throws an [Exception] if the sign-up process fails.
  Future<SignUpWithPasskeyResult> signUpWithPasskey({
    String? rpId,
    String? rpName,
    String? sessionKey,
    String? expirationSeconds,
    String? organizationId,
    String? passkeyDisplayName,
    String? challenge,
    CreateSubOrgParams? createSubOrgParams,
    bool invalidateExisting = false,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    rpId ??= runtimeConfig?.passkeyConfig?.rpId;
    rpName ??= runtimeConfig?.passkeyConfig?.rpName ?? "Flutter App";
    expirationSeconds ??= runtimeConfig?.authConfig.sessionExpirationSeconds;

    String? generatedPublicKey;
    String? temporaryPublicKey;

    try {
      // for one-tap passkey sign-up, we generate a temporary API key pair
      // which is added as an authentication method for the new sub-org user
      // this allows us to stamp the session creation request immediately after
      // without prompting the user

      if (rpId == null || rpId.isEmpty) {
        throw Exception(
            "Relying Party ID (rpId) must be provided either in the method call or in the TurnkeyConfig.passkeyConfig");
      }

      temporaryPublicKey = await createApiKeyPair(storeOverride: true);
      final passkeyName = passkeyDisplayName ??
          'passkey-${DateTime.now().millisecondsSinceEpoch}';

      // create a passkey
      final passkey = await createPasskey(
        PasskeyRegistrationConfig(
          rp: RelyingParty(
            id: rpId,
            name: rpName,
          ),
          user: WebAuthnUser(
            id: const Uuid()
                .v4(), // WARNING: WebAuthnUser id must be a valid UUIDv4 on some devices
            name: passkeyName,
            displayName: passkeyName,
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
}