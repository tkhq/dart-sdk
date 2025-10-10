import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';
import 'package:turnkey_http/__generated__/models.dart';
import 'package:uuid/uuid.dart';
import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class AuthRelayerProvider with ChangeNotifier {
  // TODO (Amir): Put all of these methods into the TurnkeyProvider!!!

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
      {required OtpType otpType, required String contact}) async {
    setLoading(
        otpType == OtpType.Email ? 'initEmailLogin' : 'initPhoneLogin', true);
    setError(null);

    try {
      final response = await turnkeyProvider.client!.proxyInitOtp(input: ProxyTInitOtpBody(
        contact: contact,
        otpType: otpType == OtpType.Email ? 'OTP_TYPE_EMAIL' : 'OTP_TYPE_SMS',
      ));

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              otpId: response.otpId,
              contact: contact,
              otpType: otpType,
            ),
          ),
        );
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading(otpType == OtpType.Email ? 'initEmailLogin' : 'initPhoneLogin',
          false);
    }
  }

  Future<void> completeOtpAuth({
    required String otpId,
    required String otpCode,
    required String contact,
    required OtpType otpType,
  }) async {
    final (suborganizationId, verificationToken) = await turnkeyProvider.verifyOtp(otpCode: otpCode, otpId: otpId, contact: contact, otpType: otpType);

    final loginRes = await turnkeyProvider.loginWithOtp(verificationToken: verificationToken);
    print("Login res: $loginRes");
  }

  Future<void> signUpWithPasskey({
    String? sessionKey,
    int expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? organizationId,
    String? passkeyDisplayName,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    String? generatedPublicKey;

    try {
      // 1. Generate initial API key pair
      generatedPublicKey =
          await turnkeyProvider.createApiKeyPair(storeOverride: true);
      final passkeyName = passkeyDisplayName ??
          'passkey-${DateTime.now().millisecondsSinceEpoch}';

      // 2. Create a passkey
      final passkey = await createPasskey(
        PasskeyRegistrationConfig(
          rp: {
            'id': EnvConfig.rpId,
            'name': 'Flutter App',
          },
          user: {
            'id': const Uuid().v4(),
            'name': 'Anonymous User',
            'displayName': 'Anonymous User',
          },
          authenticatorName: passkeyName,
        ),
      );

      final encodedChallenge = passkey['challenge'];
      final attestation = passkey['attestation'];

      if (encodedChallenge == null || attestation == null) {
        throw Exception(
            'Failed to create passkey: missing challenge or attestation.');
      }

      // 3. Create sub-org with authenticator + API key
      final signUpBody = {
        'passkey': {
          'authenticatorName': passkeyName,
          'challenge': encodedChallenge,
          'attestation': attestation,
        },
        'apiKeys': [
          {
            'apiKeyName': 'passkey-auth-$generatedPublicKey',
            'publicKey': generatedPublicKey!,
            'curveType': 'API_KEY_CURVE_P256',
            'expirationSeconds': '60',
          }
        ],
      };

      final subOrgResponse = await createSubOrg(signUpBody);
      final subOrgId = subOrgResponse['subOrganizationId'];
      if (subOrgId == null) {
        throw Exception('Failed to create sub-organization');
      }

      // 4. Generate a second key pair for the session
      final newGeneratedKeyPair = await turnkeyProvider.createApiKeyPair();

      // 5. Stamp a login for the session
      final loginResponse = await turnkeyProvider.client!.stampLogin(
        input: TStampLoginBody(
          organizationId: subOrgId,
          publicKey: newGeneratedKeyPair,
          expirationSeconds: expirationSeconds.toString(),
        ),
      );

      final loginResult = loginResponse.activity.result.stampLoginResult;

      final sessionJwt = loginResult?.session;
      if (sessionJwt == null) {
        throw Exception('No session returned from stampLogin');
      }

      // 6. Store the new session
      await turnkeyProvider.storeSession(
          sessionJwt: sessionJwt, sessionKey: sessionKey);

      // 7. Delete the first API key pair (cleanup)
      await turnkeyProvider.deleteApiKeyPair(generatedPublicKey);
      generatedPublicKey = null;

      // 8. Return result
      return; // TODO (Amir): return something useful here
    } finally {
      // Safety cleanup if something failed before we deleted the key
      if (generatedPublicKey != null) {
        try {
          await turnkeyProvider.deleteApiKeyPair(generatedPublicKey);
        } catch (e) {
          debugPrint('Failed to cleanup generated key pair: $e');
        }
      }
    }
  }

  Future<void> loginWithPasskey({
    String? sessionKey,
    int expirationSeconds = OTP_AUTH_DEFAULT_EXPIRATION_SECONDS,
    String? organizationId,
    String? publicKey,
  }) async {
    sessionKey ??= StorageKeys.DefaultSession.value;
    String? generatedPublicKey;

    try {
      // 1. Generate or use provided API key pair
      generatedPublicKey = publicKey ??
          await turnkeyProvider.createApiKeyPair(storeOverride: true);

      // TODO (Amir): We need to make it easier to create a passkeyclient. Maybe just expose it thru the turnkeyProvider?
      final passkeyStamper =
          PasskeyStamper(PasskeyStamperConfig(rpId: EnvConfig.rpId));
      final passkeyClient = TurnkeyClient(
          config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
          stamper: passkeyStamper);

      // 2. Stamp a login request
      final loginResponse = await passkeyClient.stampLogin(
        input: TStampLoginBody(
          organizationId: organizationId ?? turnkeyProvider.config.organizationId,
            publicKey: generatedPublicKey,
            expirationSeconds: expirationSeconds.toString(),
        ),
      );

      final loginResult = loginResponse.activity.result.stampLoginResult;
      final sessionJwt = loginResult?.session;

      if (sessionJwt == null) {
        throw Exception('No session returned from stampLogin');
      }

      // 3. Store the new session
      await turnkeyProvider.storeSession(
        sessionJwt: sessionJwt,
        sessionKey: sessionKey,
      );

      // 4. Cleanup: delete the generated key pair (cleanup)
      await turnkeyProvider.deleteApiKeyPair(generatedPublicKey);
      generatedPublicKey = null;

      // 5. (Optional) notify caller / return something useful
      return;
    } finally {
      // Cleanup if something fails before deleting
      if (generatedPublicKey != null) {
        try {
          await turnkeyProvider.deleteApiKeyPair(generatedPublicKey);
        } catch (e) {
          debugPrint('Failed to cleanup generated key pair: $e');
        }
      }
    }
  }

  Future<void> loginWithOAuth({
    required String oidcToken,
    required String providerName,
    required String targetPublicKey,
    required String expirationSeconds,
  }) async {
    // setLoading('loginWithOAuth', true);
    // setError(null);

    // try {
    //   final response = await oAuthLogin({
    //     'oidcToken': oidcToken,
    //     'providerName': providerName,
    //     'targetPublicKey': targetPublicKey,
    //     'expirationSeconds': expirationSeconds,
    //   });
    //   if (response['credentialBundle'] != null) {
    //     await turnkeyProvider.storeSession(
    //         bundle: response['credentialBundle']);
    //   }
    // } catch (error) {
    //   setError(error.toString());
    // } finally {
    //   setLoading('loginWithOAuth', false);
    // }
  }

  Future<void> signInWithGoogle() async {
    // final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

    // final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();

    // await turnkeyProvider.handleGoogleOAuth(
    //     clientId: EnvConfig.googleClientId,
    //     nonce: nonce,
    //     scheme: EnvConfig.appScheme,
    //     onSuccess: (oidcToken) {
    //       loginWithOAuth(
    //           oidcToken: oidcToken,
    //           providerName: 'google',
    //           targetPublicKey: targetPublicKey,
    //           expirationSeconds:
    //               OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString());
    //     });
  }

  Future<void> signInWithApple() async {
    // Sign in with Apple leverages the sign_in_with_apple flutter package which uses Apple's native "Sign in with Apple" SDK on iOS.
    // setLoading('signInWithApple', true);

    // try {
    //   final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

    //   final credential = await SignInWithApple.getAppleIDCredential(scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ], nonce: sha256.convert(utf8.encode(targetPublicKey)).toString());
    //   final oidcToken = credential.identityToken;

    //   if (oidcToken == null) {
    //     throw Exception('Failed to get OIDC token');
    //   }

    //   final oAuthResponse = await oAuthLogin({
    //     'oidcToken': oidcToken,
    //     'providerName': 'Apple',
    //     'targetPublicKey': targetPublicKey,
    //     'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
    //   });

    //   if (oAuthResponse['credentialBundle'] != null) {
    //     await turnkeyProvider.storeSession(
    //         bundle: oAuthResponse['credentialBundle']);
    //     return;
    //   } else {
    //     throw Exception('No credential bundle returned');
    //   }
    // } catch (error) {
    //   setError(error.toString());
    // } finally {
    //   setLoading('signInWithApple', false);
    // }
  }
}
