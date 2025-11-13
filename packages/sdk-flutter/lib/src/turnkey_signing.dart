part of 'turnkey.dart';

extension SigningExtension on TurnkeyProvider {
  /// Signs a raw payload using the specified signing key and encoding parameters.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [signWith] The key to sign with.
  /// [payload] The payload to sign.
  /// [encoding] The encoding of the payload.
  /// [hashFunction] The hash function to use.
  Future<v1SignRawPayloadResult> signRawPayload(
      {required String signWith,
      required String payload,
      required v1PayloadEncoding encoding,
      required v1HashFunction hashFunction}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.signRawPayload(
        input: TSignRawPayloadBody(
      signWith: signWith,
      payload: payload,
      encoding: encoding,
      hashFunction: hashFunction,
    ));

    final signRawPayloadResult = response.activity.result.signRawPayloadResult;
    if (signRawPayloadResult == null) {
      throw Exception("Failed to sign raw payload");
    }
    return signRawPayloadResult;
  }

  /// Signs a plaintext message using the specified wallet account.
  ///
  /// Automatically determines the payload encoding and hash function based on
  /// the wallet account's address format, unless explicitly overridden.
  /// Optionally applies the Ethereum signed message prefix before signing.
  /// If you need more control over the signing process, consider using [signRawPayload] directly from the client.
  ///
  /// Throws an [Exception] if there is no active session or if signing fails.
  ///
  /// [message] The UTF-8 plaintext message to sign.
  /// [walletAccount] The wallet account whose signing key will be used.
  /// [encoding] Optional override for the payload encoding. Defaults to the encoding associated with the wallet account's address format.
  /// [hashFunction] Optional override for the hash function. Defaults to the hash function associated with the wallet account's address format.
  /// [addEthereumPrefix] Whether to add the Ethereum message prefix before signing. Defaults to `true` when the address format is Ethereum.
  Future<v1SignRawPayloadResult> signMessage({
    required String message,
    required v1WalletAccount walletAccount,
    v1PayloadEncoding? encoding,
    v1HashFunction? hashFunction,
    bool? addEthereumPrefix,
  }) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    encoding ??= getEncodingType(walletAccount.addressFormat);
    hashFunction ??= getHashFunction(walletAccount.addressFormat);

    final isEthereum =
        walletAccount.addressFormat == v1AddressFormat.address_format_ethereum;

    Uint8List msgBytes = toUtf8Bytes(message);

    // Optionally apply Ethereum EIP-191 prefix
    final bool shouldAddPrefix = isEthereum && (addEthereumPrefix ?? true);
    if (shouldAddPrefix) {
      final prefix = "\x19Ethereum Signed Message:\n${msgBytes.length}";
      final prefixBytes = toUtf8Bytes(prefix);

      final combined = Uint8List(prefixBytes.length + msgBytes.length);
      combined.setRange(0, prefixBytes.length, prefixBytes);
      combined.setRange(prefixBytes.length, combined.length, msgBytes);

      msgBytes = combined;
    }

    // Encode the message according to the payload encoding
    final String encodedMessage = getEncodedMessage(encoding, msgBytes);

    // Build the request body.
    final body = TSignRawPayloadBody(
      signWith: walletAccount.address,
      payload: encodedMessage,
      encoding: encoding,
      hashFunction: hashFunction,
    );

    final response = await requireClient.signRawPayload(input: body);

    final result = response.activity.result.signRawPayloadResult;
    if (result == null || response.activity.failure != null) {
      throw Exception("Failed to sign message, no signed payload returned");
    }

    return result;
  }

  /// Signs a transaction using the specified signing key and transaction parameters.
  ///
  /// Throws an [Exception] if the client or user is not initialized.
  ///
  /// [signWith] The key to sign with.
  /// [unsignedTransaction] The unsigned transaction to sign.
  /// [type] The type of the transaction from the [TransactionType] enum.
  Future<v1SignTransactionResult> signTransaction(
      {required String signWith,
      required String unsignedTransaction,
      required v1TransactionType type}) async {
    if (session == null) {
      throw Exception("No active session found. Please log in first.");
    }

    final response = await requireClient.signTransaction(
        input: TSignTransactionBody(
            signWith: signWith,
            unsignedTransaction: unsignedTransaction,
            type: type));

    final signTransactionResult =
        response.activity.result.signTransactionResult;
    if (signTransactionResult == null) {
      throw Exception("Failed to sign transaction");
    }
    return signTransactionResult;
  }
}