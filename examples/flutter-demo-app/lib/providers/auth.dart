import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:turnkey_flutter_passkey_stamper/turnkey_flutter_passkey_stamper.dart';
import 'package:uuid/uuid.dart';
import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:turnkey_flutter_demo_app/utils/turnkey_rpc.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

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
      {required OtpType otpType, required String contact}) async {
    setLoading(
        otpType == OtpType.Email ? 'initEmailLogin' : 'initPhoneLogin', true);
    setError(null);

    try {
      final response = await initOTPAuth({
        'otpType': otpType.value,
        'contact': contact,
      });

      if (response != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(
              otpId: response['otpId'],
              organizationId: response['organizationId'],
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
    required String organizationId,
  }) async {
    if (otpCode.isNotEmpty) {
      setLoading('completeOtpAuth', true);
      setError(null);

      try {
        final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

        final response = await otpAuth({
          'otpId': otpId,
          'otpCode': otpCode,
          'organizationId': organizationId,
          'targetPublicKey': targetPublicKey,
          'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
          'invalidateExisting': false,
        });

        if (response['credentialBundle'] != null) {
          await turnkeyProvider.createSession(
              bundle: response['credentialBundle']);
        }
      } catch (error) {
        setError(error.toString());
      } finally {
        setLoading('completeOtpAuth', false);
      }
    }
  }

  Future<void> signUpWithPasskey() async {
    // Sign up with Passkey will create a new sub-org, device passkey and read-write session for the user. This function ultimately requires two 'passkey taps' from the user
    setLoading('signUpWithPasskey', true);
    setError(null);
    final uuid = Uuid();

    try {
      final authenticationParams = await createPasskey(PasskeyRegistrationConfig(
          rp: {
            'id': EnvConfig.rpId,
            'name': 'Flutter test app',
          },
          user: {
            'id': uuid.v4(),
            'name': 'Anonymous User',
            'displayName': 'Anonymous User',
          },
          authenticatorName:
              'End-User Passkey')); // Creating a passkey initiates one 'passkey tap'

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

        final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

        final sessionResponse = await httpClient.createReadWriteSession(
            // Creating a read-write session initiates a 'passkey tap' to stamp the request to Turnkey
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
          await turnkeyProvider.createSession(bundle: credentialBundle);
        }
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('signUpWithPasskey', false);
    }
  }

  Future<void> loginWithPasskey() async {
    // Login with Passkey will create a new read-write session for the user using an existing passkey. This function ultimately requires one 'passkey tap' from the user
    setLoading('loginWithPasskey', true);
    setError(null);

    try {
      final stamper =
          PasskeyStamper(PasskeyStamperConfig(rpId: EnvConfig.rpId));
      final httpClient = TurnkeyClient(
          config: THttpConfig(baseUrl: EnvConfig.turnkeyApiUrl),
          stamper: stamper);

      final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

      final sessionResponse = await httpClient.createReadWriteSession(
          // Creating a read-write session initiates a 'passkey tap' to stamp the request to Turnkey
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
        await turnkeyProvider.createSession(bundle: credentialBundle);
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('loginWithPasskey', false);
    }
  }

  Future<void> loginWithOAuth({
    required String oidcToken,
    required String providerName,
    required String targetPublicKey,
    required String expirationSeconds,
  }) async {
    setLoading('loginWithOAuth', true);
    setError(null);

    try {
      final response = await oAuthLogin({
        'oidcToken': oidcToken,
        'providerName': providerName,
        'targetPublicKey': targetPublicKey,
        'expirationSeconds': expirationSeconds,
      });
      if (response['credentialBundle'] != null) {
        await turnkeyProvider.createSession(
            bundle: response['credentialBundle']);
      }
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('loginWithOAuth', false);
    }
  }

  Future<void> signInWithGoogle() async {
    final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

    final nonce = sha256.convert(utf8.encode(targetPublicKey)).toString();

    await turnkeyProvider.handleGoogleOAuth(
        clientId: EnvConfig.googleClientId,
        nonce: nonce,
        scheme: EnvConfig.appScheme,
        onSuccess: (oidcToken) {
          loginWithOAuth(
              oidcToken: oidcToken,
              providerName: 'google',
              targetPublicKey: targetPublicKey,
              expirationSeconds:
                  OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString());
        });
  }

  Future<void> signInWithApple() async {
    // Sign in with Apple leverages the sign_in_with_apple flutter package which uses Apple's native "Sign in with Apple" SDK on iOS.
    setLoading('signInWithApple', true);

    try {
      final targetPublicKey = await turnkeyProvider.createEmbeddedKey();

      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ], nonce: sha256.convert(utf8.encode(targetPublicKey)).toString());
      final oidcToken = credential.identityToken;

      if (oidcToken == null) {
        throw Exception('Failed to get OIDC token');
      }

      final oAuthResponse = await oAuthLogin({
        'oidcToken': oidcToken,
        'providerName': 'Apple',
        'targetPublicKey': targetPublicKey,
        'expirationSeconds': OTP_AUTH_DEFAULT_EXPIRATION_SECONDS.toString(),
      });

      if (oAuthResponse['credentialBundle'] != null) {
        await turnkeyProvider.createSession(
            bundle: oAuthResponse['credentialBundle']);
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
