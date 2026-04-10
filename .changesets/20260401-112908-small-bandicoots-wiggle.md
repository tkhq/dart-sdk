---
title: "small-bandicoots-wiggle"
date: "2026-04-01"
packages:
  turnkey_sdk_flutter: "major"
---

### `initOtp`

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
