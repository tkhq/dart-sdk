part of 'turnkey.dart';

extension AuthProxyExtension on TurnkeyProvider {
  /// Initializes the OTP process by sending an OTP code to the provided contact.
  ///
  /// This function initiates the OTP flow by sending a one-time password (OTP) code to the user's
  /// contact information (email address or phone number) via the auth proxy.
  /// Supports both email and SMS OTP types.
  /// Returns an OTP ID and an encryption target bundle required for subsequent OTP verification.
  /// The [otpEncryptionTargetBundle] must be used to encrypt the OTP code and a client-generated
  /// public key before calling [verifyOtp].
  ///
  /// [otpType] The type of OTP to initialize (email or SMS).
  /// [contact] The contact information (email address or phone number) to send the OTP to.
  /// Returns an [InitOtpResult] containing the OTP ID and encryption target bundle.
  /// Throws an [Exception] if the OTP initialization fails or if required fields are missing.
  Future<InitOtpResult> initOtp(
      {required OtpType otpType, required String contact}) async {
    final res = await requireClient.proxyInitOtpV2(
        input: ProxyTInitOtpV2Body(
      contact: contact,
      otpType: otpType.value,
    ));

    if (res.otpId.isEmpty || res.otpEncryptionTargetBundle.isEmpty) {
      throw Exception(
          'Failed to initialize OTP: otpId or otpEncryptionTargetBundle is missing');
    }

    return InitOtpResult(
      otpId: res.otpId,
      otpEncryptionTargetBundle: res.otpEncryptionTargetBundle,
    );
  }

  /// Verifies the OTP code sent to the user.
  ///
  /// Under the hood, the OTP code and an ephemeral client public key are encrypted to the enclave's
  /// target key (from [initOtp]) before being sent for verification.
  /// If verification is successful, it returns a verification token bound to the public key.
  /// The verification token can be used for subsequent login or sign-up flows.
  ///
  /// [otpId] The ID of the OTP to verify (returned from [initOtp]).
  /// [otpCode] The OTP code entered by the user.
  /// [otpEncryptionTargetBundle] The encryption target bundle returned from [initOtp].
  /// [publicKey] An optional public key to bind to the verification token. If not provided, a new
  /// key pair will be generated.
  /// Returns a [VerifyOtpResult] containing the verification token and the public key bound to it.
  /// Throws an [Exception] if the OTP verification fails.
  Future<VerifyOtpResult> verifyOtp({
    required String otpId,
    required String otpCode,
    required String otpEncryptionTargetBundle,
    String? publicKey,
  }) async {
    final resolvedPublicKey = publicKey ?? await createApiKeyPair();

    try {
      final encryptedOtpBundle = await encryptOtpCodeToBundle(
        otpCode: otpCode,
        otpEncryptionTargetBundle: otpEncryptionTargetBundle,
        publicKey: resolvedPublicKey,
      );

      final verifyOtpRes = await requireClient.proxyVerifyOtpV2(
        input: ProxyTVerifyOtpV2Body(
          otpId: otpId,
          encryptedOtpBundle: encryptedOtpBundle,
        ),
      );

      if (verifyOtpRes.verificationToken.isEmpty) {
        throw Exception('OTP verification failed');
      }

      return VerifyOtpResult(
        verificationToken: verifyOtpRes.verificationToken,
        publicKey: resolvedPublicKey,
      );
    } catch (e) {
      await deleteUnusedKeyPairs();
      throw Exception('OTP verification failed: $e');
    }
  }

