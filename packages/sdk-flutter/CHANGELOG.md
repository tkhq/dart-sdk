# Changelog

## 2.0.0 — 2026-05-22
### Patch Changes
- v1Activity.result is now typed v1Result? instead of v1Result. The Turnkey API omits the result field when an activity is pending consensus approval (ACTIVITY_STATUS_CONSENSUS_NEEDED), which previously caused a runtime null-cast crash.
### Major Changes
- ### `initOtp`

**What changed:** Now returns an `InitOtpResult` object instead of a plain `otpId` string. The result includes the new `otpEncryptionTargetBundle` required for the V2 OTP verification flow.

```dart
// before
final String otpId = await turnkeyProvider.initOtp(
  otpType: OtpType.Email,
  contact: 'user@example.com',
);

// after
final InitOtpResult result = await turnkeyProvider.initOtp(
  otpType: OtpType.Email,
  contact: 'user@example.com',
);
// result.otpId
// result.otpEncryptionTargetBundle
```

---
### `verifyOtp`

**What changed:** Removed `contact` and `otpType` params. Added required `otpEncryptionTargetBundle`. The account lookup (`proxyGetAccount`) that previously happened inside `verifyOtp` has been moved out, so `verifyOtp` is now purely verification. Returns `verificationToken` and `publicKey` (removed `subOrganizationId`).

```dart
// before — verifyOtp also fetched the subOrganizationId internally
final result = await turnkeyProvider.verifyOtp(
  otpId: otpId,
  otpCode: otpCode,
  contact: 'user@example.com',
  otpType: OtpType.Email,
);
// result.subOrganizationId
// result.verificationToken

// after — verification only; account lookup is separate
final result = await turnkeyProvider.verifyOtp(
  otpId: otpId,
  otpCode: otpCode,
  otpEncryptionTargetBundle: otpEncryptionTargetBundle, // new — from initOtp
  publicKey: publicKey,                                 // optional
);
// result.verificationToken
// result.publicKey
```

---
### `loginWithOtp`

**What changed:** Removed `publicKey` param. The key bound during `verifyOtp` is now automatically derived from the verification token and used to produce the required `clientSignature`.

```dart
// before
await turnkeyProvider.loginWithOtp(
  verificationToken: verificationToken,
  publicKey: publicKey,
  invalidateExisting: true,
);

// after
await turnkeyProvider.loginWithOtp(
  verificationToken: verificationToken,
  invalidateExisting: true,
);
```

---
### `signUpWithOtp`

**What changed:** Removed `publicKey` param. The key bound during `verifyOtp` is now automatically derived from the verification token and used to produce the required `clientSignature`.

```dart
// before
await turnkeyProvider.signUpWithOtp(
  verificationToken: verificationToken,
  contact: 'user@example.com',
  otpType: OtpType.Email,
  publicKey: publicKey,
);

// after
await turnkeyProvider.signUpWithOtp(
  verificationToken: verificationToken,
  contact: 'user@example.com',
  otpType: OtpType.Email,
);
```

---
### `loginOrSignUpWithOtp`

**What changed:** Added required `otpEncryptionTargetBundle` param (passed through from `initOtp`). The returned `LoginOrSignUpWithOtpResult` now includes a `verificationToken` field.

```dart
// before
await turnkeyProvider.loginOrSignUpWithOtp(
  otpId: otpId,
  otpCode: otpCode,
  contact: 'user@example.com',
  otpType: OtpType.Email,
);

// after
await turnkeyProvider.loginOrSignUpWithOtp(
  otpId: otpId,
  otpCode: otpCode,
  otpEncryptionTargetBundle: otpEncryptionTargetBundle, // new — from initOtp
  contact: 'user@example.com',
  otpType: OtpType.Email,
);
// result.sessionToken
// result.verificationToken  // new
// result.action             // AuthAction.login or AuthAction.signup
```

---
### `signWithApiKey`

**What changed:** New helper method added to `TurnkeyProvider`.

Signs a message using a key pair stored in secure storage. Temporarily sets the specified public key as the active key on the stamper, signs the message (SHA-256 hashed, ECDSA P-256), then restores the previous key. Returns a compact hex signature (r || s).

```dart
final signature = await turnkeyProvider.signWithApiKey(
  message: 'hello world',
  publicKey: myPublicKey,
);
```

