# Changelog

## 1.2.0 — 2026-01-30
### Patch Changes
- Fixed broken OTP flow when "Verification Token Required for Account Lookups" was enabled in the Auth Proxy.
- Synced with latest mono API release v2026.1.4
### Minor Changes
- Policy note is now a required field in policy creation
- Added client signature support for OTP authentication flows


## 1.1.0
### Minor Changes
 - **FEAT**: Added authstate, disabling auto-refresh and better onSuccess for oauth.

## 1.0.1
### Patch Changes
 - Update a dependency to the latest release.

## 1.0.0
### Major Changes
 - Flutter refactor.

## 0.2.2
### Patch Changes
- Added `onInitialized` callback. Runs when initialization is complete and carries an error
- Added `ready` state. A state that can be listened to if session initialization is completes succesfully or fails.
- Exposed `initializeSessions` method. Called automatically when the app launches. Retrieves all stored session keys, validates their expiration status, removes expired sessions, and schedules expiration timers for active ones.

## 0.2.1
### Patch Changes
- Added `onSessionEmpty` callback. Runs when the app first launches and there is no active session.

## 0.2.0
### Patch Changes
- Added `createSessionFromEmbeddedKey`: Creates a new session using an embedded private key and securely stores it (Useful for "one-tap-passkey" sign ups. See demo app for more details).
- Added `refreshSession`: Refreshes an existing session by creating a new read/write session.
- Added optional param `sessionKey: string` to `createEmbeddedKey`. Key to use for storing the embedded key. Defaults to `StorageKeys.EmbeddedKey`.
- Added optional param `isCompressed: bool`. Whether to return the compressed or uncompressed public key. Defaults to false.
- Added `handleGoogleOAuth`: New abstraction for Google OAuth authentication flow. Initiates an in-app browser OAuth flow with the provided credentials and parameters. After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL and invokes the provided onSuccess callback.
### Minor Changes
> [!CAUTION]
> **BREAKING:**
- [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview) is now required to be installed in your project.

## 0.1.0 - Initial Release

- Initial release. Client side abstracted functions for Turnkey-powered Flutter apps

