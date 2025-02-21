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

class TurnkeyProvider with ChangeNotifier {
  final Map<String, bool> _loading = {};
  String? _errorMessage;
  User? _user;
  Wallet? _selectedWallet;
  String? _selectedAccount;
  TurnkeyClient? _client;

  final SessionProvider sessionProvider;
  final TurnkeyConfig config;

  TurnkeyProvider({required this.sessionProvider, required this.config}) {
    sessionProvider.addListener(_onSessionUpdate);
    _onSessionUpdate();
  }

  bool isLoading(String key) => _loading[key] ?? false;
  String? get errorMessage => _errorMessage;
  User? get user => _user;
  Wallet? get selectedWallet => _selectedWallet;
  String? get selectedAccount => _selectedAccount;

  void setLoading(String key, bool loading) {
    _loading[key] = loading;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSelectedWallet(Wallet? wallet, {bool? updateAccount = true}) {
    _selectedWallet = wallet;
    if (updateAccount == true) _selectedAccount = wallet?.accounts.first;
    notifyListeners();
  }

  void setSelectedAccount(String? account) {
    _selectedAccount = account;
    notifyListeners();
  }

  Future<void> _onSessionUpdate() async {
    final session = sessionProvider.session;

    if (session != null) {
      try {
        final stamper = ApiKeyStamper(
          ApiKeyStamperConfig(
              apiPrivateKey: session.privateKey,
              apiPublicKey: session.publicKey),
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

          setSelectedWallet(wallets.first);
          setSelectedAccount(wallets.first.accounts.first);

          notifyListeners();
        }
      } catch (error) {
        setError(error.toString());
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    await sessionProvider.clearSession();
  }

  Future<turnkeyTypes.ActivityResponse> signRawPayload(BuildContext context,
      turnkeyTypes.SignRawPayloadIntentV2 parameters) async {
    setLoading('signRawPayload', true);
    setError(null);

    try {
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
    } catch (error) {
      setError(error.toString());
      throw Exception(error.toString());
    } finally {
      setLoading('signRawPayload', false);
    }
  }

  Future<void> createWallet(
      BuildContext context, turnkeyTypes.CreateWalletIntent parameters) async {
    setLoading('createWallet', true);
    setError(null);

    try {
      if (_client == null || user == null) {
        throw Exception("Client or user not initialized");
      }

      final response = await _client!.createWallet(
          input: turnkeyTypes.CreateWalletRequest(
              type:
                  turnkeyTypes.CreateWalletRequestType.activityTypeCreateWallet,
              timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
              organizationId: user!.organizationId,
              parameters: parameters));

      if (response.activity.result.createWalletResult?.walletId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success! Wallet created.')),
        );
        _onSessionUpdate();
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('createWallet', false);
    }
  }

  Future<void> importWallet(
      BuildContext context,
      String mnemonic,
      String walletName,
      List<turnkeyTypes.WalletAccountParams> accounts) async {
    setLoading('importWallet', true);
    setError(null);

    try {
      if (_client == null || user == null) {
        throw Exception("Client or user not initialized");
      }
      final initResponse = await _client!.initImportWallet(
          input: turnkeyTypes.InitImportWalletRequest(
              type: turnkeyTypes
                  .InitImportWalletRequestType.activityTypeInitImportWallet,
              timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
              organizationId: user!.organizationId,
              parameters:
                  turnkeyTypes.InitImportWalletIntent(userId: user!.id)));

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
              type:
                  turnkeyTypes.ImportWalletRequestType.activityTypeImportWallet,
              timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
              organizationId: user!.organizationId,
              parameters: turnkeyTypes.ImportWalletIntent(
                  userId: user!.id,
                  walletName: walletName,
                  encryptedBundle: encryptedBundle,
                  accounts: accounts)));

      if (response.activity.result.importWalletResult?.walletId != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Success! Wallet imported.')),
        );
        _onSessionUpdate();
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('importWallet', false);
    }
  }

  Future<String> exportWallet(BuildContext context, String walletId) async {
    setLoading('exportWallet', true);
    try {
      if (_client == null || user == null) {
        throw Exception("Client or user not initialized");
      }

      final targetPublicKey = await sessionProvider.createEmbeddedKey();

      final response = await _client!.exportWallet(
          input: turnkeyTypes.ExportWalletRequest(
              type:
                  turnkeyTypes.ExportWalletRequestType.activityTypeExportWallet,
              timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
              organizationId: user!.organizationId,
              parameters: turnkeyTypes.ExportWalletIntent(
                  walletId: walletId, targetPublicKey: targetPublicKey)));
      final exportBundle =
          response.activity.result.exportWalletResult?.exportBundle;

      final embeddedKey = await sessionProvider.getEmbeddedKey();
      if (exportBundle == null || embeddedKey == null) {
        throw Exception("Export bundle, embedded key, or user not initialized");
      }

      final export = await decryptExportBundle(
          exportBundle: exportBundle,
          embeddedKey: embeddedKey,
          organizationId: user!.organizationId,
          returnMnemonic: true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Success! Wallet exported.')),
      );
      return export;
    } catch (error) {
      setError(error.toString());
      throw Exception(error.toString());
    } finally {
      setLoading('exportWallet', false);
    }
  }
}
