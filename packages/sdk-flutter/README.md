# Turnkey SDK Flutter

The `turnkey_sdk_flutter` package simplifies the integration of the Turnkey API into Flutter applications. It provides secure session management, authentication, and cryptographic operations using [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage), [`turnkey_crypto`](../crypto/), [`turnkey_api_key_stamper`](../api-key-stamper/) and [`turnkey_http`](../http/)

---

## **Installation**

- Install the following dependencies in your Flutter project:
  - [`provider`](https://pub.dev/packages/provider)
  - [`flutter_inappwebview`](https://pub.dev/packages/flutter_inappwebview)
  - [`turnkey_crypto`](../crypto/)
  - [`turnkey_api_key_stamper`](../api-key-stamper/)
  - [`turnkey_http`](../http/)
  - `turnkey_sdk_flutter` (this package)
- Ensure your app is properly configured for secure storage and authentication.

---

## **Usage**

### **Wrapping Your App with the Provider**

Using the [`provider`](https://pub.dev/packages/provider) package, wrap your app with a `MultiProvider` and add the `TurnkeyProvider`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {

  void onSessionSelected(Session session) {
    if (isValidSession(session)) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      print('Logged in! Redirecting to the dashboard');
    }
  }

  void onSessionCleared(Session session) {
    navigatorKey.currentState?.pushReplacementNamed('/');

    print('Logged out. Please login again.');
  }

  void onSessionCreated(Session session){
    print('Session ${session.key} has been created!');
  }

  void onSessionExpired(Session session){
    print('Session ${session.key} has expired!');
  }

  void onSessionEmpty(){
    print('There is no active session!');
  }

  void onInitialized(Object? error) {
    if (error != null) {
      print('Turnkey initialization failed: $error');
    } else {
      print('Turnkey initialized successfully');
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TurnkeyProvider(
                config: TurnkeyConfig(
                    apiBaseUrl: EnvConfig.turnkeyApiUrl,
                    organizationId: EnvConfig.organizationId,
                    onSessionSelected: onSessionSelected,
                    onSessionCleared: onSessionCleared,
                    onSessionCreated: onSessionCreated,
                    onSessionExpired: onSessionExpired,
                    onSessionEmpty:   onSessionEmpty,
                    onInitialized:    onInitialized))),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
```

---

## **Session Storage**

To enable secure authentication, the following storage keys are used:

- `@turnkey/embedded-key`: Stores the private key that corresponds to the public key used when initiating the session request to Turnkey.
- `@turnkey/session`: Default session storage key, storing the session credentials, including the private key, public key, and expiry time, which are decrypted from the credential bundle after a session is created.
- `@turnkey/session-keys`: Stores the list of stored session keys.
- `@turnkey/selected-session`: Stores the currently selected session key.

---

## **Functions Provided by the Turnkey Provider**

### **Session Management**

- `createEmbeddedKey()`: Generates a new embedded key pair and securely stores the private key.
- `createSession({ bundle, expirationSeconds?, sessionKey? })`: Creates a session. [(API Docs)](https://docs.turnkey.com/api#tag/Sessions/operation/CreateReadWriteSession)
  - If `sessionKey` is provided, the session will be stored under that key in secure storage.
  - If no session exists, the first session created is **automatically selected**.
  - If a session with the same `sessionKey` already exists in secure storage, an error is thrown.
- `setSelectedSession({ sessionKey })`: Selects a session by its key (Used when handling multiple sessions).
- `clearSession({ sessionKey? })`: Removes the specified session from secure storage. If no `sessionKey` is provided, the currently selected session is removed.
- `clearAllSessions()`: Clears all sessions from secure storage.
- `initializeSessions()`: Called automatically when the app launches. Retrieves all stored session keys, validates their expiration status, removes expired sessions, and schedules expiration timers for active ones.
- `ready`: A state that can be listened to if session initialization is completes succesfully or fails.

---

### **User Management**

- `updateUser({ email?, phone? })`: Updates the user's email and/or phone number. [(API Docs)](https://docs.turnkey.com/api#tag/Users/operation/UpdateUser)
- `refreshUser()`: Fetches the latest user data. [(API Docs)](https://docs.turnkey.com/api#tag/Sessions)

---

### **Wallet Management**

- `createWallet({ walletName, accounts, mnemonicLength? })`: Creates a wallet. [(API Docs)](https://docs.turnkey.com/api#tag/Wallets/operation/CreateWallet)
- `importWallet({ walletName, mnemonic, accounts })`: Imports a wallet. [(API Docs)](https://docs.turnkey.com/api#tag/Wallets/operation/ImportWallet)
- `exportWallet({ walletId })`: Exports a wallet mnemonic. [(API Docs)](https://docs.turnkey.com/api#tag/Wallets/operation/ExportWallet)

---

### **Transaction Signing**

- `signRawPayload({ signWith, payload, encoding, hashFunction })`: Signs a payload. [(API Docs)](https://docs.turnkey.com/api#tag/Signing/operation/SignRawPayload)

- `signTransaction({ signWith, unsignedTransaction, type})` Signs a transaction. [(API Docs)](https://docs.turnkey.com/api#tag/Signing/operation/SignTransaction)

---

### **OAuth**

- `handleGoogleOAuth({ clientId, redirectUri, nonce, scheme, onIdToken })`: Handles the Google OAuth authentication flow.

---

## **Handling Multiple Sessions**

Most users won't need multiple sessions, but if your app requires switching between multiple sessions, here’s what you need to know:

This SDK supports **multiple sessions**, allowing you to create and switch between different session keys using `setSelectedSession({ sessionKey })`. When a session is selected, the client, user, and session information are updated accordingly, so that all subsequent function calls (like `updateUser` or `createWallet`) apply to the selected session.

- #### Creating a session with a custom key:
  - You can pass a `sessionKey` when calling `createSession`. If provided, the session will be stored in secure storage under that ID, allowing for multiple sessions.
- **Switching sessions**: Use `setSelectedSession({ sessionKey })` to switch between stored sessions. The client, user, and session information will automatically update.
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

## Template

For the quickest and easiest way to create a Turnkey-powered Flutter app, check out our [Turnkey Flutter Template](https://github.com/tkhq/flutter_template/).

## Example App

For a fully functional Flutter demo app that leverages Turnkey's Dart/Flutter packages, check out our [Turnkey Flutter Demo App](./examples/flutter-demo-app).