  /// Logs in a user using an OTP (One-Time Password) verification token.
  ///
  /// This function logs in a user using the verification token received after OTP verification.
  /// The client signature is always produced using the private key bound to the verification token
  /// during [verifyOtp]. The verification token's embedded key becomes the session public key.
  /// Optionally invalidates any existing sessions for the user if [invalidateExisting] is set to true.
  /// Stores the resulting session token under the specified session key, or the default session key
  /// if not provided.
  ///
  /// [verificationToken] The OTP verification token received after verifying the OTP code.
  /// [organizationId] An optional organization ID to associate with the session.
  /// [invalidateExisting] Whether to invalidate existing sessions when logging in.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// Returns a [LoginWithOtpResult] containing the session token if successful.
  /// Throws an [Exception] if the login process fails.
  Future<LoginWithOtpResult> loginWithOtp({
    required String verificationToken,
    String? organizationId,
    bool invalidateExisting = false,
    String? sessionKey,
  }) async {
    try {
      // Derive verificationPublicKey from the token — this is the key bound during verifyOtp()
      // and is what Turnkey expects to sign the client signature for login.
      final payload = ClientSignature.forLogin(
        verificationToken: verificationToken,
      );
      final verificationPublicKey = payload.clientSignaturePublicKey;

      secureStorageStamper.setPublicKey(verificationPublicKey);
      final signature = await secureStorageStamper.sign(
        payload.message,
        format: SignatureFormat.raw,
      );

      if (signature.isEmpty) {
        throw Exception('Failed to create client signature on OTP login');
      }

      final clientSignature = v1ClientSignature(
        message: payload.message,
        publicKey: verificationPublicKey,
        scheme: v1ClientSignatureScheme.client_signature_scheme_api_p256,
        signature: signature,
      );

      final res = await requireClient.proxyOtpLoginV2(
        input: ProxyTOtpLoginV2Body(
          verificationToken: verificationToken,
          publicKey: verificationPublicKey,
          clientSignature: clientSignature,
          invalidateExisting: invalidateExisting,
          organizationId: organizationId,
        ),
      );

      if (res.session.isEmpty) {
        throw Exception('No session returned from OTP login');
      }

      await storeSession(sessionJwt: res.session, sessionKey: sessionKey);

      return LoginWithOtpResult(sessionToken: res.session);
    } catch (error) {
      await deleteUnusedKeyPairs();
      throw Exception('Failed to login with otp: $error');
    }
  }

