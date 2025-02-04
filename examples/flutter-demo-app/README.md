# Turnkey Flutter Demo App

This demo app leverages Turnkey's Dart/Flutter packages to demonstrate how they can be used to create a fully functional application. It includes a simple Node.js backend API server to facilitate server-side operations.

## Prerequisites

_Note: version numbers are approximated. Older or newer versions may or may not work correctly._

| Requirement    | Version  |
| -------------- | -------- |
| Flutter        | >= 3.0.0 |
| Dart           | >= 3.0.0 |
| Xcode          | >= 12.0  |
| Android Studio | >= 4.0   |
| Node.js        | >= 14.0  |

## Environment Variables Setup

Create a `.env` file in the root directory of your project. You can use the provided `.env.example` file as a template:

```python
TURNKEY_API_URL="https://api.turnkey.com"
BACKEND_API_URL="http://localhost:3000" # This is the default port for the Node server in /api-server
RP_ID="<YOUR_RP_ID>"                    # This is the relying party ID that hosts your .well-known file. Used for passkey registration
ORGANIZATION_ID="<YOUR_ORGANIZATION_ID>"

#NODE SERVER ENV VARIABLES (Only used for the Node server in /api-server)
TURNKEY_API_PUBLIC_KEY="<YOUR_TURNKEY_API_PUBLIC_KEY>"
TURNKEY_API_PRIVATE_KEY="<YOUR_TURNKEY_API_PRIVATE_KEY>"
BACKEND_API_PORT="3000"
```

## Backend API Server

This app must be connected to a backend server. You can use the included Node.js backend API server or set up your own.

### Install Dependencies

Navigate to the api-server directory and install the dependencies:

```bash
cd api-server
npm install
```

Build and Run the Backend Server

```bash
npm run build
npm start
```

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

## Passkey Configuration

To allow passkeys to be registered on iOS and Android, you must set up an associated domain. For detailed instructions, refer to the [Turnkey Flutter Passkey Stamper README](/packages/passkey-stamper) or [Apple](https://developer.apple.com/documentation/xcode/supporting-associated-domains) and [Google's](https://developer.android.com/identity/sign-in/credential-manager#add-support-dal) respective instruction pages.

Once you have this setup, add your relying party server's domain to your .env file

```python
RP_ID="example.example.com"
```
