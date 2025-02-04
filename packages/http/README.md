# turnkey_http

A lower-level, fully typed HTTP client for interacting with [Turnkey](https://turnkey.com) API.

Turnkey API documentation lives here: https://docs.turnkey.com.

Example usage:

```dart
import 'package:turnkey_api_key_stamper/api_stamper.dart';
import 'package:turnkey_http/turnkey_client.dart';

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

## HTTP client

`turnkey_http` provides fully typed http client for interacting with the Turnkey API. You can find all available methods [here](/http/lib/__generated__/services/coordinator/v1/public_api.client.dart). The types of input parameters and output responses are also exported for convenience.

The OpenAPI spec that generates the client and types is also [included](/http/lib/swagger/public_api.swagger.json) in the package.

## Generating HTTP Client

To generate the typed HTTP client from the OpenAPI spec, run the following commands:

1. Install dependencies:

   ```bash
   flutter pub get
   ```

2. Run the code generator
   ```bash
   dart run build_runner build
   ```
