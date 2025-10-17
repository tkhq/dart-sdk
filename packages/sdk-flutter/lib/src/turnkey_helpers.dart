import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:crypto/crypto.dart';

/// Fetches user details and associated wallets from the Turnkey API.
///
/// Retrieves the user's `whoami` information to obtain their ID and organization ID.
/// Fetches the user's wallets and account details.
/// Fetches the user's profile information.
/// Returns a `User` object containing the retrieved details.
///
/// [client] The authenticated `TurnkeyClient` instance.
/// [organizationId] The ID of the organization to which the user belongs.
/// Returns the `User` object containing user details and associated wallets, or `null` if the user is not found.
/// Throws if any API request fails.
Future<v1User?> fetchUser(
    TurnkeyClient client, String organizationId, String userId) async {
  try {
    final userResponse = await client.getUser(
      input: TGetUserBody(
        organizationId: organizationId,
        userId: userId,
      ),
    );

    final user = userResponse.user;

    return user;
  } catch (e) {
    print("Error fetching user: $e");
    rethrow;
  }
}

Future<List<Wallet>> fetchWallets(
    TurnkeyClient client, String organizationId) async {
  try {
    final walletsResponse = await client.getWallets(
      input: TGetWalletsBody(organizationId: organizationId),
    );

    final walletAccountsResponse =
        await fetchWalletAccountsWithCursor(client, organizationId);

    final wallets = walletsResponse.wallets.map((wallet) {
      final accounts = walletAccountsResponse
          .where((account) => account.walletId == wallet.walletId)
          .toList();
      return Wallet(
        id: wallet.walletId,
        name: wallet.walletName,
        accounts: accounts,
      );
    }).toList();

    return wallets;
  } catch (e) {
    print("Error fetching wallets: $e");
    rethrow;
  }
}

Future<List<v1WalletAccount>> fetchWalletAccountsWithCursor(
    TurnkeyClient client, String organizationId) async {
  List<v1WalletAccount> allAccounts = [];
  String? nextCursor;
  int limit = 100;
  bool hasMore = false;

  do {
    final walletAccountsResponse = await client.getWalletAccounts(
      input: TGetWalletAccountsBody(
          organizationId: organizationId,
          paginationOptions: v1Pagination(
            limit: limit.toString(),
            after: nextCursor,
          )),
    );

    allAccounts.addAll(walletAccountsResponse.accounts);
    if (allAccounts.length == limit) {
      hasMore = true;
      nextCursor = allAccounts.last.walletAccountId;
    } else {
      hasMore = false;
    }
  } while (hasMore);

  return allAccounts;
}

/// Checks if a given [session] is valid.
///
/// A session is considered valid if it has a defined expiry time
/// and the expiry time is in the future.
///
/// Returns `true` if the session is valid, otherwise `false`.
bool isValidSession(Session? session) {
  return session != null &&
      session.expiry * 1000 > DateTime.now().millisecondsSinceEpoch;
}

