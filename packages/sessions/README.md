# Turnkey Sessions

This package provides developers with an easy way to manage sessions and securely store public-private key pairs on iOS and Android devices. It is meant to be used with [Turnkey's other Flutter packages](https://pub.dev/publishers/turnkey.com/packages) to create a fully functional app powered by [Turnkey](https://www.turnkey.com/). Key pairs are stored on device using the [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) package.

## Usage

It is highly recommended to use the [provider](https://pub.dev/packages/provider) package and instantiate the SessionProvider class as a provider.

### Setting up the Provider

First, add the `provider` package to your `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.2
```

Then, wrap your app with the MultiProvider and add the SessionProvider:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sessions/turnkey_sessions.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
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

### Using the Provider

You can now access the SessionProvider in your widgets and call its functions:

```dart
// your existing code...
  @override
  Widget build(BuildContext context) {

    final sessionProvider = Provider.of<SessionProvider>(context);

    // Create a P-256 public-private key pair (saves private key in secure storage)
    final publicKey = await sessionProvider.createEmbeddedKey();

    // Get private key from secure storage
    final privateKey = await sessionProvider.getEmbeddedKey(deleteKey: true); // Optional deleteKey param

    // Create a session using a credential bundle (retrieved from a Turnkey request)
    await sessionProvider.createSession(credentialBundle);

    // Access the session object
    final session = await sessionProvider.getSession();

    // Add a listener to the session provider. someFunction() will run when the session is updated
    sessionProvider.addListener(someFunction());

    // rest of your code...
  }

```

Here is an example of authenticating a user with Turnkey using a passkey. This function leverages Turnkey's [Flutter passkey stamper](https://pub.dev/packages/turnkey_flutter_passkey_stamper) and [http client](https://pub.dev/packages/turnkey_http). A session is created using the credential bundle returned from Turnkey after creating a [read-write session](https://docs.turnkey.com/features/sessions#read-write-sessions).

```dart
Future<void> loginWithPasskey(BuildContext context) async {
    setLoading('loginWithPasskey', true);
    setError(null);

    try {
        final stamper =
            PasskeyStamper(PasskeyStamperConfig(rpId: EnvConfig.rpId));
        final httpClient = TurnkeyClient(
            config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
            stamper: stamper);

        final targetPublicKey = await sessionProvider.createEmbeddedKey();

        final sessionResponse = await httpClient.createReadWriteSession(
            input: CreateReadWriteSessionRequest(
                type: CreateReadWriteSessionRequestType
                    .activityTypeCreateReadWriteSessionV2,
                timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
                organizationId: EnvConfig.organizationId,
                parameters: CreateReadWriteSessionIntentV2(
                    targetPublicKey: targetPublicKey)));

        final credentialBundle = sessionResponse
            .activity.result.createReadWriteSessionResultV2?.credentialBundle;

        if (credentialBundle != null) {
            await sessionProvider.createSession(credentialBundle);
        }
    } catch (error) {
        setError(error.toString());
    } finally {
        setLoading('loginWithPasskey', false);
    }
}
```

For more code references, take a look at [this file](../../examples/flutter-demo-app/lib/providers/turnkey.dart) from our Flutter demo app.
