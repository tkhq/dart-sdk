import 'dart:convert';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/utils/constants.dart';

class VerificationToken {
  final String contact;
  final int exp;
  final String id;
  final String? publicKey;
  final String verificationType;

  const VerificationToken({
    required this.contact,
    required this.exp,
    required this.id,
    this.publicKey,
    required this.verificationType,
  });

  factory VerificationToken.fromJson(Map<String, dynamic> json) {
    return VerificationToken(
      contact: json['contact'] as String,
      exp: json['exp'] as int,
      id: json['id'] as String,
      publicKey: json['public_key'] as String?,
      verificationType: json['verification_type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact': contact,
      'exp': exp,
      'id': id,
      'public_key': publicKey,
      'verification_type': verificationType,
    };
  }

  static VerificationToken fromJwt(String token) {
    final parts = token.split(".");
    if (parts.length < 2) {
      throw Exception("Invalid JWT: Missing payload");
    }

    final payload = parts[1];
    final normalized =
        base64.normalize(payload.replaceAll('-', '+').replaceAll('_', '/'));
    final decodedBytes = base64.decode(normalized);
    final decoded =
        jsonDecode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

    return VerificationToken.fromJson(decoded);
  }
}

/// A class representing a session with public and private keys and an expiry time.
class Session {
  final String sessionType;
  final String userId;
  final String organizationId;
  final int expiry;
  final String expirationSeconds;
  final String publicKey;
  final String token;

  const Session({
    required this.sessionType,
    required this.userId,
    required this.organizationId,
    required this.expiry,
    required this.expirationSeconds,
    required this.publicKey,
    required this.token,
  });

  /// Construct from JSON (used when retrieving from storage)
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      sessionType: json['sessionType'] as String,
      userId: json['userId'] as String,
      organizationId: json['organizationId'] as String,
      expiry: json['expiry'] as int,
      expirationSeconds: json['expirationSeconds'] as String,
      publicKey: json['publicKey'] as String,
      token: json['token'] as String,
    );
  }

  /// Convert back to JSON (used for storage)
  Map<String, dynamic> toJson() {
    return {
      'sessionType': sessionType,
      'userId': userId,
      'organizationId': organizationId,
      'expiry': expiry,
      'expirationSeconds': expirationSeconds,
      'publicKey': publicKey,
      'token': token,
    };
  }

  /// Helper: create Session from a JWT string
  static Session fromJwt(String token) {
    final parts = token.split(".");
    if (parts.length < 2) {
      throw Exception("Invalid JWT: Missing payload");
    }

    final payload = parts[1];
    final normalized =
        base64.normalize(payload.replaceAll('-', '+').replaceAll('_', '/'));
    final decodedBytes = base64.decode(normalized);
    final decoded =
        jsonDecode(utf8.decode(decodedBytes)) as Map<String, dynamic>;

    final exp = decoded["exp"];
    final publicKey = decoded["public_key"];
    final sessionType = decoded["session_type"];
    final userId = decoded["user_id"];
    final organizationId = decoded["organization_id"];

    if (exp == null ||
        publicKey == null ||
        sessionType == null ||
        userId == null ||
        organizationId == null) {
      throw Exception("JWT payload missing required fields");
    }

    final expirySeconds =
        ((exp * 1000 - DateTime.now().millisecondsSinceEpoch) / 1000).ceil();

    return Session(
      sessionType: sessionType,
      userId: userId,
      organizationId: organizationId,
      expiry: exp,
      expirationSeconds: expirySeconds.toString(),
      publicKey: publicKey,
      token: token,
    );
  }
}

/// A class representing a wallet with a name, id, and a list of accounts.
class Wallet {
  final String name;
  final String id;
  final List<v1WalletAccount> accounts;

  Wallet({
    required this.name,
    required this.id,
    required this.accounts,
  });

  /// Converts the wallet to a JSON map.
  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'accounts': accounts.map((account) => account.toJson()).toList(),
      };

  /// Creates a wallet from a JSON map.
  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      name: json['name'],
      id: json['id'],
      accounts: (json['accounts'] as List<dynamic>)
          .map((accountJson) => v1WalletAccount.fromJson(accountJson))
          .toList(),
    );
  }
}

