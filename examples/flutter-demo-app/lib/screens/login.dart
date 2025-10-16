import 'package:flutter/material.dart';
import 'package:turnkey_flutter_demo_app/widgets/email.dart';
import 'package:turnkey_flutter_demo_app/widgets/oauth.dart';
import 'package:turnkey_flutter_demo_app/widgets/or_seperator.dart';
import 'package:turnkey_flutter_demo_app/widgets/passkey.dart';
import 'package:turnkey_flutter_demo_app/widgets/phone.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Log in or sign up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  OAuthButtons(),
                  OrSeperator(),
                  EmailInput(),
                  OrSeperator(),
                  PhoneNumberInput(),
                  OrSeperator(),
                  PasskeyInput(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
