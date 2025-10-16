import 'dart:convert';

import 'package:turnkey_http/__generated__/models.dart';
import 'package:turnkey_sdk_flutter/src/constants.dart';

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

/// A class representing a user with various attributes.
class User {
  final String id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String organizationId;
  final List<Wallet> wallets;

  User({
    required this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    required this.organizationId,
    required this.wallets,
  });

  /// Converts the user to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'organizationId': organizationId,
        'wallets': wallets.map((wallet) => wallet.toJson()).toList(),
      };

  /// Creates a user from a JSON map.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['userName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      organizationId: json['organizationId'],
      wallets: (json['wallets'] as List<dynamic>)
          .map((walletJson) => Wallet.fromJson(walletJson))
          .toList(),
    );
  }
}

/// A class representing a wallet with a name, id, and a list of accounts.
class Wallet {
  final String name;
  final String id;
  final List<WalletAccount> accounts;

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
          .map((accountJson) => WalletAccount.fromJson(accountJson))
          .toList(),
    );
  }
}

/// A class representing a wallet account with various attributes.
class WalletAccount {
  final String id;
  final v1Curve curve;
  final v1PathFormat pathFormat;
  final String path;
  final v1AddressFormat addressFormat;
  final String address;
  final externaldatav1Timestamp createdAt;
  final externaldatav1Timestamp updatedAt;

  WalletAccount({
    required this.id,
    required this.curve,
    required this.pathFormat,
    required this.path,
    required this.addressFormat,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converts the wallet account to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'curve': curve.toString(),
        'pathFormat': pathFormat.toString(),
        'path': path,
        'addressFormat': addressFormat.toString(),
        'address': address,
        'createdAt': createdAt.toJson(),
        'updatedAt': updatedAt.toJson(),
      };

  /// Creates a wallet account from a JSON map.
  factory WalletAccount.fromJson(Map<String, dynamic> json) {
    return WalletAccount(
      id: json['id'],
      curve: v1Curve.values.firstWhere((e) => e.toString() == json['curve']),
      pathFormat: v1PathFormat.values
          .firstWhere((e) => e.toString() == json['pathFormat']),
      path: json['path'],
      addressFormat: v1AddressFormat.values
          .firstWhere((e) => e.toString() == json['addressFormat']),
      address: json['address'],
      createdAt: externaldatav1Timestamp.fromJson(json['createdAt']),
      updatedAt: externaldatav1Timestamp.fromJson(json['updatedAt']),
    );
  }
}

class TurnkeyConfig {
  final String apiBaseUrl;
  final String organizationId;
  final String appScheme;
  final String? authProxyBaseUrl;
  final String? authProxyConfigId;
  final AuthConfig? authConfig;

  final void Function(Session session)? onSessionCreated;
  final void Function(Session session)? onSessionSelected;
  final void Function(Session session)? onSessionExpired;
  final void Function(Session session)? onSessionCleared;
  final void Function(Session session)? onSessionRefreshed;
  final void Function()? onSessionEmpty;
  final void Function(Object? error)? onInitialized;

  TurnkeyConfig({
    required this.apiBaseUrl,
    required this.organizationId,
    required this.appScheme,
    this.authConfig,
    this.authProxyBaseUrl,
    this.authProxyConfigId,
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
  final AuthMethods? methods;
  final OAuthConfig? oAuthConfig;
  /** session expiration time in seconds. If using the auth proxy, you must configure this setting through the dashboard. Changing this through the TurnkeyProvider will have no effect. */
  final String? sessionExpirationSeconds;
  /** If otp sent will be alphanumeric. If using the auth proxy, you must configure this setting through the dashboard. Changing this through the TurnkeyProvider will have no effect. */
  final bool? otpAlphanumeric;
  /** length of the OTP. If using the auth proxy, you must configure this setting through the dashboard. Changing this through the TurnkeyProvider will have no effect. */
  final String? otpLength;

  const AuthConfig({
    this.methods,
    this.oAuthConfig,
    this.sessionExpirationSeconds,
    this.otpAlphanumeric,
    this.otpLength,
  });
}

class AuthMethods {
  final bool? emailOtpAuthEnabled;
  final bool? smsOtpAuthEnabled;
  final bool? passkeyAuthEnabled;
  final bool? walletAuthEnabled;
  final bool? googleOauthEnabled;
  final bool? appleOauthEnabled;
  final bool? xOauthEnabled;
  final bool? discordOauthEnabled;
  final bool? facebookOauthEnabled;

  const AuthMethods({
    this.emailOtpAuthEnabled,
    this.smsOtpAuthEnabled,
    this.passkeyAuthEnabled,
    this.walletAuthEnabled,
    this.googleOauthEnabled,
    this.appleOauthEnabled,
    this.xOauthEnabled,
    this.discordOauthEnabled,
    this.facebookOauthEnabled,
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

class CompleteOtpResult extends BaseAuthResult {
  final AuthAction action;
  const CompleteOtpResult({
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

class CompleteOAuthResult extends BaseAuthResult {
  final AuthAction action;
  const CompleteOAuthResult({
    required super.sessionToken,
    required this.action,
  });
}

class ChallengePair {
  final String verifier;
  final String codeChallenge;
  ChallengePair({required this.verifier, required this.codeChallenge});
}