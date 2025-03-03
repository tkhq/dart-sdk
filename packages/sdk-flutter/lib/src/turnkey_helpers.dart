import 'dart:async';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart'
    as turnkeyTypes;
import 'package:turnkey_http/base.dart';
import 'package:turnkey_http/turnkey_http.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

Future<User?> fetchUser(TurnkeyClient client, String organizationId) async {
  final whoami = await client.getWhoami(
      input: turnkeyTypes.GetWhoamiRequest(
    organizationId: organizationId,
  ));

  if (whoami.userId != null && whoami.organizationId != null) {
    final walletsResponse = await client.getWallets(
      input:
          turnkeyTypes.GetWalletsRequest(organizationId: whoami.organizationId),
    );
    final userResponse = await client.getUser(
      input: turnkeyTypes.GetUserRequest(
        organizationId: whoami.organizationId,
        userId: whoami.userId,
      ),
    );

    final wallets =
        await Future.wait(walletsResponse.wallets.map((wallet) async {
      final accountsResponse = await client.getWalletAccounts(
          input: turnkeyTypes.GetWalletAccountsRequest(
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

TurnkeyClient createClient(String publicKey, String privateKey, apiBaseUrl) {
  final stamper = ApiKeyStamper(
    ApiKeyStamperConfig(apiPrivateKey: privateKey, apiPublicKey: publicKey),
  );

  return TurnkeyClient(
    config: THttpConfig(baseUrl: apiBaseUrl),
    stamper: stamper,
  );
}
