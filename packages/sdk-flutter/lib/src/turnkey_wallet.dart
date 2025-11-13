part of 'turnkey.dart';

extension WalletExtension on TurnkeyProvider {
  
  /// Refreshes the current wallets data.
  ///
  /// Fetches the latest wallet details from the API using the current session's client.
  /// If the wallet data is successfully retrieved, updates the state with the new wallet information.
  ///
  /// Throws an [Exception] if the session is not initialized.
  Future<void> refreshWallets() async {
    if (config.authConfig?.autoRefreshManagedState == false) {
      return;
    }

    if (session == null) {
      throw Exception("Failed to refresh wallets. No session initialized");
    }
    wallets = await fetchWallets(requireClient, session!.organizationId);
  }

  /// Creates a new wallet with the specified name and accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [walletName] The name of the wallet.
  /// [accounts] The accounts to create in the wallet.
  /// [mnemonicLength] The length of the mnemonic.
  Future<v1Activity> createWallet(
      {required String walletName,
      required List<v1WalletAccountParams> accounts,
      int? mnemonicLength}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.createWallet(
        input: TCreateWalletBody(
      accounts: accounts,
      walletName: walletName,
      mnemonicLength: mnemonicLength,
    ));
    final activity = response.activity;
    if (activity.result.createWalletResult?.walletId != null) {
      await refreshWallets();
    }

    return activity;
  }

  /// Imports a wallet using a provided mnemonic and creates accounts.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [mnemonic] The mnemonic to import.
  /// [walletName] The name of the wallet.
  /// [accounts] The accounts to create in the wallet.
  /// [dangerouslyOverrideSignerPublicKey] An optional public key to override the signer.
  Future<void> importWallet(
      {required String mnemonic,
      required String walletName,
      required List<v1WalletAccountParams> accounts,
      String? dangerouslyOverrideSignerPublicKey}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    // this should never happen
    if (user == null) {
      throw Exception("No user found.");
    }

    final initResponse = await requireClient.initImportWallet(
        input: TInitImportWalletBody(userId: user!.userId));

    final importBundle =
        initResponse.activity.result.initImportWalletResult?.importBundle;

    if (importBundle == null) {
      throw Exception("Failed to get import bundle");
    }

    final encryptedBundle = await encryptWalletToBundle(
      mnemonic: mnemonic,
      importBundle: importBundle,
      userId: user!.userId,
      organizationId: session!.organizationId,
      dangerouslyOverrideSignerPublicKey: dangerouslyOverrideSignerPublicKey,
    );

    final response = await requireClient.importWallet(
        input: TImportWalletBody(
            userId: user!.userId,
            walletName: walletName,
            encryptedBundle: encryptedBundle,
            accounts: accounts));
    final activity = response.activity;
    if (activity.result.importWalletResult?.walletId != null) {
      await refreshWallets();
    }
  }

  /// Exports an existing wallet by decrypting the stored mnemonic phrase.
  ///
  /// Throws an [Exception] if the client, user, or export bundle is not initialized.
  ///
  /// [walletId] The ID of the wallet to export.
  /// [dangerouslyOverrideSignerPublicKey] An optional public key to override the signer.
  Future<String> exportWallet(
      {required String walletId,
      String? dangerouslyOverrideSignerPublicKey,
      bool? returnMnemonic}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final keyPair = await generateP256KeyPair();

    final response = await requireClient.exportWallet(
        input: TExportWalletBody(
            walletId: walletId,
            targetPublicKey: keyPair.publicKeyUncompressed));
    final exportBundle =
        response.activity.result.exportWalletResult?.exportBundle;

    if (exportBundle == null) {
      throw Exception("Export bundle, embedded key, or user not initialized");
    }

    await refreshWallets();

    return await decryptExportBundle(
        exportBundle: exportBundle,
        embeddedKey: keyPair.privateKey,
        organizationId: session!.organizationId,
        dangerouslyOverrideSignerPublicKey: dangerouslyOverrideSignerPublicKey,
        returnMnemonic: returnMnemonic ?? true);
  }
}