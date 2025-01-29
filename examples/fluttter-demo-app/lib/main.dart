import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/screens/login.dart';
import 'config.dart';
import 'providers/session.dart';
import 'providers/turnkey.dart';

void main() async {
  // Load the environment variables from the .env file
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SessionProvider()),
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
      home: const MyHomePage(title: 'Turnkey Flutter Demo App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Consumer<TurnkeyProvider>(
        //TODO: maybe we should just show a snackbar from the TurnkeyProvider when an error occurs
        builder: (context, turnkeyProvider, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (turnkeyProvider.errorMessage != null) {
              print(turnkeyProvider.errorMessage);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'An error has occurred: \n${turnkeyProvider.errorMessage!}')),
              );

              turnkeyProvider.setError(null);
            }
          });

          return Center(
            child: LoginScreen(),
          );
        },
      ),
    );
  }
}
