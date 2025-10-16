import 'dart:async';
import 'dart:convert';
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
Future<User?> fetchUser(TurnkeyClient client, String organizationId) async {
  final whoami = await client.getWhoami(
      input: TGetWhoamiBody(
    organizationId: organizationId,
  ));

  if (whoami.userId != null && whoami.organizationId != null) {
    final walletsResponse = await client.getWallets(
      input: TGetWalletsBody(organizationId: whoami.organizationId),
    );
    final userResponse = await client.getUser(
      input: TGetUserBody(
        organizationId: whoami.organizationId,
        userId: whoami.userId,
      ),
    );

    final wallets =
        await Future.wait(walletsResponse.wallets.map((wallet) async {
      final accountsResponse = await client.getWalletAccounts(
          input: TGetWalletAccountsBody(
              organizationId: whoami.organizationId,
              walletId: wallet.walletId));
      return Wallet(
        name: wallet.walletName,
        id: wallet.walletId,
        accounts: accountsResponse.accounts
            .map((account) => WalletAccount(
                id: account.walletAccountId,
                curve: account.curve,
                pathFormat: account.pathFormat,
                path: account.path,
                addressFormat: account.addressFormat,
                address: account.address,
                createdAt: account.createdAt,
                updatedAt: account.updatedAt))
            .toList(),
      );
    }).toList());

    final user = userResponse.user;

    return User(
      id: user.userId,
      userName: user.userName,
      email: user.userEmail,
      phoneNumber: user.userPhoneNumber,
      organizationId: whoami.organizationId,
      wallets: wallets,
    );
  }
  return null;
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
  final List<v1AuthenticatorParamsV2> authenticators = (createSubOrgParams?.authenticators ?? const [])
      .map((a) => v1AuthenticatorParamsV2(
            authenticatorName: (a.authenticatorName == null || a.authenticatorName!.isEmpty)
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
  final List<v1ApiKeyParamsV2> apiKeys = (createSubOrgParams?.apiKeys ?? const [])
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