---
### `CreateSubOrgParams.oauthProviders`

**What changed:** Type updated from `List<v1OauthProviderParams>?` to `List<v1OauthProviderParamsV2>?`. Use the named constructors when constructing providers:

```dart
// before
CreateSubOrgParams(
  oauthProviders: [
    v1OauthProviderParams(providerName: 'google', oidcToken: token),
  ],
)

// after
CreateSubOrgParams(
  oauthProviders: [
    v1OauthProviderParamsV2.oidcToken(providerName: 'google', oidcToken: token),
  ],
)
```
- ### `INIT_OTP`

`ACTIVITY_TYPE_INIT_OTP_V2` → `ACTIVITY_TYPE_INIT_OTP_V3`

**What changed:** Added required `otpEncryptionTargetBundle` to the result.

```dart
// before — v1InitOtpResult
{
  otpId: String;
}

// after — v1InitOtpResultV2
{
  otpId: String;
  otpEncryptionTargetBundle: String; // new
}
```

---
### `VERIFY_OTP`

`ACTIVITY_TYPE_VERIFY_OTP` → `ACTIVITY_TYPE_VERIFY_OTP_V2`

**What changed:** Replaced plaintext `otpCode` + `publicKey` with a single `encryptedOtpBundle`.

Instead of sending the OTP code in plaintext, you now HPKE-encrypt it (along with your public key) to Turnkey's enclave using the `otpEncryptionTargetBundle` returned by `initOtp`. This ensures the OTP code never leaves the client in plaintext.

Use `encryptOtpCodeToBundle` from `turnkey_crypto` to build the bundle:

```dart
import 'package:turnkey_crypto/turnkey_crypto.dart';

final initResult = await client.proxyInitOtpV2(...);

// After the user enters their OTP code:
final encryptedOtpBundle = await encryptOtpCodeToBundle(
  otpCode: otpCode,                                    // the code the user entered
  otpEncryptionTargetBundle: initResult.otpEncryptionTargetBundle, // from initOtp
  publicKey: publicKey,                                // your target public key
);

await client.proxyVerifyOtpV2(
  input: ProxyTVerifyOtpV2Body(
    otpId: initResult.otpId,
    encryptedOtpBundle: encryptedOtpBundle,
  ),
);
```

```dart
// before — v1VerifyOtpIntent
{
  otpId: String;
  otpCode: String;           // removed
  expirationSeconds: String?;
  publicKey: String?;        // removed
}

// after — v1VerifyOtpIntentV2
{
  otpId: String;
  encryptedOtpBundle: String; // new — replaces otpCode + publicKey
  expirationSeconds: String?;
}
```

---
### `OTP_LOGIN`

`ACTIVITY_TYPE_OTP_LOGIN` → `ACTIVITY_TYPE_OTP_LOGIN_V2`

**What changed:** `clientSignature` promoted from optional to required.

```dart
// before — v1OtpLoginIntent
{
  verificationToken: String;
  publicKey: String;
  expirationSeconds: String?;
  invalidateExisting: bool?;
  clientSignature: v1ClientSignature?; // optional
}

// after — v1OtpLoginIntentV2
{
  verificationToken: String;
  publicKey: String;
  expirationSeconds: String?;
  invalidateExisting: bool?;
  clientSignature: v1ClientSignature;  // now required
}
```

---
### `CREATE_OAUTH_PROVIDERS`

`ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS` → `ACTIVITY_TYPE_CREATE_OAUTH_PROVIDERS_V2`

**What changed:** Added `oidcClaims` as a new option alongside `oidcToken`; you must provide exactly one. This updated type feeds into the `CREATE_SUB_ORGANIZATION` and `CREATE_USERS` changes below.

`v1OauthProviderParamsV2` is now generated as a single class with named constructors:

```dart
// before — v1OauthProviderParams
v1OauthProviderParams(
  providerName: 'google',
  oidcToken: token,
)

// after — v1OauthProviderParamsV2 (named constructors)
v1OauthProviderParamsV2.oidcToken(
  providerName: 'google',
  oidcToken: token,
)

v1OauthProviderParamsV2.oidcClaims(
  providerName: 'google',
  oidcClaims: v1OidcClaims(iss: '...', sub: '...', aud: '...'),
)
```

---
### `CREATE_SUB_ORGANIZATION`

`ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V7` → `ACTIVITY_TYPE_CREATE_SUB_ORGANIZATION_V8`

