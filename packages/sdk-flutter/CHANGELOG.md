## 0.2.1

- Added `onSessionEmpty` callback. Runs when the app first launches and there is no active session.

## 0.2.0

- Added `createSessionFromEmbeddedKey`: Creates a new session using an embedded private key and securely stores it (Useful for "one-tap-passkey" sign ups. See demo app for more details).
- Added `refreshSession`: Refreshes an existing session by creating a new read/write session.
- Added optional param `sessionKey: string` to `createEmbeddedKey`. Key to use for storing the embedded key. Defaults to `StorageKeys.EmbeddedKey`.
- Added optional param `isCompressed: bool`. Whether to return the compressed or uncompressed public key. Defaults to false.
- Added `handleGoogleOAuth`: New abstraction for Google OAuth authentication flow. Initiates an in-app browser OAuth flow with the provided credentials and parameters. After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL and invokes the provided onSuccess callback.

**BREAKING:**

- [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview) is now required to be installed in your project.

## 0.1.0

- Initial release. Client side abstracted functions for Turnkey-powered Flutter apps