class TurnkeyRuntimeConfig extends TurnkeyConfig {
  TurnkeyRuntimeConfig({
    required String organizationId,
    String? apiBaseUrl,
    String? authProxyBaseUrl,
    String? authProxyConfigId,
    RuntimeAuthConfig authConfig = const RuntimeAuthConfig(),
    PasskeyConfig? passkeyConfig,
    String? appScheme,
    void Function(Session session)? onSessionCreated,
    void Function(Session session)? onSessionSelected,
    void Function(Session session)? onSessionExpired,
    void Function(Session session)? onSessionCleared,
    void Function(Session session)? onSessionRefreshed,
    void Function()? onSessionEmpty,
    void Function(Object? error)? onInitialized,
  }) : super(
          organizationId: organizationId,
          apiBaseUrl: apiBaseUrl,
          authProxyBaseUrl: authProxyBaseUrl,
          authProxyConfigId: authProxyConfigId,
          authConfig: authConfig,
          passkeyConfig: passkeyConfig,
          appScheme: appScheme,
          onSessionCreated: onSessionCreated,
          onSessionSelected: onSessionSelected,
          onSessionExpired: onSessionExpired,
          onSessionCleared: onSessionCleared,
          onSessionRefreshed: onSessionRefreshed,
          onSessionEmpty: onSessionEmpty,
          onInitialized: onInitialized,
        );
  @override
  RuntimeAuthConfig get authConfig =>
      super.authConfig as RuntimeAuthConfig;
}

class RuntimeAuthConfig extends AuthConfig {
  // Use ints if these are numeric:
  final String? sessionExpirationSeconds;
  final bool? otpAlphanumeric;
  final String? otpLength;

  const RuntimeAuthConfig({
    // Runtime additions:
    this.sessionExpirationSeconds,
    this.otpAlphanumeric,
    this.otpLength,
    OAuthConfig? oAuthConfig,
    MethodCreateSubOrgParams? createSubOrgParams,
    bool autoFetchWalletKitConfig = true,
    bool autoRefreshManagedState = true,
  }) : super(
          oAuthConfig: oAuthConfig,
          createSubOrgParams: createSubOrgParams,
          autoFetchWalletKitConfig: autoFetchWalletKitConfig,
          autoRefreshManagedState: autoRefreshManagedState,
        );
}

class TurnkeyConfig {
  final String organizationId;
  final String? apiBaseUrl;
  final String? authProxyBaseUrl;
  final String? authProxyConfigId;
  final AuthConfig? authConfig;
  final PasskeyConfig? passkeyConfig;

  final String? appScheme;

  final void Function(Session session)? onSessionCreated;
  final void Function(Session session)? onSessionSelected;
  final void Function(Session session)? onSessionExpired;
  final void Function(Session session)? onSessionCleared;
  final void Function(Session session)? onSessionRefreshed;
  final void Function()? onSessionEmpty;
  final void Function(Object? error)? onInitialized;

  TurnkeyConfig({
    required this.organizationId,
    this.apiBaseUrl,
    this.authProxyBaseUrl,
    this.authProxyConfigId,
    this.authConfig =
        const AuthConfig(), // Default to empty config. We set a default inside this object so we need to do this.
    this.passkeyConfig,
    this.appScheme,
    this.onSessionCreated,
    this.onSessionSelected,
    this.onSessionExpired,
    this.onSessionCleared,
    this.onSessionRefreshed,
    this.onSessionEmpty,
    this.onInitialized,
  });
}

class AuthConfig {
  final OAuthConfig? oAuthConfig;
  final MethodCreateSubOrgParams? createSubOrgParams;
  /** If true, will automatically fetch the WalletKit configuration specified in the Turnkey Dashboard upon initialization. Defaults to true. */
  final bool? autoFetchWalletKitConfig;
  /** If true, managed state variables (such as wallets and user) will automatically refresh when necessary. Defaults to true. */
  final bool? autoRefreshManagedState;
  const AuthConfig({
    this.oAuthConfig,
    this.createSubOrgParams,
    // Default to true here. Usually we'd do this in the "buildConfig()" method but this is actually needed right before that function runs!
    this.autoFetchWalletKitConfig = true,
    this.autoRefreshManagedState = true,
  });
}

class PasskeyConfig {
  final String? rpId;
  final String? rpName;

