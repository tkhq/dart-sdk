part of 'turnkey.dart';

extension AuthProxyExtension on TurnkeyProvider {

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
            filterValue: contact,
            verificationToken: verifyOtpRes.verificationToken));

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