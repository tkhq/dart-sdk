class TConfig {
  /// Turnkey API public key
  final String apiPublicKey;

  /// Turnkey API private key
  final String apiPrivateKey;

  /// Turnkey API base URL
  final String baseUrl;

  TConfig({
    required this.apiPublicKey,
    required this.apiPrivateKey,
    required this.baseUrl,
  });
}

class TBrowserConfig {
  /// Turnkey API base URL
  final String baseUrl;

  TBrowserConfig({
    required this.baseUrl,
  });
}

/// Nullable configuration for `TConfig`
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

/// Nullable configuration for `TBrowserConfig`
class NullableTBrowserConfig {
  String? baseUrl;

  NullableTBrowserConfig({
    this.baseUrl,
  });
}

final NullableTConfig config = NullableTConfig(
  apiPublicKey: null,
  apiPrivateKey: null,
  baseUrl: null,
);

final NullableTBrowserConfig browserConfig = NullableTBrowserConfig(
  baseUrl: null,
);

TConfig getConfig() {
  return TConfig(
    apiPublicKey: assertNonEmptyString(config.apiPublicKey, "apiPublicKey"),
    apiPrivateKey: assertNonEmptyString(config.apiPrivateKey, "apiPrivateKey"),
    baseUrl: assertNonEmptyString(config.baseUrl, "baseUrl"),
  );
}

TBrowserConfig getBrowserConfig() {
  return TBrowserConfig(
    baseUrl: assertNonEmptyString(browserConfig.baseUrl, "baseUrl"),
  );
}

String assertNonEmptyString(String? input, String name) {
  if (input == null || input.isEmpty) {
    throw ArgumentError('"$name" must be a non-empty string');
  }
  return input;
}