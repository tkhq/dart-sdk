import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/screens/login.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

import 'config.dart';
import 'screens/dashboard.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();

  void onSessionSelected(Session session) {
    if (isValidSession(session)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
        final ctx = navigatorKey.currentContext;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
              content: Text('Logged in! Redirecting to the dashboard.'),
            ),
          );
        }
      });
    }
  }

  void onSessionCleared(Session session) {
    navigatorKey.currentState?.pushReplacementNamed('/');
    final ctx = navigatorKey.currentContext;
    if (ctx != null) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Logged out. Please login again.'),
        ),
      );
    }
  }

  final createSubOrgParams = CreateSubOrgParams(
    customWallet: CustomWallet(
      walletName: 'Wallet 1',
      walletAccounts: [
        v1WalletAccountParams(
          addressFormat: v1AddressFormat.address_format_ethereum,
          path: "m/44'/60'/0'/0/0",
          curve: v1Curve.curve_secp256k1,
          pathFormat: v1PathFormat.path_format_bip32,
        ),
        v1WalletAccountParams(
          addressFormat: v1AddressFormat.address_format_solana,
          path: "m/44'/501'/0'/0'",
          curve: v1Curve.curve_ed25519,
          pathFormat: v1PathFormat.path_format_bip32,
        ),
      ],
    ),
  );

  final turnkeyProvider = TurnkeyProvider(
    config: TurnkeyConfig(
      apiBaseUrl: EnvConfig.turnkeyApiUrl,
      authProxyBaseUrl: EnvConfig.authProxyUrl,
      authProxyConfigId: EnvConfig.authProxyConfigId,
      organizationId: EnvConfig.organizationId,
      appScheme: EnvConfig.appScheme,
      authConfig: AuthConfig(
        createSubOrgParams: MethodCreateSubOrgParams(
          emailOtpAuth: createSubOrgParams,
          smsOtpAuth: createSubOrgParams,
          oAuth: createSubOrgParams,
          passkeyAuth: createSubOrgParams,
        ),
        oAuthConfig: OAuthConfig(
          googleClientId: EnvConfig.googleClientId,
          appleClientId: EnvConfig.appleClientId,
          xClientId: EnvConfig.xClientId,
          discordClientId: EnvConfig.discordClientId,
        ),
      ),
      onSessionSelected: onSessionSelected,
      onSessionCleared: onSessionCleared,
    ),
  );

  turnkeyProvider.ready.catchError((error) {
    debugPrint('Caught from .ready: $error');

    // Schedule the snackbar to show after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = navigatorKey.currentState;
      if (state != null && state.mounted) {
        ScaffoldMessenger.of(state.context).showSnackBar(
          SnackBar(
              content: Text('Error during Turnkey initialization: $error')),
        );
      }
    });
  });

  runApp(
    ChangeNotifierProvider(
      create: (_) => turnkeyProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TurnkeyProvider>(
      builder: (context, turnkey, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 26, 255),
            ),
            useMaterial3: true,
          ),
          home: _buildHome(turnkey),
        );
      },
    );
  }

  Widget _buildHome(TurnkeyProvider turnkey) {
    switch (turnkey.authState) {
      case AuthState.loading:
        // Provider is booting: show splash / spinner.
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );

      default:
        // Turnkey is ready. Show the login screen.
        return Scaffold(
          appBar: AppBar(
            title: Text('Turnkey Flutter Demo App'),
          ),
          body: LoginScreen(),
        );
      // We'll have the `onSessionSelected` callback navigate to the dashboard screen. You can also add another case here for AuthState.authenticated if you want to handle it directly.
    }
  }
}
