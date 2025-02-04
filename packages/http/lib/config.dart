class TConfig {
  final String apiPublicKey;
  final String apiPrivateKey;
  final String baseUrl;

  TConfig({
    required this.apiPublicKey,
    required this.apiPrivateKey,
    required this.baseUrl,
  });
}

class NullableTConfig {
  String? apiPublicKey;
  String? apiPrivateKey;
  String? baseUrl;

  NullableTConfig({
    this.apiPublicKey,
    this.apiPrivateKey,
    this.baseUrl,
  });
}

final NullableTConfig config = NullableTConfig(
  apiPublicKey: null,
  apiPrivateKey: null,
  baseUrl: null,
);


TConfig getConfig() {
  return TConfig(
    apiPublicKey: assertNonEmptyString(config.apiPublicKey, "apiPublicKey"),
    apiPrivateKey: assertNonEmptyString(config.apiPrivateKey, "apiPrivateKey"),
    baseUrl: assertNonEmptyString(config.baseUrl, "baseUrl"),
  );
}

String assertNonEmptyString(String? input, String name) {
  if (input == null || input.isEmpty) {
    throw ArgumentError('"$name" must be a non-empty string');
  }
  return input;
}