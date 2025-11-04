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

## Code Generation

This package uses custom code generation to create the Turnkey HTTP client from Swagger specifications.

### Quick Start

Generate the client and types:
```bash
make generate
```

### What Gets Generated

The codegen process reads Swagger specs from `lib/swagger/` and generates:

- `lib/__generated__/models.dart` - All type definitions (enums, classes, request/response types)
- `lib/__generated__/services/coordinator/v1/public_api.client.dart` - The TurnkeyClient class

### How It Works

The codegen reads Swagger specifications from `lib/swagger/` and generates:

1. **Type definitions** - All enums, classes, and request/response types with proper serialization
2. **HTTP client** - The `TurnkeyClient` class with methods for each API endpoint
3. **Activity handling** - Automatic envelope wrapping and response transformation for Turnkey activities

#### Codegen Files

Located in `lib/builder/`:

- `codegen.dart` - Entry point that orchestrates the generation process
- `type-generator.dart` - Generates type definitions from Swagger schemas
- `generate.dart` - Generates the HTTP client class
- `constant.dart` - Configuration and constants (activity type mappings, etc.)
- `helper.dart` - Utility functions for code generation
- `types.dart` - Internal types used by the generators

### Clean Generated Files

To remove all generated files:
```bash
make clean
```
