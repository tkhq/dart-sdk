import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
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

  Future<void> signInWithGoogle() async {
    await turnkeyProvider.handleGoogleOAuth();
  }

  Future<void> signInWithApple() async {
    // Sign in with Apple leverages the sign_in_with_apple flutter package which uses Apple's native "Sign in with Apple" SDK on iOS.
    setLoading('signInWithApple', true);

    try {
      final targetPublicKey = await turnkeyProvider.createApiKeyPair();

      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ], nonce: sha256.convert(utf8.encode(targetPublicKey)).toString());
      final oidcToken = credential.identityToken;

      if (oidcToken == null) {
        throw Exception('Failed to get OIDC token');
      }

      final oAuthResponse = await turnkeyProvider.completeOAuth(
        publicKey: targetPublicKey,
        oidcToken: oidcToken,
        providerName: 'Apple',
      );
      await turnkeyProvider.storeSession(sessionJwt: oAuthResponse.sessionToken);
    } catch (error) {
      setError(error.toString());
    } finally {
      setLoading('signInWithApple', false);
    }
  }

  Future<void> signInWithX() async {
    await turnkeyProvider.handleXOAuth();
  }

  Future<void> signInWithDiscord() async {
    await turnkeyProvider.handleDiscordOAuth();
  }
}
