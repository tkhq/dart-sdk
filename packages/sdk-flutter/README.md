# Turnkey SDK Flutter

The `turnkey_sdk_flutter` package simplifies the integration of the Turnkey API into Flutter applications. It provides secure session management, authentication, and cryptographic operations using [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage), [`turnkey_crypto`](../crypto/), [`turnkey_api_key_stamper`](../api-key-stamper/) and [`turnkey_http`](../http/)

---

## Example App

![Demo](../../assets/demo.gif)

For a fully functional Flutter demo app that leverages Turnkey's Dart/Flutter packages, check out our [Turnkey Flutter Demo App](./examples/flutter-demo-app).

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
* `importWallet({ required String mnemonic, required String walletName, required List<v1WalletAccountParams> accounts, String? dangerouslyOverrideSignerPublicKey })`
* `exportWallet({ required String walletId, bool? returnMnemonic, String? dangerouslyOverrideSignerPublicKey })`

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
* `handleGoogleOAuth({ String? clientId, List<String>? secondaryClientIds, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`
* `handleAppleOAuth({ List<String>? secondaryClientIds, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })` — native iOS Apple Sign-In via `sign_in_with_apple`. Falls back to a web flow on Android (requires `serviceId` to be configured).
* `handleAppleWebOAuth({ String? clientId, List<String>? secondaryClientIds, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })` — explicit web-based Apple OAuth (formerly `handleAppleOAuth`).
* `handleXOAuth({ String? clientId, List<String>? secondaryClientIds, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`
* `handleDiscordOAuth({ String? clientId, List<String>? secondaryClientIds, String? originUri, String? redirectUri, String? sessionKey, bool? invalidateExisting, void Function(String oidcToken)? onSuccess })`

##### Configuring OAuth providers

```dart
OAuthConfig(
  providers: OAuthProviders(
    google: GoogleOAuthProviderParams(
      primaryClientId: GoogleOAuthPrimaryClientId(webClientId: '<your-google-web-client-id>'),
      secondaryClientIds: const ['<additional-google-client-id>'],
    ),
    apple: AppleOAuthProviderParams(
      primaryClientId: AppleOAuthPrimaryClientId(
        serviceId: '<your-apple-services-id>',
        iosBundleId: '<your-ios-bundle-id>', // required for cross-platform iOS native compatibility
      ),
    ),
    x: XOAuthProviderParams(primaryClientId: '<your-x-client-id>'),
    discord: DiscordOAuthProviderParams(primaryClientId: '<your-discord-client-id>'),
  ),
)
```

##### Cross-platform OAuth (mobile + web)

`secondaryClientIds` on each provider lets you register additional client IDs as authenticators on the user's sub-organization at signup. This allows the same OAuth identity (e.g. one Google account) to resolve to the same Turnkey sub-organization regardless of which platform the user signs in from.

The SDK JWT-decodes the OIDC token from the primary signup to extract `iss`/`sub`, then synthesizes additional `OauthProviderParams` entries — one per secondary `clientId` — sharing the same identity. The result: the sub-org has multiple authenticators registered, one per audience.

##### Native Apple Sign-In

`handleAppleOAuth` uses native Apple Sign-In on iOS via [`sign_in_with_apple`](https://pub.dev/packages/sign_in_with_apple). Consumers must:

1. Add the **Sign in with Apple** capability to the iOS Runner target in Xcode (Signing & Capabilities → + Capability → Sign in with Apple). This adds the `com.apple.developer.applesignin` entitlement.
2. Configure `AppleOAuthProviderParams.primaryClientId.serviceId` if you want `handleAppleOAuth` to work on Android (the package falls back to a web flow there, which requires the Services ID).
3. For cross-platform compatibility — a user signing up on Android being able to log in via native Apple Sign-In on iOS, or vice versa — set both `serviceId` and `iosBundleId` on `AppleOAuthProviderParams`. The SDK registers both as audiences on the sub-org at signup.

If you specifically want the web-based Apple flow on iOS instead of the native sheet, use `handleAppleWebOAuth`.

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