**What changed:** `rootUsers` items updated from `v1RootUserParamsV4` → `v1RootUserParamsV5`, which updates `oauthProviders` from `v1OauthProviderParams` → `v1OauthProviderParamsV2`.

---
### `CREATE_USERS`

`ACTIVITY_TYPE_CREATE_USERS_V3` → `ACTIVITY_TYPE_CREATE_USERS_V4`

**What changed:** `users` items updated from `v1UserParamsV3` → `v1UserParamsV4`, which updates `oauthProviders` from `v1OauthProviderParams` → `v1OauthProviderParamsV2`.
- ### OAuth provider config restructured

**What changed:** The flat `OAuthConfig { googleClientId, appleClientId, ... }` fields have been replaced with per-provider parameter classes nested under a new `providers` field. Each provider has a typed `primaryClientId` (where the type encodes which kind of ID is expected) and accepts an optional `secondaryClientIds` list. The unused `facebookClientId` field has been dropped entirely.

```dart
// before
OAuthConfig(
  googleClientId: '<google-client-id>',
  appleClientId: '<apple-services-id>',
  xClientId: '<x-client-id>',
  discordClientId: '<discord-client-id>',
)

// after
OAuthConfig(
  providers: OAuthProviders(
    google: GoogleOAuthProviderParams(
      primaryClientId: GoogleOAuthPrimaryClientId(webClientId: '<google-client-id>'),
      secondaryClientIds: const ['<additional-google-client-id>'],
    ),
    apple: AppleOAuthProviderParams(
      primaryClientId: AppleOAuthPrimaryClientId(
        serviceId: '<apple-services-id>',
        iosBundleId: '<ios-bundle-id>',
      ),
    ),
    x: XOAuthProviderParams(primaryClientId: '<x-client-id>'),
    discord: DiscordOAuthProviderParams(primaryClientId: '<discord-client-id>'),
  ),
)
```

---
### Secondary client IDs

**What changed:** Every `handle*OAuth` method (`handleGoogleOAuth`, `handleAppleOAuth`, `handleAppleWebOAuth`, `handleXOAuth`, `handleDiscordOAuth`) now accepts `secondaryClientIds: List<String>?`. Per-call values take precedence over the values in `OAuthConfig.providers.*.secondaryClientIds`.

`secondaryClientIds` are additional client IDs that get linked to the user during sign-up: the primary OIDC token is JWT-decoded for `iss`/`sub`, and one `v1OauthProviderParamsV2.oidcClaims` entry is synthesized per secondary client ID sharing the same identity. The sub-org ends up with multiple authenticators registered, one per audience. This lets a user who signed in with one client ID on one platform sign in with a different client ID on another platform and resolve to the same sub-organization.

```dart
// before
await turnkey.handleGoogleOAuth(clientId: '<google-client-id>');

// after
await turnkey.handleGoogleOAuth(
  clientId: '<google-client-id>',
  secondaryClientIds: const ['<additional-google-client-id>'],
);
```

---
### Native Apple Sign-In

**What changed:** `handleAppleOAuth` now uses native Apple Sign-In on iOS via the [`sign_in_with_apple`](https://pub.dev/packages/sign_in_with_apple) package (with a web fallback on Android). It no longer takes `clientId`, `originUri`, or `redirectUri` — the iOS bundle ID is used as the primary audience automatically, and the `serviceId` from `AppleOAuthPrimaryClientId` is registered as a secondary so a user who signs up on iOS can later log in on web/Android.

The previous web-based Apple OAuth flow is preserved as `handleAppleWebOAuth` for cases where the web flow is explicitly desired.

iOS consumers must add the **Sign in with Apple** capability to the Runner target in Xcode (Signing & Capabilities → + Capability → Sign in with Apple). Android consumers must set `AppleOAuthPrimaryClientId.serviceId`; the underlying package requires it for the web fallback.

```dart
// before (web-based)
await turnkey.handleAppleOAuth(clientId: '<apple-services-id>');

// after (native)
await turnkey.handleAppleOAuth();

// web-based flow is still available as:
await turnkey.handleAppleWebOAuth(clientId: '<apple-services-id>');
```


## 1.2.1 — 2026-02-20
### Patch Changes
- Updated dependencies: turnkey_http.


## 1.2.0 — 2026-02-02
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