  const PasskeyConfig({
    this.rpId,
    this.rpName,
  });
}

class MethodCreateSubOrgParams {
  final CreateSubOrgParams? emailOtpAuth;
  final CreateSubOrgParams? smsOtpAuth;
  final CreateSubOrgParams? passkeyAuth;
  final CreateSubOrgParams? oAuth;

  const MethodCreateSubOrgParams({
    this.emailOtpAuth,
    this.smsOtpAuth,
    this.passkeyAuth,
    this.oAuth,
  });
}

class OAuthConfig {
  /** redirect URI for OAuth. */
  final String? oauthRedirectUri;
  /** client ID for Google OAuth. */
  final String? googleClientId;
  /** client ID for Apple OAuth. */
  final String? appleClientId;
  /** client ID for Facebook OAuth. */
  final String? facebookClientId;
  /** client ID for X (formerly Twitter) OAuth. */
  final String? xClientId;
  /** client ID for Discord OAuth. */
  final String? discordClientId;

  const OAuthConfig({
    this.oauthRedirectUri,
    this.googleClientId,
    this.appleClientId,
    this.facebookClientId,
    this.xClientId,
    this.discordClientId,
  });
}

/// CreateSubOrgParams defines the parameters to pass on sub-organization creation.
class CreateSubOrgParams {
  /// name of the user
  final String? userName;

  /// name of the sub-organization
  final String? subOrgName;

  /// email of the user
  final String? userEmail;

  /// tag of the user
  final String? userTag;

  /// list of authenticators
  final List<CreateSubOrgAuthenticator>? authenticators;

  /// phone number of the user
  final String? userPhoneNumber;

  /// verification token if email or phone number is provided
  final String? verificationToken;

  /// list of api keys
  final List<CreateSubOrgApiKey>? apiKeys;

  /// custom wallets to create during sub-org creation time
  final CustomWallet? customWallet;

  /// list of oauth providers
  final List<v1OauthProviderParams>? oauthProviders;

  const CreateSubOrgParams({
    this.userName,
    this.subOrgName,
    this.userEmail,
    this.userTag,
    this.authenticators,
    this.userPhoneNumber,
    this.verificationToken,
    this.apiKeys,
    this.customWallet,
    this.oauthProviders,
  });

  CreateSubOrgParams copyWith({
    String? userName,
    String? subOrgName,
    Object? userEmail = _no, // use sentinel for nullable overwrite
    String? userTag,
    List<CreateSubOrgAuthenticator>? authenticators,
    Object? userPhoneNumber = _no, // sentinel again
    Object? verificationToken = _no,
    List<CreateSubOrgApiKey>? apiKeys,
    CustomWallet? customWallet,
    List<v1OauthProviderParams>? oauthProviders,
  }) {
    return CreateSubOrgParams(
      userName: userName ?? this.userName,
      subOrgName: subOrgName ?? this.subOrgName,
      userEmail:
          identical(userEmail, _no) ? this.userEmail : userEmail as String?,
      userTag: userTag ?? this.userTag,
      authenticators: authenticators ?? this.authenticators,
      userPhoneNumber: identical(userPhoneNumber, _no)
          ? this.userPhoneNumber
          : userPhoneNumber as String?,
      verificationToken: identical(verificationToken, _no)
          ? this.verificationToken
          : verificationToken as String?,
      apiKeys: apiKeys ?? this.apiKeys,
      customWallet: customWallet ?? this.customWallet,
      oauthProviders: oauthProviders ?? this.oauthProviders,
    );
  }
}

const _no = Object(); // sentinel

/// Authenticator item used in CreateSubOrgParams.authenticators
class CreateSubOrgAuthenticator {
  /// name of the authenticator
  final String? authenticatorName;

  /// challenge string to use for passkey registration (required)
  final String challenge;

  /// attestation object returned from the passkey creation process (required)
  final v1Attestation attestation;

  const CreateSubOrgAuthenticator({
    this.authenticatorName,
    required this.challenge,
    required this.attestation,
  });
}

/// API key item used in CreateSubOrgParams.apiKeys
class CreateSubOrgApiKey {
  /// name of the api key
  final String? apiKeyName;

  /// public key in hex format (required)
  final String publicKey;

  /// expiration in seconds
  final String? expirationSeconds;

