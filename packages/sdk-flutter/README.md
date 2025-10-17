# Turnkey SDK Flutter

The `turnkey_sdk_flutter` package simplifies the integration of the Turnkey API into Flutter applications. It provides secure session management, authentication, and cryptographic operations using [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage), [`turnkey_crypto`](../crypto/), [`turnkey_api_key_stamper`](../api-key-stamper/) and [`turnkey_http`](../http/)

---

## **Installation**

Add the following dependencies to your Flutter project:
```
flutter pub add turnkey_sdk_flutter
```

Ensure your app is properly configured for secure storage and deep linking for OAuth redirects (if applicable).

---

## **Usage**

### **Wrapping Your App with the Provider**

Wrap your root app with TurnkeyProvider using provider:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TurnkeyProvider(
            config: TurnkeyConfig(
              apiBaseUrl: '<your_api_base_url>',
              organizationId: '<your_organization_id>',
              appScheme: '<your_app_scheme>',
              onSessionCreated: (session) => print('Session created: ${session.key}'),
              onSessionSelected: (session) => print('Session selected: ${session.key}'),
              onSessionExpired: (session) => print('Session expired: ${session.key}'),
              onSessionCleared: (session) => print('Session cleared: ${session.key}'),
              onInitialized: (err) => print(err ?? 'Initialized successfully'),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
```

---

## Session Storage

Session data is stored across two layers:

###  Local Storage (Hive)

Used for **non-sensitive session metadata** such as JWT, expiry, organization, and active session keys.

| Key                           | Description                               |
| ----------------------------- | ----------------------------------------- |
| `@turnkey/all-session-keys`   | List of all stored session keys           |
| `@turnkey/active-session-key` | Tracks the currently active session       |
| `@turnkey/session`            | Stores session data and metadata from JWT |

###  Secure Storage (flutter_secure_storage)

Used for **private cryptographic material**, such as key pairs for signing.

| Key                     | Description                                            |
| ----------------------- | ------------------------------------------------------ |
| `@turnkey/embedded-key` | Embedded key pair used for signing                     |
| `<publicKey>`           | Stores the private key associated with that public key |

---

## Whats Provided by the Turnkey Provider?

Below is the full list of **publicly exposed functions and state** available from the `TurnkeyProvider` class:

### Exposed State

These properties are automatically updated when you use the SDK functions:

| Property  | Description                                                                                              |
| --------- | -------------------------------------------------------------------------------------------------------- |
| `session` | The currently active session, updated automatically on login, refresh, or clear.                         |
| `client`  | The active `TurnkeyClient` instance tied to the current session.                                         |
| `user`    | The user data retrieved for the current session. Automatically refreshed after login or user changes.    |
| `wallets` | The wallets fetched or created during user operations, refreshed when new wallets are added or imported. |

### Exposed Functions

#### **Session Management**

* `storeSession({ required String sessionJwt, String? sessionKey })`
* `getSession({ String? sessionKey })`
* `getAllSessions()`
* `setActiveSession({ required String sessionKey })`
* `getActiveSessionKey()`
* `refreshSession({ String? sessionKey, String expirationSeconds, String? publicKey, bool invalidateExisting })`
* `clearSession({ String? sessionKey })`
* `clearAllSessions()`
* `createApiKeyPair({ String? externalPublicKey, String? externalPrivateKey, bool isCompressed, bool storeOverride })`
* `deleteApiKeyPair(String publicKey)`
* `deleteUnusedKeyPairs()`
* `ready` — A `Future` that completes when initialization finishes.

#### **User Management**

* `refreshUser()`

#### **Wallet Management**

* `refreshWallets()`
* `createWallet({ required String walletName, required List<v1WalletAccountParams> accounts, int? mnemonicLength })`
* `importWallet({ required String mnemonic, required String walletName, required List<v1WalletAccountParams> accounts })`
* `exportWallet({ required String walletId })`

#### **Transaction Signing**

* `signRawPayload({ required String signWith, required String payload, required v1PayloadEncoding encoding, required v1HashFunction hashFunction })`
* `signTransaction({ required String signWith, required String unsignedTransaction, required v1TransactionType type })`

#### **Authentication - OTP**

* `initOtp({ required OtpType otpType, required String contact })`
* `verifyOtp({ required String otpCode, required String otpId, required String contact, required OtpType otpType })`
* `loginWithOtp({ required String verificationToken, String? organizationId, bool invalidateExisting, String? publicKey, String? sessionKey })`
* `signUpWithOtp({ required String verificationToken, required String contact, required OtpType otpType, String? publicKey, String? sessionKey, CreateSubOrgParams? createSubOrgParams, bool invalidateExisting })`
* `loginOrSignUpWithOtp({ required String otpId, required String otpCode, required String contact, required OtpType otpType, String? publicKey, bool invalidateExisting, String? sessionKey, CreateSubOrgParams? createSubOrgParams })`

#### **Authentication - OAuth**

* `loginWithOAuth({ required String oidcToken, required String publicKey, bool? invalidateExisting, String? sessionKey })`
* `signUpWithOAuth({ required String oidcToken, required String publicKey, required String providerName, String? sessionKey, CreateSubOrgParams? createSubOrgParams })`
* `loginOrSignUpWithOAuth({ required String oidcToken, required String publicKey, String? providerName, String? sessionKey, bool? invalidateExisting, CreateSubOrgParams? createSubOrgParams })`
* `handleGoogleOAuth({ String? clientId, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`
* `handleAppleOAuth({ String? clientId, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`
* `handleXOAuth({ String? clientId, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`
* `handleDiscordOAuth({ String? clientId, String? originUri, String? redirectUri, String? sessionKey, String? invalidateExisting, void Function(String oidcToken)? onSuccess })`

#### **Authentication - Passkey**

* `loginWithPasskey({ required String rpId, String? sessionKey, String expirationSeconds, String? organizationId, String? publicKey })`
* `signUpWithPasskey({ required String rpId, String? sessionKey, String expirationSeconds, String? organizationId, String? passkeyDisplayName, CreateSubOrgParams? createSubOrgParams, bool invalidateExisting })`

> **❗Note**: If a specific Turnkey action isn't listed here, it doesn't mean it's unsupported and it usually just means there's little benefit to providing a sugared wrapper for it. You can still use the exported `TurnkeyClient` to call any Turnkey API endpoint directly whenever needed!

---

## **Handling Multiple Sessions**

Most users won't need multiple sessions, but if your app requires switching between multiple sessions, here’s what you need to know:

This SDK supports **multiple sessions**, allowing you to create and switch between different session keys using `setActiveSession({ sessionKey })`. When a session is selected, the client, user, wallets, and session information are updated accordingly, so that all subsequent function calls (like `importWallet` or `createWallet`) apply to the selected session.

- #### Creating a session with a custom key:
  - You can pass a `sessionKey` when calling `storeSession`. If provided, the session will be stored in secure storage under that ID, allowing for multiple sessions.
- **Switching sessions**: Use `setActiveSession({ sessionKey })` to switch between stored sessions. The client, user, wallets, and session information will automatically update.
- **Session expiry management**: Each session has an expiry time, and expired sessions will be automatically cleared.
- **Callbacks for session events**:
  - `onSessionCreated`: Called when a session is created.
  - `onSessionSelected`: Called when a session is selected.
  - `onSessionExpired`: Called when a session expires.
  - `onSessionCleared`: Called when a session is cleared.
  - `onSessionEmpty`: Called when the app launches and there is no active session.
  - `onInitialized`: Called when the TurnkeyProvider's initialization is complete. An error is carried in the parameters if something goes wrong.

### When are multiple sessions useful?

Using multiple sessions can be beneficial when enabling different authentication methods for various operations. For example, you might authenticate a user with OTP for login while using a passkey-based session for signing transactions.

---

## Example App

For a fully functional Flutter demo app that leverages Turnkey's Dart/Flutter packages, check out our [Turnkey Flutter Demo App](./examples/flutter-demo-app).