  /// Signs up a user using an OTP verification token.
  ///
  /// This function signs up a user using the verification token received after OTP verification.
  /// Creates a new sub-organization for the user with the provided parameters and associates the
  /// contact (email or phone) with the sub-organization.
  /// The verification token's embedded key becomes the session public key.
  /// Stores the resulting session token under the specified session key, or the default session key
  /// if not provided.
  ///
  /// [verificationToken] The OTP verification token received after verifying the OTP code.
  /// [contact] The contact information (email address or phone number) associated with the OTP.
  /// [otpType] The type of OTP (email or SMS).
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [createSubOrgParams] Optional parameters for creating the sub-organization user.
  /// [invalidateExisting] Whether to invalidate existing sessions when signing up.
  /// Returns a [SignUpWithOtpResult] containing the session token if successful.
  /// Throws an [Exception] if the sign-up process fails.
  Future<SignUpWithOtpResult> signUpWithOtp({
    required String verificationToken,
    required String contact,
    required OtpType otpType,
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

    // Derive verificationPublicKey from the token — this is the key bound during verifyOtp()
    // and is what Turnkey expects to sign the client signature for signup.
    final payload = ClientSignature.forSignup(
      verificationToken: verificationToken,
      email: signUpBody.userEmail,
      phoneNumber: signUpBody.userPhoneNumber,
      apiKeys: signUpBody.apiKeys,
      authenticators: signUpBody.authenticators,
      oauthProviders: signUpBody.oauthProviders,
    );
    final verificationPublicKey = payload.clientSignaturePublicKey;

    try {
      secureStorageStamper.setPublicKey(verificationPublicKey);
      final signature = await secureStorageStamper.sign(
        payload.message,
        format: SignatureFormat.raw,
      );

      if (signature.isEmpty) {
        throw Exception('Failed to create client signature on OTP signup');
      }

      final clientSignature = v1ClientSignature(
        message: payload.message,
        publicKey: verificationPublicKey,
        scheme: v1ClientSignatureScheme.client_signature_scheme_api_p256,
        signature: signature,
      );

      final signUpBodyWithSignature = ProxyTSignupV2Body(
        userEmail: signUpBody.userEmail,
        userPhoneNumber: signUpBody.userPhoneNumber,
        userTag: signUpBody.userTag,
        userName: signUpBody.userName,
        organizationName: signUpBody.organizationName,
        verificationToken: signUpBody.verificationToken,
        apiKeys: signUpBody.apiKeys,
        authenticators: signUpBody.authenticators,
        oauthProviders: signUpBody.oauthProviders,
        wallet: signUpBody.wallet,
        clientSignature: clientSignature,
      );

      final signupRes =
          await requireClient.proxySignupV2(input: signUpBodyWithSignature);

      if (signupRes.organizationId.isEmpty) {
        throw Exception('Auth proxy OTP sign up failed');
      }

      final otpRes = await loginWithOtp(
        verificationToken: verificationToken,
        invalidateExisting: invalidateExisting,
        sessionKey: sessionKey,
      );

      return SignUpWithOtpResult(sessionToken: otpRes.sessionToken);
    } catch (e) {
      await deleteUnusedKeyPairs();
      throw Exception('Sign up failed: $e');
    }
  }

  /// Completes the OTP authentication flow by verifying the encrypted OTP bundle and then
  /// either signing up or logging in the user.
  ///
  /// This function encrypts the OTP code and the session public key to the enclave's target key,
  /// verifies the OTP, and then either signs up or logs in the user.
  /// If the contact is not associated with an existing sub-organization, it will automatically
  /// create a new sub-organization and complete the sign-up flow.
  /// If the contact is already associated with a sub-organization, it will complete the login flow.
  /// The key bound to the verification token during [verifyOtp] is always reused as the session
  /// public key.
  ///
  /// [otpId] The ID of the OTP to complete (returned from [initOtp]).
  /// [otpCode] The OTP code entered by the user.
  /// [otpEncryptionTargetBundle] The encryption target bundle returned from [initOtp].
  /// [contact] The contact information (email or phone number) associated with the OTP.
  /// [otpType] The type of OTP (email or SMS).
  /// [publicKey] An optional public key to bind to the verification token via [verifyOtp]. If not
  /// provided, a new key pair will be generated. This key becomes the session public key.
  /// [invalidateExisting] Whether to invalidate existing sessions for the user.
  /// [sessionKey] An optional key to store the session under. If null, uses the default session key.
  /// [createSubOrgParams] Optional parameters for sub-organization creation.
  /// Returns a [LoginOrSignUpWithOtpResult] containing the session token, verification token, and
  /// action (login or signup) if successful.
  /// Throws an [Exception] if the OTP authentication process fails.
  Future<LoginOrSignUpWithOtpResult> loginOrSignUpWithOtp({
    required String otpId,
    required String otpCode,
    required String otpEncryptionTargetBundle,
    required String contact,
    required OtpType otpType,
    String? publicKey,
    bool invalidateExisting = false,
    String? sessionKey,
    CreateSubOrgParams? createSubOrgParams,
  }) async {
    final resolvedPublicKey = publicKey ?? await createApiKeyPair();

    try {
      final verifyOtpResult = await verifyOtp(
        otpId: otpId,
        otpCode: otpCode,
        otpEncryptionTargetBundle: otpEncryptionTargetBundle,
        publicKey: resolvedPublicKey,
      );

      final verificationToken = verifyOtpResult.verificationToken;

      if (verificationToken.isEmpty) {
        throw Exception('No verification token returned from OTP verification');
      }

      final accountRes = await requireClient.proxyGetAccount(
        input: ProxyTGetAccountBody(
          filterType: otpTypeToFilterTypeMap[otpType]!.value,
          filterValue: contact,
          verificationToken: verificationToken,
        ),
      );

      final subOrganizationId = accountRes.organizationId;

      if (subOrganizationId == null || subOrganizationId.isEmpty) {
        final signUpRes = await signUpWithOtp(
          verificationToken: verificationToken,
          contact: contact,
          otpType: otpType,
          createSubOrgParams: createSubOrgParams,
          invalidateExisting: invalidateExisting,
          sessionKey: sessionKey,
        );

        return LoginOrSignUpWithOtpResult(
          sessionToken: signUpRes.sessionToken,
          verificationToken: verificationToken,
          action: AuthAction.signup,
        );
      } else {
        final loginRes = await loginWithOtp(
          verificationToken: verificationToken,
          invalidateExisting: invalidateExisting,
          sessionKey: sessionKey,
        );

        return LoginOrSignUpWithOtpResult(
          sessionToken: loginRes.sessionToken,
          verificationToken: verificationToken,
          action: AuthAction.login,
        );
      }
    } catch (e) {
      await deleteUnusedKeyPairs();
      throw Exception('OTP authentication failed: $e');
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
      final res = await requireClient.proxySignupV2(input: signUpBody);

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
  /// Returns a [LoginOrSignUpWithOAuthResult] containing the session token and action (login or signup) if successful.
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
}