ProxyTSignupBody buildSignUpBody({
  required CreateSubOrgParams? createSubOrgParams,
  bool isWeb = false,

  /// Optional hostname to use when [isWeb] = true. If omitted,
  /// a generic 'web' string is used.
  String? webHostname,
}) {
  final now = DateTime.now().millisecondsSinceEpoch;
  final defaultAuthenticatorName =
      isWeb ? '${(webHostname ?? 'web')}-$now' : 'passkey-$now';

  // --- authenticators ---
  final List<v1AuthenticatorParamsV2> authenticators =
      (createSubOrgParams?.authenticators ?? const [])
          .map((a) => v1AuthenticatorParamsV2(
                authenticatorName: (a.authenticatorName == null ||
                        a.authenticatorName!.isEmpty)
                    ? defaultAuthenticatorName
                    : a.authenticatorName!,
                challenge: a.challenge,
                attestation: a.attestation,
              ))
          .toList();

  final List<v1AuthenticatorParamsV2> authenticatorsOrEmpty =
      (createSubOrgParams?.authenticators?.isNotEmpty ?? false)
          ? authenticators
          : <v1AuthenticatorParamsV2>[];

  // --- apiKeys ---
  final List<v1ApiKeyParamsV2> apiKeys =
      (createSubOrgParams?.apiKeys ?? const [])
          .where((k) => k.curveType != null)
          .map((k) => v1ApiKeyParamsV2(
                apiKeyName: (k.apiKeyName == null || k.apiKeyName!.isEmpty)
                    ? 'api-key-$now'
                    : k.apiKeyName!,
                publicKey: k.publicKey,
                curveType: k.curveType!,
                expirationSeconds: k.expirationSeconds,
              ))
          .toList();

  final List<v1ApiKeyParamsV2> apiKeysOrEmpty =
      (createSubOrgParams?.apiKeys?.isNotEmpty ?? false)
          ? apiKeys
          : <v1ApiKeyParamsV2>[];

  // --- oauth providers ---  //
  final List<v1OauthProviderParams> oauthProvidersOrEmpty =
      (createSubOrgParams?.oauthProviders?.isNotEmpty ?? false)
          ? createSubOrgParams!.oauthProviders as List<v1OauthProviderParams>
          : const [];

  // --- wallet mapping ---
  final wallet = (createSubOrgParams?.customWallet != null)
      ? v1WalletParams(
          walletName: createSubOrgParams!.customWallet!.walletName,
          accounts: createSubOrgParams.customWallet!.walletAccounts,
        )
      : null;

  final userName = createSubOrgParams?.userName?.isNotEmpty == true
      ? createSubOrgParams!.userName!
      : (createSubOrgParams?.userEmail?.isNotEmpty == true
          ? createSubOrgParams!.userEmail!
          : 'user-$now');

  final orgName = createSubOrgParams?.subOrgName?.isNotEmpty == true
      ? createSubOrgParams!.subOrgName!
      : 'sub-org-$now';

  return ProxyTSignupBody(
    userName: userName,
    userEmail: createSubOrgParams?.userEmail,
    authenticators: authenticatorsOrEmpty,
    userPhoneNumber: createSubOrgParams?.userPhoneNumber,
    userTag: createSubOrgParams?.userTag,
    organizationName: orgName,
    verificationToken: createSubOrgParams?.verificationToken,
    apiKeys: apiKeysOrEmpty,
    oauthProviders: oauthProvidersOrEmpty,
    wallet: wallet,
  );
}

/// Generate PKCE (S256) verifier + code_challenge pair.
Future<ChallengePair> generateChallengePair() async {
  final verifier = _randomVerifier();
  final digest = sha256.convert(utf8.encode(verifier));
  final codeChallenge = _base64UrlNoPadding(digest.bytes);
  return ChallengePair(verifier: verifier, codeChallenge: codeChallenge);
}

String _randomVerifier({int lengthBytes = 32}) {
  // 32 random bytes gives a verifier string within the PKCE 43–128 char limit
  final r = Random.secure();
  final bytes = List<int>.generate(lengthBytes, (_) => r.nextInt(256));
  return _base64UrlNoPadding(bytes);
}

String _base64UrlNoPadding(List<int> bytes) {
  // base64url and strip '=' padding to match PKCE requirements
  return base64Url.encode(bytes).replaceAll('=', '');
}

sealed class OverrideParams {
  const OverrideParams();
}

final class OtpOverriredParams extends OverrideParams {
  final OtpType otpType;
  final String contact;
  final String verificationToken;

  const OtpOverriredParams({
    required this.otpType,
    required this.contact,
    required this.verificationToken,
  });
}

final class OAuthOverridedParams extends OverrideParams {
  final String providerName;
  final String oidcToken;

  const OAuthOverridedParams({
    required this.providerName,
    required this.oidcToken,
  });
}

final class PasskeyOverridedParams extends OverrideParams {
  final String passkeyName;
  final v1Attestation attestation;
  final String encodedChallenge;
  final String? temporaryPublicKey;

  const PasskeyOverridedParams({
    required this.passkeyName,
    required this.attestation,
    required this.encodedChallenge,
    this.temporaryPublicKey,
  });
}

