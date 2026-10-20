---
title: "Raise Dart SDK floor to 3.13.5"
date: "2026-10-20"
packages:
  turnkey_api_key_stamper: "minor"
  turnkey_crypto: "minor"
  turnkey_encoding: "minor"
  turnkey_http: "major"
  turnkey_flutter_passkey_stamper: "major"
  turnkey_sdk_flutter: "major"
  turnkey_sessions: "minor"
---

### Minimum Dart SDK raised to 3.13.5

**What changed:** The Dart SDK constraint is now `>=3.13.5 <4.0.0` (previously `>=3.6.0 <4.0.0`). Consumers on Dart older than 3.13.5 (Flutter older than 3.47.7) can no longer resolve these packages.

**Migration:** Upgrade to Flutter 3.47.7 / Dart 3.13.5 or newer. There are no API changes.

> Pre-1.0 packages (`turnkey_api_key_stamper`, `turnkey_crypto`, `turnkey_encoding`, `turnkey_sessions`) receive a minor bump, which Dart treats as breaking.
