import 'dart:async';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

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
      input: GetWhoamiRequest(
    organizationId: organizationId,
  ));

  if (whoami.userId != null && whoami.organizationId != null) {
    final walletsResponse = await client.getWallets(
      input: GetWalletsRequest(organizationId: whoami.organizationId),
    );
    final userResponse = await client.getUser(
      input: GetUserRequest(
        organizationId: whoami.organizationId,
        userId: whoami.userId,
      ),
    );

    final wallets =
        await Future.wait(walletsResponse.wallets.map((wallet) async {
      final accountsResponse = await client.getWalletAccounts(
          input: GetWalletAccountsRequest(
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

/// Creates an authenticated Turnkey client instance.
///
/// Generates an `ApiKeyStamper` using the provided public and private keys.
/// Instantiates a `TurnkeyClient` with the configured API base URL.
///
/// [publicKey] The public key used for authentication.
/// [privateKey] The private key used for authentication.
/// [apiBaseUrl] The base URL of the Turnkey API.
/// Returns a new `TurnkeyClient` instance.
TurnkeyClient createClient(String publicKey, String privateKey, apiBaseUrl) {
  final stamper = ApiKeyStamper(
    ApiKeyStamperConfig(apiPrivateKey: privateKey, apiPublicKey: publicKey),
  );

  return TurnkeyClient(
    config: THttpConfig(baseUrl: apiBaseUrl),
    stamper: stamper,
  );
}