  /// curve type
  final v1ApiKeyCurve? curveType;

  const CreateSubOrgApiKey({
    this.apiKeyName,
    required this.publicKey,
    this.expirationSeconds,
    this.curveType,
  });
}

/// CustomWallet
class CustomWallet {
  /// name of the wallet created (required)
  final String walletName;

  /// list of wallet accounts to create (required)
  final List<v1WalletAccountParams> walletAccounts;

  const CustomWallet({
    required this.walletName,
    required this.walletAccounts,
  });
}

/// SignUpBody (internal)
class SignUpBody {
  final String userName; // required
  final String subOrgName; // required
  final String? userEmail;
  final String? userTag;

  /// list of authenticators (each item has required fields)
  final List<v1AuthenticatorParamsV2>? authenticators;

  final String? userPhoneNumber;
  final String? verificationToken;

  /// list of api keys (each item has required fields)
  final List<v1ApiKeyParamsV2>? apiKeys;

  /// custom wallet (optional)
  final CustomWallet? customWallet;

  /// list of oauth providers
  final List<v1OauthProviderParams>? oauthProviders;

  const SignUpBody({
    required this.userName,
    required this.subOrgName,
    this.userEmail,
    this.userTag,
    this.authenticators,
    this.userPhoneNumber,
    this.verificationToken,
    this.apiKeys,
    this.customWallet,
    this.oauthProviders,
  });
}

class VerifyOtpResult {
  final String verificationToken;
  final String? subOrganizationId;
  VerifyOtpResult({required this.verificationToken, this.subOrganizationId});
}

class BaseAuthResult {
  final String sessionToken;
  const BaseAuthResult({required this.sessionToken});
}

class LoginWithPasskeyResult extends BaseAuthResult {
  const LoginWithPasskeyResult({required super.sessionToken});
}

class SignUpWithPasskeyResult extends BaseAuthResult {
  final String credentialId;
  const SignUpWithPasskeyResult(
      {required super.sessionToken, required this.credentialId});
}

class LoginWithOtpResult extends BaseAuthResult {
  const LoginWithOtpResult({required super.sessionToken});
}

class SignUpWithOtpResult extends BaseAuthResult {
  const SignUpWithOtpResult({required super.sessionToken});
}

class LoginOrSignUpWithOtpResult extends BaseAuthResult {
  final AuthAction action;
  const LoginOrSignUpWithOtpResult({
    required super.sessionToken,
    required this.action,
  });
}

class LoginWithOAuthResult extends BaseAuthResult {
  const LoginWithOAuthResult({required super.sessionToken});
}

class SignUpWithOAuthResult extends BaseAuthResult {
  const SignUpWithOAuthResult({required super.sessionToken});
}

class LoginOrSignUpWithOAuthResult extends BaseAuthResult {
  final AuthAction action;
  const LoginOrSignUpWithOAuthResult({
    required super.sessionToken,
    required this.action,
  });
}

class ChallengePair {
  final String verifier;
  final String codeChallenge;
  ChallengePair({required this.verifier, required this.codeChallenge});
}

class CreateP256UserParams {
  final String? userName;
  final String? apiKeyName;

  const CreateP256UserParams({this.userName, this.apiKeyName});
}

class Policy extends v1CreatePolicyIntentV3 {
  final String policyId;

  Policy({
    required this.policyId,
    required String policyName,
    required v1Effect effect,
    required String notes,
    String? condition,
    String? consensus,
  }) : super(
          policyName: policyName,
          effect: effect,
          condition: condition,
          consensus: consensus,
          notes: notes,
        );

  /// Construct from a policy creation intent and attach a policyId.
  factory Policy.fromCreateIntent(
    v1CreatePolicyIntentV3 p, {
    required String policyId,
  }) {
    return Policy(
      policyId: policyId,
      policyName: p.policyName,
      effect: p.effect,
      condition: p.condition,
      consensus: p.consensus,
      notes: p.notes,
    );
  }
}

/// Result of creating a client signature payload
class ClientSignaturePayload {
  /// The JSON message to sign
  final String message;

  /// The public key to use for client signature verification
  final String clientSignaturePublicKey;

  const ClientSignaturePayload({
    required this.message,
    required this.clientSignaturePublicKey,
  });
}
