import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

import '../providers/auth.dart';
import 'buttons.dart';

class EmailInput extends StatefulWidget {
  const EmailInput({super.key});

  @override
  _EmailInputState createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _emailController,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: 'Email',
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                isLoading: authRelayerProvider.isLoading('initEmailLogin'),
                onPressed: () async {
                  final email = _emailController.text;
                  if (email.isNotEmpty) {
                    await authRelayerProvider.initOtpLogin(context,
                        otpType: OtpType.Email, contact: email);
                  } else {
                    // Show an error message if the email is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter an email address')),
                    );
                  }
                },
                text: 'Continue',
              );
            },
          ),
        ),
      ],
    );
  }
}
