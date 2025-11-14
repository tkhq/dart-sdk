# Turnkey Flutter Demo App

This demo app leverages [`turnkey_sdk_flutter`](../../packages/sdk-flutter/) to demonstrate how they can be used to create a fully functional application.

## Demo

![Demo](../../assets/demo.gif)

## Prerequisites

> **Note**: version numbers are approximated. Older or newer versions may or may not work correctly.

| Requirement    | Version  |
| -------------- | -------- |
| Flutter        | >= 3.0.0 |
| Dart           | >= 3.0.0 |
| Xcode          | >= 12.0  |
| Android Studio | >= 4.0   |

## Environment Variables Setup

Create a `.env` file in the root directory of your project. You can use the provided `.env.example` file as a template:

```python
# Public Turnkey API
TURNKEY_API_URL="https://api.turnkey.com"
ORGANIZATION_ID="YOUR_ORGANIZATION_ID_HERE"

# Auth Proxy
AUTH_PROXY_URL="https://authproxy.turnkey.com"
AUTH_PROXY_CONFIG_ID="YOUR_AUTH_PROXY_CONFIG_ID"

# Passkey
RP_ID="YOUR_RP_ID_HERE"

# OAuth
APP_SCHEME="your-app-scheme"

GOOGLE_CLIENT_ID="YOUR_GOOGLE_CLIENT_ID"
APPLE_CLIENT_ID="YOUR_APPLE_CLIENT_ID"
X_CLIENT_ID="YOUR_X_CLIENT_ID"
DISCORD_CLIENT_ID="YOUR_DISCORD_CLIENT_ID"

```

You can find your `ORGANIZATION_ID` and `AUTH_PROXY_CONFIG_ID` from the [Turnkey Dashboard](https://app.turnkey.com).

## Running the Flutter App

### Install Dependancies

Navigate to the root directory of your Flutter project and install the dependencies:

```bash
flutter pub get
```

### Run the Flutter App

You can run the app on a connected device or emulator using the following command:

```bash
flutter run
```

You will be prompted to select a device to run the app on. You can also use the Flutter VSCode extension to run the app and select the device.

## OAuth Configuration (optional)

This app includes an example for authenticating with Turnkey using a Google, Apple, X, or Discord account.

### Sign in with Google

To configure Google OAuth, follow these steps:

#### 1. Create a Google Web Client ID:

- Go to [Google Cloud Console](https://console.cloud.google.com/).
- Create a new OAuth client ID.
- Set the authorized origin to:
  ```
  https://oauth-origin.turnkey.com
  ```
- Set the authorized redirect URI to:
  ```
  https://oauth-redirect.turnkey.com?scheme=flutter-demo-app
  ```
  > **Note**: If you change your app's scheme, you must update this link and your `.env` file with your new scheme

#### 2. Set your Client ID in `.env`:

In your project's `.env` file, add the following:

```ini
GOOGLE_CLIENT_ID="<YOUR_GOOGLE_WEB_CLIENT_ID>"
```

For more information on how to setup OAuth in Turnkey powered Flutter apps, visit [our docs!](https://docs.turnkey.com/sdks/flutter)

## Passkey Configuration (optional)

To allow passkeys to be registered on iOS and Android, you must set up an associated domain. For detailed instructions, refer to the [Turnkey Flutter Passkey Stamper README](/packages/passkey-stamper) or [Apple](https://developer.apple.com/documentation/xcode/supporting-associated-domains) and [Google's](https://developer.android.com/identity/sign-in/credential-manager#add-support-dal) respective instruction pages.

Once you have this setup, add your relying party server's domain to your .env file

```python
RP_ID="example.example.com"
```
