import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/screens/login.dart';
import 'config.dart';
import 'providers/session.dart';
import 'providers/turnkey.dart';
import 'screens/dashboard.dart';

void main() async {
  // Load the environment variables from the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();

  runApp(
    // TurnkeyProvider depends on SessionProvider, so we need to provide it first
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProxyProvider<SessionProvider, TurnkeyProvider>(
          create: (context) => TurnkeyProvider(
              sessionProvider:
                  Provider.of<SessionProvider>(context, listen: false)),
          update: (context, sessionProvider, previous) =>
              TurnkeyProvider(sessionProvider: sessionProvider),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 0, 26, 255)),
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
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    // These two functions have to be here instead of their respective classes because they rely on the context
    void showTurnkeyProviderErrors() {
      if (turnkeyProvider.errorMessage != null) {
        debugPrint(turnkeyProvider.errorMessage.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'An error has occurred: \n${turnkeyProvider.errorMessage.toString()}'),
          ),
        );

        turnkeyProvider.setError(null);
      }
    }

    void autoLogin() {
      if (sessionProvider.session != null &&
          sessionProvider.session!.expiry >
              DateTime.now().millisecondsSinceEpoch) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in! Redirecting to the dashboard.'),
          ),
        );
      }
    }

    turnkeyProvider.addListener(showTurnkeyProviderErrors);
    sessionProvider.addListener(autoLogin);

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: LoginScreen());
  }
}
