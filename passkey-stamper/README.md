# Turnkey Flutter Passkey Stamper

This package contains a Flutter passkey stamper. It uses the Flutter [passkeys](https://github.com/corbado/flutter-passkeys/tree/main/packages/passkeys/passkeys) package to do the heavy lifting. This stamper is meant to be used with Turnkey's [http package](/http).

## Installation

- Install this package in your Flutter project with the following command:

```bash
flutter pub add 'TODO: ADD PACKAGE NAME AFTER PUBLISHING'
```

## Platform specific setup

### iOS

To allow for passkey support on iOS, follow these steps.

#### Set up an associated domain ([Apple's instructions](https://developer.apple.com/documentation/xcode/supporting-associated-domains))

You need to associate a domain with your application. Configure your webserver to have the following route:

```
https://<yourdomain>/.well-known/apple-app-site-association
```

This will be the path to a JSON object with your team id and bundle identifier.

```json
{
  "applinks": {},
  "webcredentials": {
    "apps": ["XXXXXXXXXX.YYY.YYYYY.YYYYYYYYYYYYYY"]
  },
  "appclips": {}
}
```

In XCode under `Signing & Capabilities` add a new `Associated Domains` capability:

```
webcredentials:YOURDOMAIN
```

### Android

Passkey support configuration for Android is as follows.

#### Set up Digital Asset Links ([Google's instructions](https://developer.android.com/identity/sign-in/credential-manager#add-support-dal))

You need to associate a domain with your application. Configure your webserver to have the following route:

```
https://<yourdomain>/.well-known/assetlinks.json
```

This will be the path to a JSON object with the following information. (Note: replace `SHA_HEX_VALUE` with the SHA256 fingerprints of your Android signing certificate):

```json
[
  {
    "relation": ["delegate_permission/common.get_login_creds"],
    "target": {
      "namespace": "android_app",
      "package_name": "com.example",
      "sha256_cert_fingerprints": ["SHA_HEX_VALUE"]
    }
  }
]
```

## Usage

### Create a new passkey

```dart
import 'package:turnkey_flutter_passkey_stamper/passkey_stamper.dart';

// Returns authenticator params that can be used with sub-org creation, user creation, etc.
final authenticatorParams = await createPasskey(PasskeyRegistrationConfig(
  authenticatorName: "End-User Passkey",
  rp: {
    'id': 'your.site.com',
    'name': 'Your App',
  },
  user: {
    // This ID isn't visible to users
    'id': DateTime.now().millisecondsSinceEpoch.toString(),
    // ...but name and display names are. This is what's shown in the passkey prompt
    'name': 'Some Name',
    // displayName should be the same as "name"
    'displayName': 'Some Name',
  },
));
```

### Use an existing passkey

```dart
import 'package:turnkey_flutter_passkey_stamper/passkey_stamper.dart';
import 'package:turnkey_http_client/turnkey_http_client.dart';

final stamper = PasskeyStamper(PasskeyStamperConfig(rpId: 'your.site.com'));

// The Turnkey client uses the passed in stamper to produce signed requests
// and sends them to Turnkey
final client = TurnkeyClient(
  config: THttpConfig(baseUrl: 'https://api.turnkey.com'),
  stamper: stamper,
);

// Now you can make authenticated requests!
final data = await client.getWhoami(
  input: TGetWhoamiRequest(organizationId: '<Your organization id>'),
);
```

## Demo app

Head over to [this repository](/examples/fluttter-demo-app) for a fully functional Flutter demo app!
