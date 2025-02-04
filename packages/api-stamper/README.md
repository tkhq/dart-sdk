# Turnkey Api Stamper

This package contains functions to stamp a Turnkey request. It is meant to be used with Turnkey's [http package](/packages/http).

Example usage:

```dart
import 'package:turnkey_api_stamper/api_stamper.dart';
import 'package:turnkey_http_client/turnkey_client.dart';

// This stamper produces signatures using the API key pair passed in.
final stamper = ApiStamper(
  apiPublicKey: '...',
  apiPrivateKey: '...',
);

// The Turnkey client uses the passed in stamper to produce signed requests
// and sends them to Turnkey
final client = TurnkeyClient(
  config: THttpConfig(baseUrl: 'https://api.turnkey.com'),
  stamper: stamper,
);

// Now you can make authenticated requests!
final data = await client.getWhoami(
  input: TGetWhoamiRequest(organizationId: '<Your organization id>'),
);
```
