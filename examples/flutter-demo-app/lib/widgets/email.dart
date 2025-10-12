import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'buttons.dart';

class EmailInput extends StatefulWidget {
  const EmailInput({super.key});

  @override
  EmailInputState createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final turnkeyProvider = Provider.of<TurnkeyProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        TextField(
          controller: _emailController,
          autocorrect: false,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: 'Email',
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: LoadingButton(
            isLoading: _isLoading,
            onPressed: () async {
              final email = _emailController.text.trim();
              if (email.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an email address')),
                );
                return;
              }

              setState(() => _isLoading = true);

              try {               
                final otpId = await turnkeyProvider.initOtp(
                  otpType: OtpType.Email,
                  contact: email,
                );

                // we need to ensure widget is still mounted before using context
                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPScreen(
                      otpId: otpId,
                      contact: email,
                      otpType: OtpType.Email,
                    ),
                  ),
                );
                
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to send OTP: $e')),
                );
              } finally {
                  setState(() => _isLoading = false);
              }
            },
            text: 'Continue',
          ),
        ),
      ],
    );
  }
}
