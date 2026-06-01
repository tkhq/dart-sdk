# Turnkey Dart SDK

The Turnkey Dart SDK includes functionality to interact with Turnkey in various contexts and ecosystems. It provides everything you need to develop a fully working Flutter app powered by Turnkey.

## Packages

| Package Name                    | Description                                                                                                                                                                               | Link                                                          |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| turnkey_sdk_flutter             | An all-in-one package that simplifies the integration of the Turnkey API into Flutter mobile apps.                                                                                        | [turnkey_sdk_flutter](./packages/sdk-flutter/)                |
| turnkey_crypto                  | This package consolidates common cryptographic utilities used across our applications, particularly primitives related to keys, encryption, and decryption in a pure Dart implementation. | [turnkey_crypto](./packages/crypto)                           |
| turnkey_api_key_stamper         | A Dart package for API stamping functionalities. It is meant to be used with Turnkey's HTTP package.                                                                                      | [turnkey_api_key_stamper](./packages/api-key-stamper)         |
| turnkey_http                    | A lower-level, fully typed HTTP client for interacting with the Turnkey API.                                                                                                              | [turnkey_http](./packages/http)                               |
| turnkey_encoding                | This package contains decoding and encoding functions used by other Turnkey packages.                                                                                                     | [turnkey_encoding](./packages/encoding)                       |
| turnkey_flutter_passkey_stamper | A Flutter package for stamping payloads with passkeys. It is meant to be used with Turnkey's HTTP package.                                                                                | [turnkey_flutter_passkey_stamper](./packages/passkey-stamper) |

## Template

For the quickest and easiest way to create a Turnkey-powered Flutter app, check out our [Turnkey Flutter Template](https://github.com/tkhq/flutter_template/).

## Example App

For a fully functional Flutter demo app that leverages Turnkey's Dart/Flutter packages, check out our [Turnkey Flutter Demo App](./examples/flutter-demo-app).

## 🧑‍💻 Development

Guidelines for setting up the workspace, running tests, and contributing code to the Turnkey Dart SDK

### Background: Dart, Flutter, and Melos

- **Dart** is the language and standalone SDK (`dart` CLI, `dart pub`, `dart test`).
- **Flutter** is a UI framework that ships with its own bundled Dart SDK. The `flutter` CLI wraps `dart` and adds mobile/web build tooling. Packages that depend on `sdk: flutter` must be used from the Flutter SDK.
- **Melos** is a monorepo manager for Dart/Flutter. This repo is a workspace of multiple packages (see [Packages](#packages)); melos runs `pub get`, tests, and publishes across all of them in dependency order with a single command.

Because several packages here depend on the Flutter SDK, use `flutter`-based tooling (and the Dart SDK that Flutter bundles) rather than a standalone Dart install.

### Local Setup

**Prerequisites**

- Flutter `>=3.32.0` (bundles Dart `>=3.8.0`, required by `melos ^7.1.1`)
- `make`

Check your versions:

```bash
flutter --version
```

If Dart is older than 3.8, run `flutter upgrade`.

**Bootstrap**

```bash
git clone https://github.com/tkhq/dart-sdk.git
cd dart-sdk
melos bootstrap
```

`melos bootstrap` resolves and links all workspace packages.

**Run tests**

```bash
make test
```

### Creating a Changeset

1. You can create a new changeset by running:
```bash
make changeset
```

2. You will then be prompted to select the packages you need to bump, as well as a title & note to add to the changeset
> [!IMPORTANT]
> The note is what will be added to the changelog describing the changes in the bump

3. Push this changeset along with the changes.

> [!NOTE]
> 🧮 **Pre-1.0 rule:** Dart treats a *minor* bump as breaking (`0.3.x → 0.4.0`).

---

### 🚀 Releasing

1. **Bootstrap workspace**

   ```bash
   melos bootstrap
   ```

2. **Version packages and generate changelogs**

   ```bash
   make prepare-release
   ```

   Auto-bumps versions and updates changelogs from changesets.

3. **Dry-run publish**

   ```bash
   melos publish
   ```

4. **Publish for real**

   ```bash
   melos publish --no-dry-run
   ```

> Melos publishes in dependency order and only releases packages with new versions.
