import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/config.dart';
import 'package:turnkey_flutter_demo_app/widgets/buttons.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

class PasskeyInput extends StatefulWidget {
  const PasskeyInput({super.key});

  @override
  PasskeyInputState createState() => PasskeyInputState();
}

class PasskeyInputState extends State<PasskeyInput> {
  bool _isSignUpLoading = false;
  bool _isLoginLoading = false;

  @override
  Widget build(BuildContext context) {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: LoadingButton(
            isLoading: _isLoginLoading,
            onPressed: () async {
              if (_isLoginLoading) return;

              setState(() => _isLoginLoading = true);

              try {
                print('rpId is ${EnvConfig.rpId}');
                await turnkeyProvider.loginWithPasskey(rpId: EnvConfig.rpId);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged in successfully!')),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Passkey login failed: $e')),
                );
              } finally {
                setState(() => _isLoginLoading = false);
              }
            },
            text: 'Log in with passkey',
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: LoadingButton(
            isLoading: _isSignUpLoading,
            onPressed: () async {
              if (_isSignUpLoading) return;

              setState(() => _isSignUpLoading = true);

              try {
                print('rpId is ${EnvConfig.rpId}');
                await turnkeyProvider.signUpWithPasskey(rpId: EnvConfig.rpId);

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sign up successful!')),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Passkey sign up failed: $e')),
                );
              } finally {
                setState(() => _isSignUpLoading = false);
              }
            },
            text: 'Sign up with passkey',
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
