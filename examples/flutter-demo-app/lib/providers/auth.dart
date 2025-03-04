import 'dart:async';
import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';

import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:openid_client/openid_client_io.dart' as openid;

class AuthRelayerProvider with ChangeNotifier {
  final Map<String, bool> _loading = {};
  String? _errorMessage;

  final TurnkeyProvider turnkeyProvider;

  AuthRelayerProvider({required this.turnkeyProvider});

  bool isLoading(String key) => _loading[key] ?? false;
  String? get errorMessage => _errorMessage;

  void setLoading(String key, bool loading) {
    _loading[key] = loading;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> initOtpLogin(BuildContext context,
      {required String otpType, required String contact}) async {
    setLoading(
        otpType == 'OTP_TYPE_EMAIL' ? 'initEmailLogin' : 'initPhoneLogin',
        true);
    setError(null);

    try {
      final response = await initOTPAuth({
        'otpType': otpType,
        'contact': contact,
      });

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              otpType: otpType,
              otpId: response['otpId'],
              organizationId: response['organizationId'],
            ),
          ),
        );
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading(
          otpType == 'OTP_TYPE_EMAIL' ? 'initEmailLogin' : 'initPhoneLogin',
          false);
    }
  }

  Future<void> completeOtpAuth({
    required BuildContext context,
    required String otpId,
    required String otpCode,
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completeOtpAuth', true);
      setError(null);

      try {
        final targetPublicKey = await createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await turnkeyProvider.createSession(response['credentialBundle']);
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completeOtpAuth', false);
      }
    }
  }

  Future<void> signUpWithPasskey(BuildContext context) async {
    setLoading('signUpWithPasskey', true);
    setError(null);

    try {
      final authenticationParams =
          await createPasskey(PasskeyRegistrationConfig(rp: {
        'id': EnvConfig.rpId,
        'name': 'Flutter test app',
      }, user: {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': "Anonymous User",
        'displayName': "Anonymous User",
      }, authenticatorName: 'End-User Passkey'));

      final response = await createSubOrg({
        'passkey': {
          'challenge': authenticationParams['challenge'],
          'attestation': authenticationParams['attestation'],
        },
      });

      if (response['subOrganizationId'] != null) {
        final stamper =
            PasskeyStamper(PasskeyStamperConfig(rpId: EnvConfig.rpId));
        final httpClient = TurnkeyClient(
            config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
            stamper: stamper);

        final targetPublicKey = await createEmbeddedKey();

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
          await turnkeyProvider.createSession(credentialBundle);
        }
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('signUpWithPasskey', false);
    }
  }

  Future<void> loginWithPasskey(BuildContext context) async {
    setLoading('loginWithPasskey', true);
    setError(null);

    try {
      final stamper =
          PasskeyStamper(PasskeyStamperConfig(rpId: EnvConfig.rpId));
      final httpClient = TurnkeyClient(
          config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
          stamper: stamper);

      final targetPublicKey = await createEmbeddedKey();

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
        await turnkeyProvider.createSession(credentialBundle,
            sessionKey: 'passkey');
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('loginWithPasskey', false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    // Sign in with Google is a demonstration of how to use the OpenID Connect with Turnkey using a generic OpenID Connect client library. This function can be refactored to allow oAuth with most OpenID Connect providers.
    setLoading('signInWithGoogle', true);
    final appLinks = AppLinks();

    final clientId = EnvConfig.googleClientId;
    final redirectUri = Uri.parse(
        '${EnvConfig.googleRedirectScheme}://'); // This is the redirect URI that the OpenID Connect provider will redirect to after the user signs in. This URI must be registered with the OpenID Connect provider and added to your info.plist and AndroidManifest.xml.
    final List<String> scopes = ['openid', 'email', 'profile'];

    final targetPublicKey = await createEmbeddedKey();

    try {
      var issuer = await openid.Issuer.discover(Issuer.google);
      var client = openid.Client(issuer, clientId);

      urlLauncher(String url) async {
        await launchUrlString(url);
      }

      var authenticator = openid.Authenticator(client,
          scopes: scopes,
          urlLancher: urlLauncher,
          additionalParameters: {
            "code_challenge_method": "S256",
            "nonce": sha256.convert(utf8.encode(targetPublicKey)).toString()
          });

      authenticator.flow.redirectUri =
          redirectUri; // Setting the redirect URI after the authenticator is created will force the OpenID Connect client to use PKCE but still have a correct redirect URI: https://github.com/appsup-dart/openid_client/issues/4#issuecomment-1054165055

      appLinks.uriLinkStream.listen((uri) async {
        // Listen for the redirect URI
        if (uri != null) {
          String? responseCode = uri.queryParameters['code'];

          if (responseCode != null) {
            final response = await authenticator.flow.callback({
              // This callback function will exchange the authorization code for tokens using PKCE: https://developers.google.com/identity/protocols/oauth2/native-app#obtainingaccesstokens
              'code': responseCode,
              'state': authenticator.flow.state,
            });

            final tokenResponse = await response.getTokenResponse();
            final idToken = tokenResponse.idToken.toCompactSerialization();
            final userInfo = await response.getUserInfo();
            final userEmail = userInfo.email;

            if (idToken == null || userEmail == null) {
              throw Exception('Failed to get ID token or user email');
            }

            // Use the ID token to authenticate with Turnkey
            final oAuthResponse = await oAuthLogin({
              "email": userEmail,
              "oidcToken": idToken,
              "providerName": "Google",
              "targetPublicKey": targetPublicKey,
              'expirationSeconds':
                  OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
            });

            if (oAuthResponse['credentialBundle'] != null) {
              await turnkeyProvider
                  .createSession(oAuthResponse['credentialBundle']);
              closeInAppWebView();
              return;
            } else {
              throw Exception(
                  'Failed to exchange authorization code for tokens');
            }
          }
        }
      });

      authenticator.authorize();
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('signInWithGoogle', false);
    }
  }

  Future<void> signInWithApple(BuildContext context) async {
    // Sign in with Apple leverages the sign_in_with_apple flutter package which uses Apple's native "Sign in with Apple" SDK on iOS.
    setLoading('signInWithApple', true);

    try {
      final targetPublicKey = await createEmbeddedKey();

      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ], nonce: sha256.convert(utf8.encode(targetPublicKey)).toString());
      final oidcToken = credential.identityToken;

      if (oidcToken == null) {
        throw Exception('Failed to get OIDC token');
      }

      final oAuthResponse = await oAuthLogin({
        "oidcToken": oidcToken,
        "providerName": "Apple",
        "targetPublicKey": targetPublicKey,
        'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
      });

      if (oAuthResponse['credentialBundle'] != null) {
        await turnkeyProvider.createSession(oAuthResponse['credentialBundle']);
        return;
      } else {
        throw Exception('No credential bundle returned');
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('signInWithApple', false);
    }
  }
}
