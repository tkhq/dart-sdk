import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:openid_client/openid_client_io.dart' as openid;

import 'package:turnkey_api_stamper/api_stamper.dart';
import 'package:turnkey_http_client/__generated__/services/coordinator/v1/public_api.swagger.dart';
import 'package:turnkey_http_client/base.dart';
import 'package:turnkey_http_client/index.dart';
import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';

import 'package:turnkey_flutter_passkey_stamper/passkey_stamper.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../utils/constants.dart';
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
        final stamper = ApiStamper(
          ApiStamperConfig(
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

  Future<void> signInWithGoogle(BuildContext context) async {
    final clientId = EnvConfig.googleClientId;
    final clientSecret = EnvConfig.googleClientSecret;
    final redirectUri = Uri.parse(EnvConfig.oAuthRedirectUrl);
    final List<String> scopes = ['openid', 'email', 'profile'];

    try {
      final targetPublicKey = await sessionProvider.createEmbeddedKey();

      var issuer = await openid.Issuer.discover(
          Uri.parse('https://accounts.google.com'));

      var client = openid.Client(issuer, clientId);

      urlLauncher(String url) async {
        if (await canLaunchUrlString(url)) {
          await launchUrlString(url);
        } else {
          throw 'Could not launch $url';
        }
      }

      var authenticator = openid.Authenticator(client,
          scopes: scopes,
          port: 4000,
          urlLancher: urlLauncher,
          redirectUri: redirectUri,
          additionalParameters: {
            "nonce": sha256.convert(utf8.encode(targetPublicKey)).toString()
          });

      var c = await authenticator.authorize();

      var tokenResponse = await c.getTokenResponse();

      var authorizationCode = tokenResponse.toJson()['code'];

      // Exchange the authorization code for tokens
      var response = await http.post(
        Uri.parse('https://oauth2.googleapis.com/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'code': authorizationCode,
          'client_id': clientId,
          'client_secret': clientSecret,
          'redirect_uri': redirectUri.toString(),
          'grant_type': 'authorization_code',
        },
      );

      if (response.statusCode == 200) {
        var tokenResponse = json.decode(response.body);
        var idToken = tokenResponse['id_token'];

        final oAuthResponse = await oAuthLogin({
          "oidcToken": idToken,
          "providerName": "Google",
          "targetPublicKey": targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
        });
        print(oAuthResponse);

        if (oAuthResponse['credentialBundle'] != null) {
          await sessionProvider
              .createSession(oAuthResponse['credentialBundle']);
        }
      } else {
        print('Failed to exchange authorization code for tokens');
      }

      closeInAppWebView();
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }
}
