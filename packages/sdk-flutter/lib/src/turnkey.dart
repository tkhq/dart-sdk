import 'dart:async';
import 'package:flutter/material.dart';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_crypto/turnkey_crypto.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart'
    as turnkeyTypes;
import 'package:turnkey_http/base.dart';
import 'package:turnkey_http/turnkey_http.dart';
import 'package:turnkey_sdk_flutter/src/types.dart';
import 'package:turnkey_sessions/turnkey_sessions.dart';

//TODO: Parity with react-native. Add rest of functions and make more general
class TurnkeyProvider with ChangeNotifier {
  User? _user;
  TurnkeyClient? _client;

  final TurnkeyConfig config;
  final SessionProvider _sessionProvider = SessionProvider();

  TurnkeyProvider({required this.config}) {
    _sessionProvider.addListener(_onSessionUpdate);
  }

  User? get user => _user;
  SessionProvider get sessionProvider => this._sessionProvider;
  Session? get session => this._sessionProvider.session;

  // Exposing SessionProvider functions.
  // TODO: Maybe we shouldnt do this. Hard to update :(
  Future<String> createEmbeddedKey() async {
    return await _sessionProvider.createEmbeddedKey();
  }

  Future<String?> getEmbeddedKey({bool deleteKey = true}) async {
    return await _sessionProvider.getEmbeddedKey(deleteKey: deleteKey);
  }

  Future<Session> createSession(String bundle,
      {int expirySeconds = 900, bool notifyListeners = true}) async {
    return await _sessionProvider.createSession(bundle,
        expirySeconds: expirySeconds, notifyListeners: notifyListeners);
  }

  Future<Session?> getSession() async {
    return await _sessionProvider.getSession();
  }

  Future<void> clearSession({bool notifyListeners = true}) async {
    return await _sessionProvider.clearSession(
        notifyListeners: notifyListeners);
  }

  Future<void> checkSession({bool notifyListeners = true}) async {
    return await _sessionProvider.checkSession(
        notifyListeners: notifyListeners);
  }

  Future<void> _onSessionUpdate() async {
    print('Session updated');
    final session = this.session;

    if (session != null) {
      final stamper = ApiKeyStamper(
        ApiKeyStamperConfig(
            apiPrivateKey: session.privateKey, apiPublicKey: session.publicKey),
      );

      final client = TurnkeyClient(
        config: THttpConfig(baseUrl: config.apiBaseUrl),
        stamper: stamper,
      );
      _client = client;

      final whoami = await client.getWhoami(
          input: turnkeyTypes.GetWhoamiRequest(
        organizationId: config.organizationId,
      ));

      if (whoami.userId != null && whoami.organizationId != null) {
        final walletsResponse = await client.getWallets(
          input: turnkeyTypes.GetWalletsRequest(
              organizationId: whoami.organizationId),
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
                .map<String>((account) => (account.address))
                .toList(),
          );
        }).toList());

        final user = userResponse.user;

        _user = User(
          id: user.userId,
          userName: user.userName,
          email: user.userEmail,
          phoneNumber: user.userPhoneNumber,
          organizationId: whoami.organizationId,
          wallets: wallets,
        );
        notifyListeners();
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await this.clearSession();
  }

  Future<turnkeyTypes.ActivityResponse> signRawPayload(BuildContext context,
      turnkeyTypes.SignRawPayloadIntentV2 parameters) async {
    if (_client == null || user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.signRawPayload(
        input: turnkeyTypes.SignRawPayloadRequest(
            type: turnkeyTypes
                .SignRawPayloadRequestType.activityTypeSignRawPayloadV2,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: user!.organizationId,
            parameters: parameters));
    return response;
  }

  Future<void> createWallet(
      BuildContext context, turnkeyTypes.CreateWalletIntent parameters) async {
    if (_client == null || user == null) {
      throw Exception("Client or user not initialized");
    }

    final response = await _client!.createWallet(
        input: turnkeyTypes.CreateWalletRequest(
            type: turnkeyTypes.CreateWalletRequestType.activityTypeCreateWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: user!.organizationId,
            parameters: parameters));

    if (response.activity.result.createWalletResult?.walletId != null) {
      _onSessionUpdate();
    }
  }

  Future<void> importWallet(
      BuildContext context,
      String mnemonic,
      String walletName,
      List<turnkeyTypes.WalletAccountParams> accounts) async {
    if (_client == null || user == null) {
      throw Exception("Client or user not initialized");
    }
    final initResponse = await _client!.initImportWallet(
        input: turnkeyTypes.InitImportWalletRequest(
            type: turnkeyTypes
                .InitImportWalletRequestType.activityTypeInitImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: user!.organizationId,
            parameters: turnkeyTypes.InitImportWalletIntent(userId: user!.id)));

    final importBundle =
        initResponse.activity.result.initImportWalletResult?.importBundle;

    if (importBundle == null) {
      throw Exception("Failed to get import bundle");
    }

    final encryptedBundle = await encryptWalletToBundle(
      mnemonic: mnemonic,
      importBundle: importBundle,
      userId: user!.id,
      organizationId: user!.organizationId,
    );

    final response = await _client!.importWallet(
        input: turnkeyTypes.ImportWalletRequest(
            type: turnkeyTypes.ImportWalletRequestType.activityTypeImportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: user!.organizationId,
            parameters: turnkeyTypes.ImportWalletIntent(
                userId: user!.id,
                walletName: walletName,
                encryptedBundle: encryptedBundle,
                accounts: accounts)));

    if (response.activity.result.importWalletResult?.walletId != null) {
      _onSessionUpdate();
    }
  }

  Future<String> exportWallet(BuildContext context, String walletId) async {
    if (_client == null || user == null) {
      throw Exception("Client or user not initialized");
    }

    final targetPublicKey = await this.createEmbeddedKey();

    final response = await _client!.exportWallet(
        input: turnkeyTypes.ExportWalletRequest(
            type: turnkeyTypes.ExportWalletRequestType.activityTypeExportWallet,
            timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
            organizationId: user!.organizationId,
            parameters: turnkeyTypes.ExportWalletIntent(
                walletId: walletId, targetPublicKey: targetPublicKey)));
    final exportBundle =
        response.activity.result.exportWalletResult?.exportBundle;

    final embeddedKey = await this.getEmbeddedKey();
    if (exportBundle == null || embeddedKey == null) {
      throw Exception("Export bundle, embedded key, or user not initialized");
    }

    final export = await decryptExportBundle(
        exportBundle: exportBundle,
        embeddedKey: embeddedKey,
        organizationId: user!.organizationId,
        returnMnemonic: true);

    return export;
  }
}
