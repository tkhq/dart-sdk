import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/screens/login.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'config.dart';
import 'providers/auth.dart';
import 'screens/dashboard.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Load the environment variables from the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();

  void onSessionSelected(Session session) {
    if (isValidSession(session)) {
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Logged in! Redirecting to the dashboard.'),
        ),
      );
    }
  }

  void onSessionCleared(Session session) {
    navigatorKey.currentState?.pushReplacementNamed('/');

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text('Logged out. Please login again.'),
      ),
    );
  }

  void onInitialized(Object? error) {
    if (error != null) {
      debugPrint('Turnkey initialization failed: $error');
      final context = navigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize Turnkey: $error'),
          ),
        );
      }
    } else {
      debugPrint('Turnkey initialized successfully');
    }
  }

  final turnkeyProvider = TurnkeyProvider(
    config: TurnkeyConfig(
      apiBaseUrl: EnvConfig.turnkeyApiUrl,
      authProxyBaseUrl: EnvConfig.authProxyUrl,
      authProxyConfigId: EnvConfig.authProxyConfigId,
      organizationId: EnvConfig.organizationId,
      appScheme: EnvConfig.appScheme,
      onSessionSelected: onSessionSelected,
      onSessionCleared: onSessionCleared,
      onInitialized: onInitialized,
    ),
  );

  // This serves the same purpose as the `onInitialized` callback.
  turnkeyProvider.ready.then((_) {
    debugPrint('Turnkey is ready');
  }).catchError((error) {
    debugPrint('Caught from .ready: $error');
    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during Turnkey initialization: $error'),
        ),
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => turnkeyProvider),
        ChangeNotifierProxyProvider<TurnkeyProvider, AuthRelayerProvider>(
          create: (context) => AuthRelayerProvider(
            turnkeyProvider:
                Provider.of<TurnkeyProvider>(context, listen: false),
          ),
          update: (context, turnkeyProvider, previous) =>
              AuthRelayerProvider(turnkeyProvider: turnkeyProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 26, 255),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Turnkey Flutter Demo App'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final authRelayerProvider =
        Provider.of<AuthRelayerProvider>(context, listen: false);

    void showAuthRelayerProviderErrors() {
      if (authRelayerProvider.errorMessage != null) {
        debugPrint(authRelayerProvider.errorMessage.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error has occurred:\n${authRelayerProvider.errorMessage.toString()}',
            ),
          ),
        );
        authRelayerProvider.setError(null);
      }
    }

    authRelayerProvider.addListener(showAuthRelayerProviderErrors);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const LoginScreen(),
    );
  }
}
