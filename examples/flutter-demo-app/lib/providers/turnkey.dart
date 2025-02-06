import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:turnkey_api_key_stamper/turnkey_api_key_stamper.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';
import 'package:turnkey_http/__generated__/services/coordinator/v1/public_api.swagger.dart';
import 'package:turnkey_http/base.dart';
import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_http/turnkey_http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:openid_client/openid_client_io.dart' as openid;
import 'session.dart';

class User {
  final String id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String organizationId;
  final List<Wallet> wallets;

  User({
    required this.id,
    this.userName,
    this.email,
    this.phoneNumber,
    required this.organizationId,
    required this.wallets,
  });
}

class Wallet {
  final String name;
  final String id;
  final List<String> accounts;

  Wallet({
    required this.name,
    required this.id,
    required this.accounts,
  });
}

class TurnkeyProvider with ChangeNotifier {
  final Map<String, bool> _loading = {};
  String? _errorMessage;
  User? _user;
  TurnkeyClient? _client;

  final SessionProvider sessionProvider;

  TurnkeyProvider({required this.sessionProvider}) {
    sessionProvider.addListener(_onSessionUpdate);
    _onSessionUpdate();
  }

  bool isLoading(String key) => _loading[key] ?? false;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  void setLoading(String key, bool loading) {
    _loading[key] = loading;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> _onSessionUpdate() async {
    final session = sessionProvider.session;

    if (session != null) {
      try {
        final stamper = ApiKeyStamper(
          ApiKeyStamperConfig(
              apiPrivateKey: session.privateKey,
              apiPublicKey: session.publicKey),
        );

        final client = TurnkeyClient(
          config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
          stamper: stamper,
        );
        _client = client;

        final whoami = await client.getWhoami(
            input: GetWhoamiRequest(
          organizationId: EnvConfig.organizationId,
        ));

        if (whoami.userId != null && whoami.organizationId != null) {
          final walletsResponse = await client.getWallets(
            input: GetWalletsRequest(organizationId: whoami.organizationId),
          );
          final userResponse = await client.getUser(
            input: GetUserRequest(
              organizationId: whoami.organizationId,
              userId: whoami.userId,
            ),
          );

          final wallets =
              await Future.wait(walletsResponse.wallets.map((wallet) async {
            final accountsResponse = await client.getWalletAccounts(
                input: GetWalletAccountsRequest(
                    organizationId: whoami.organizationId,
                    walletId: wallet.walletId));
            return Wallet(
              name: wallet.walletName,
              id: wallet.walletId,
              accounts: accountsResponse.accounts
                  .map<String>((account) => (account.address))
                  .toList(),
            );
          }).toList());

          final user = userResponse.user;

          _user = User(
            id: user.userId,
            userName: user.userName,
            email: user.userEmail,
            phoneNumber: user.userPhoneNumber,
            organizationId: whoami.organizationId,
            wallets: wallets,
          );

          notifyListeners();
        }
      } catch (error) {
        setError(error.toString());
      }
    }
  }

  Future<void> initEmailLogin(BuildContext context, String email) async {
    setLoading('initEmailLogin', true);
    setError(null);

    final otpType = 'OTP_TYPE_EMAIL';

    try {
      final response = await initOTPAuth({
        'otpType': otpType,
        'contact': email,
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
      setLoading('initEmailLogin', false);
    }
  }

  Future<void> completeEmailAuth({
    required BuildContext context,
    required String otpId,
    required String otpCode,
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completeEmailAuth', true);
      setError(null);

      try {
        final targetPublicKey = await sessionProvider.createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await sessionProvider.createSession(response['credentialBundle']);
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completeEmailAuth', false);
      }
    }
  }

  Future<void> initPhoneLogin(BuildContext context, String phone) async {
    final otpType = 'OTP_TYPE_SMS';
    setLoading('initPhoneLogin', true);
    setError(null);

    try {
      final response = await initOTPAuth({
        'otpType': otpType,
        'contact': phone,
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
      setLoading('initPhoneLogin', false);
    }
  }

  Future<void> completePhoneAuth({
    required BuildContext context,
    required String otpId,
    required String otpCode,
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completePhoneAuth', true);
      setError(null);

      try {
        final targetPublicKey = await sessionProvider.createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await sessionProvider.createSession(response['credentialBundle']);
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completePhoneAuth', false);
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

  Future<void> signInWithGoogle(BuildContext context) async {
    // Sign in with Google is a demonstration of how to use the OpenID Connect with Turnkey using a generic OpenID Connect client library. This function can be refactored to allow oAuth with most OpenID Connect providers.
    setLoading('signInWithGoogle', true);
    final appLinks = AppLinks();

    final clientId = EnvConfig.googleClientId;
    final redirectUri = Uri.parse(
        '${EnvConfig.googleRedirectScheme}://'); // This is the redirect URI that the OpenID Connect provider will redirect to after the user signs in. This URI must be registered with the OpenID Connect provider.
    final List<String> scopes = ['openid', 'email', 'profile'];

    final targetPublicKey = await sessionProvider.createEmbeddedKey();

    try {
      final String codeVerifier = generateChallenge();

      var issuer = await openid.Issuer.discover(
          Uri.parse('https://accounts.google.com/'));
      var client = openid.Client(issuer, clientId);

      urlLauncher(String url) async {
        await launchUrlString(url);
      }

      var authenticator = openid.Authenticator.fromFlow(
          openid.Flow.authorizationCodeWithPKCE(client,
              scopes: scopes,
              codeVerifier: codeVerifier,
              additionalParameters: {
                "code_challenge_method": "S256",
                "nonce": sha256.convert(utf8.encode(targetPublicKey)).toString()
              }),
          urlLancher: urlLauncher);

      authenticator.flow.redirectUri = redirectUri;

      appLinks.uriLinkStream.listen((uri) async {
        // Listen for the redirect URI
        if (uri != null) {
          print(uri.toString());
          String? responseCode = uri.queryParameters['code'];

          if (responseCode != null) {
            // Exchange the authorization code for tokens using PKCE: https://developers.google.com/identity/protocols/oauth2/native-app#obtainingaccesstokens
            final response = await http.post(
              Uri.parse('https://oauth2.googleapis.com/token'),
              headers: {'Content-Type': 'application/x-www-form-urlencoded'},
              body: {
                'code': responseCode,
                'client_id': clientId,
                'redirect_uri': redirectUri.toString(),
                'grant_type': 'authorization_code',
                'code_verifier': codeVerifier,
              },
            );

            if (response.statusCode == 200) {
              final data = json.decode(response.body);

              final idToken = data['id_token'];
              final payload = JwtDecoder.decode(idToken);
              final userEmail = payload[
                  'email']; // Extract the email from JWT encoded ID token

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
                await sessionProvider
                    .createSession(oAuthResponse['credentialBundle']);
                closeInAppWebView();
                return;
              } else {
                debugPrint('Failed to exchange authorization code for tokens');
              }
            } else {
              debugPrint("Error getting token: ${response.body}");
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
    try {
      final targetPublicKey = await sessionProvider.createEmbeddedKey();

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
        await sessionProvider.createSession(oAuthResponse['credentialBundle']);
        return;
      } else {
        debugPrint('Failed to exchange authorization code for tokens');
      }
    } catch (error) {
      setError(error.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    await sessionProvider.clearSession();
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<ActivityResponse> signRawPayload(
      BuildContext context, SignRawPayloadIntentV2 parameters) async {
    setLoading('signRawPayload', true);
    setError(null);

    try {
      if (_client == null || user == null) {
        throw Exception("Client or user not initialized");
      }

      final response = _client!.signRawPayload(
          input: SignRawPayloadRequest(
              type: SignRawPayloadRequestType.activityTypeSignRawPayloadV2,
              timestampMs: DateTime.now().millisecondsSinceEpoch.toString(),
              organizationId: user!.organizationId,
              parameters: parameters));
      return response;
    } catch (error) {
      setError(error.toString());
      throw Exception(error.toString());
    } finally {
      setLoading('signRawPayload', false);
    }
  }
}
