## 2025-07-03

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sdk_flutter` - `v0.2.2`](#turnkey_sdk_flutter---v022)

---

#### `turnkey_sdk_flutter` - `v0.2.2`

- Added `onInitialized` callback. Runs when initialization is complete and carries an error
- Added `ready` state. A state that can be listened to if session initialization is completes succesfully or fails.
- Exposed `initializeSessions` method. Called automatically when the app launches. Retrieves all stored session keys, validates their expiration status, removes expired sessions, and schedules expiration timers for active ones.

## 2025-06-20

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sdk_flutter` - `v0.2.1`](#turnkey_sdk_flutter---v021)

---

#### `turnkey_sdk_flutter` - `v0.2.1`

- Added `onSessionEmpty` callback. Runs when the app first launches and there is no active session.

## 2025-06-02

### Changes

---

Packages with breaking changes:

- [`turnkey_sdk_flutter` - `v0.2.0`](#turnkey_sdk_flutter---v020)

Packages with other changes:

- [`turnkey_sdk_flutter` - `v0.2.0`](#turnkey_sdk_flutter---v020)

- [`turnkey_http` - `v0.2.0`](#turnkey_http---v020)

- [`turnkey_api_key_stamper` - `v0.1.1`](#turnkey_api_key_stamper---v011)

- [`turnkey_flutter_passkey_stamper` - `v0.1.1`](#turnkey_flutter_passkey_stamper---v011)

---

#### `turnkey_sdk_flutter` - `v0.2.0`

- Added `createSessionFromEmbeddedKey`: Creates a new session using an embedded private key and securely stores it (Useful for "one-tap-passkey" sign ups. See demo app for more details).
- Added `refreshSession`: Refreshes an existing session by creating a new read/write session.
- Added optional param `sessionKey: string` to `createEmbeddedKey`. Key to use for storing the embedded key. Defaults to `StorageKeys.EmbeddedKey`.
- Added optional param `isCompressed: bool`. Whether to return the compressed or uncompressed public key. Defaults to false.
- Added `handleGoogleOAuth`: New abstraction for Google OAuth authentication flow. Initiates an in-app browser OAuth flow with the provided credentials and parameters. After the OAuth flow completes successfully, it extracts the oidcToken from the callback URL and invokes the provided onSuccess callback.

#### `turnkey_http` - `v0.2.0`

- Update per mono v2025.5.5

#### `turnkey_api_key_stamper` - `v0.1.1`

- Update turnkey_http

#### `turnkey_flutter_passkey_stamper` - `v0.1.1`

- Update turnkey_http

## 2025-03-11

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sdk_flutter` - `v0.1.0`](#turnkey_sdk_flutter---v010)

---

#### `turnkey_sdk_flutter` - `v0.1.0`

- Initial release. Client side abstracted functions for Turnkey-powered Flutter apps

## 2025-02-18

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sessions` - `v0.1.2`](#turnkey_sessions---v012)

---

#### `turnkey_sessions` - `v0.1.2`

- **DOCS**: Added auto login / logout example to README.

## 2025-02-18

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sessions` - `v0.1.1`](#turnkey_sessions---v011)

---

#### `turnkey_sessions` - `v0.1.1`

- **FEAT**: Listeners notified when session expires (turnkey_sessions).

## 2025-02-11

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_sessions` - `v0.1.0`](#turnkey_sessions---v010)

---

#### `turnkey_sessions` - `v0.1.0`

## 2025-02-11

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`turnkey_crypto` - `v0.1.1`](#turnkey_crypto---v011)

---

#### `turnkey_crypto` - `v0.1.1`

- Exposed generateP256KeyPair function
