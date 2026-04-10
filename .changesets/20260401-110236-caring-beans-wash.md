---
title: "caring-beans-wash"
date: "2026-04-01"
packages:
  turnkey_http: "major"
  turnkey_sdk_flutter: "major"
---

### `INIT_OTP`

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
