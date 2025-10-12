import 'dart:async';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'package:turnkey_http/__generated__/models.dart';

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

  /// Set this to true when calling from Web; used only to build a default authenticator name.
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

  // If original TS returned [] when none were provided, mirror that:
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
            curveType: k.curveType!, // safe due to where(...)
            expirationSeconds: k.expirationSeconds, // nullable -> omitted in toJson if you drop nulls
          ))
      .toList();

  final List<v1ApiKeyParamsV2> apiKeysOrEmpty =
      (createSubOrgParams?.apiKeys?.isNotEmpty ?? false)
          ? apiKeys
          : <v1ApiKeyParamsV2>[];

  // --- oauth providers ---
  // If your ProxyTSignupBody expects v1OauthProviderParams instead of Provider,
  // map them here accordingly.
  final List<v1OauthProviderParams> oauthProvidersOrEmpty =
      (createSubOrgParams?.oauthProviders?.isNotEmpty ?? false)
          ? createSubOrgParams!.oauthProviders as List<v1OauthProviderParams>
          : const [];

  // --- wallet mapping ---
  // TS: wallet: { walletName, accounts } from customWallet { walletName, walletAccounts }
  final wallet = (createSubOrgParams?.customWallet != null)
      ? v1WalletParams(
          walletName: createSubOrgParams!.customWallet!.walletName,
          accounts: createSubOrgParams.customWallet!.walletAccounts,
        )
      : null;

  // --- userName defaulting (TS: userName || userEmail || `user-${now}`) ---
  final userName = createSubOrgParams?.userName?.isNotEmpty == true
      ? createSubOrgParams!.userName!
      : (createSubOrgParams?.userEmail?.isNotEmpty == true
          ? createSubOrgParams!.userEmail!
          : 'user-$now');

  // --- organizationName defaulting (TS: subOrgName || `sub-org-${now}`) ---
  final orgName = createSubOrgParams?.subOrgName?.isNotEmpty == true
      ? createSubOrgParams!.subOrgName!
      : 'sub-org-$now';

  return ProxyTSignupBody(
    userName: userName,
    // include only if present in TS (null will be omitted by toJson if you drop nulls)
    userEmail: createSubOrgParams?.userEmail,
    // TS forces [] when not provided
    authenticators: authenticatorsOrEmpty,
    userPhoneNumber: createSubOrgParams?.userPhoneNumber,
    userTag: createSubOrgParams?.userTag,
    organizationName: orgName,
    verificationToken: createSubOrgParams?.verificationToken,
    // TS forces [] when not provided
    apiKeys: apiKeysOrEmpty,
    // TS forces [] when not provided
    oauthProviders: oauthProvidersOrEmpty,
    // TS includes wallet only if provided
    wallet: wallet,
  );
}
