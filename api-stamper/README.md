# Turnkey Dart Api Stamper

This package contains functions to stamp a Turnkey request. It is meant to be used with Turnkey's [`Dart http package`](https://github.com/tkhq/dart-sdk/tree/main/http).

Usage:

```dart
import 'package:turnkey_dart_api_stamper/api_stamper.dart';
import 'package:turnkey_dart_http_client/turnkey_dart_http_client.dart';

final stamper = ApiStamper(
    ApiStamperConfig(
        apiPrivateKey: session.privateKey,
        apiPublicKey: session.publicKey),
);

final httpClient = TurnkeyClient(
  config: THttpConfig(baseUrl: 'https://api.turnkey.com'),
  stamper: stamper,
);
```
