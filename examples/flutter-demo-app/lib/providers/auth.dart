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