CreateSubOrgParams getCreateSubOrgParams(
    CreateSubOrgParams? createSubOrgParams,
    TurnkeyConfig config,
    OverrideParams overrideParams) {
  final configCreateSubOrgParams = config.authConfig?.createSubOrgParams;

  switch (overrideParams) {
    case OtpOverriredParams():
      if (overrideParams.otpType == OtpType.Email) {
        return (createSubOrgParams != null)
            ? createSubOrgParams.copyWith(
                userEmail: overrideParams.contact,
                verificationToken: overrideParams.verificationToken,
              )
            : configCreateSubOrgParams?.emailOtpAuth != null
                ? configCreateSubOrgParams!.emailOtpAuth!.copyWith(
                    userEmail: overrideParams.contact,
                    verificationToken: overrideParams.verificationToken,
                  )
                : CreateSubOrgParams(
                    userEmail: overrideParams.contact,
                    verificationToken: overrideParams.verificationToken,
                  );
      } else {
        return (createSubOrgParams != null)
            ? createSubOrgParams.copyWith(
                userPhoneNumber: overrideParams.contact,
                verificationToken: overrideParams.verificationToken,
              )
            : configCreateSubOrgParams?.smsOtpAuth != null
                ? configCreateSubOrgParams!.smsOtpAuth!.copyWith(
                    userPhoneNumber: overrideParams.contact,
                    verificationToken: overrideParams.verificationToken,
                  )
                : CreateSubOrgParams(
                    userPhoneNumber: overrideParams.contact,
                    verificationToken: overrideParams.verificationToken,
                  );
      }
    case OAuthOverridedParams():
      return (createSubOrgParams != null)
          ? createSubOrgParams.copyWith(oauthProviders: [
              v1OauthProviderParams(
                providerName: overrideParams.providerName,
                oidcToken: overrideParams.oidcToken,
              )
            ])
          : configCreateSubOrgParams?.oAuth != null
              ? configCreateSubOrgParams!.oAuth!.copyWith(oauthProviders: [
                  v1OauthProviderParams(
                    providerName: overrideParams.providerName,
                    oidcToken: overrideParams.oidcToken,
                  )
                ])
              : CreateSubOrgParams(oauthProviders: [
                  v1OauthProviderParams(
                    providerName: overrideParams.providerName,
                    oidcToken: overrideParams.oidcToken,
                  )
                ]);
    case PasskeyOverridedParams():
      return (createSubOrgParams != null)
          ? createSubOrgParams.copyWith(
              authenticators: [
                CreateSubOrgAuthenticator(
                  authenticatorName: overrideParams.passkeyName,
                  challenge: overrideParams.encodedChallenge,
                  attestation: overrideParams.attestation,
                ),
              ],
              apiKeys: [
                CreateSubOrgApiKey(
                  apiKeyName: 'passkey-auth-${overrideParams.temporaryPublicKey}',
                  publicKey: overrideParams.temporaryPublicKey!,
                  curveType: v1ApiKeyCurve.api_key_curve_p256,

                  // we set a short expiration since this is a temporary key
                  expirationSeconds: "15",
                ),
              ],
            )
          : (config.authConfig?.createSubOrgParams?.passkeyAuth != null)
              ? config.authConfig!.createSubOrgParams!.passkeyAuth!.copyWith(
                  authenticators: [
                    CreateSubOrgAuthenticator(
                      authenticatorName: overrideParams.passkeyName,
                      challenge: overrideParams.encodedChallenge,
                      attestation: overrideParams.attestation,
                    ),
                  ],
                  apiKeys: [
                    CreateSubOrgApiKey(
                      apiKeyName: 'passkey-auth-${overrideParams.temporaryPublicKey}',
                      publicKey: overrideParams.temporaryPublicKey!,
                      curveType: v1ApiKeyCurve.api_key_curve_p256,

                      // we set a short expiration since this is a temporary key
                      expirationSeconds: "15",
                    ),
                  ],
                )
              : CreateSubOrgParams(
                  authenticators: [
                    CreateSubOrgAuthenticator(
                      authenticatorName: overrideParams.passkeyName,
                      challenge: overrideParams.encodedChallenge,
                      attestation: overrideParams.attestation,
                    ),
                  ],
                  apiKeys: [
                    CreateSubOrgApiKey(
                      apiKeyName: 'passkey-auth-${overrideParams.temporaryPublicKey}',
                      publicKey: overrideParams.temporaryPublicKey!,
                      curveType: v1ApiKeyCurve.api_key_curve_p256,

                      // we set a short expiration since this is a temporary key
                      expirationSeconds: "15",
                    ),
                  ],
                );
  }
}
