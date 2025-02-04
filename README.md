# Turnkey Dart SDK

The Turnkey Dart SDK includes functionality to interact with Turnkey in various contexts and ecosystems. It provides everything you need to develop a fully working Flutter app powered by Turnkey.

## Packages

| Package Name                    | Description                                                                                                                                                                               | Link                                                 |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| turnkey_crypto                  | This package consolidates common cryptographic utilities used across our applications, particularly primitives related to keys, encryption, and decryption in a pure Dart implementation. | [turnkey_crypto](./packages/crypto)                           |
| turnkey_api_stamper             | A Dart package for API stamping functionalities. It is meant to be used with Turnkey's HTTP package.                                                                                      | [turnkey_api_stamper](./packages/api-stamper)                 |
| turnkey_http_client             | A lower-level, fully typed HTTP client for interacting with the Turnkey API.                                                                                                              | [turnkey_http_client](./packages/http)                        |
| turnkey_encoding                | This package contains decoding and encoding functions used by other Turnkey packages.                                                                                                     | [turnkey_encoding](./packages/encoding)                       |
| turnkey_flutter_passkey_stamper | A Flutter package for stamping payloads with passkeys. It is meant to be used with Turnkey's HTTP package.                                                                                | [turnkey_flutter_passkey_stamper](./packages/passkey-stamper) |

## Example App

For a fully functional Flutter demo app that leverages Turnkey's Dart/Flutter packages, head over to the [Turnkey Flutter Demo App](./examples/flutter-demo-app).
