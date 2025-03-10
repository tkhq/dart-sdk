import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/widgets/buttons.dart';

import '../providers/auth.dart';

class PasskeyInput extends StatelessWidget {
  const PasskeyInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                onPressed: () {
                  if (!authRelayerProvider.isLoading('loginWithPasskey')) {
                    authRelayerProvider.loginWithPasskey();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                isLoading: authRelayerProvider.isLoading('loginWithPasskey'),
                text: 'Log in with passkey',
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                onPressed: () {
                  if (!authRelayerProvider.isLoading('signUpWithPasskey')) {
                    authRelayerProvider.signUpWithPasskey();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                isLoading: authRelayerProvider.isLoading('signUpWithPasskey'),
                text: 'Sign up with passkey',
              );
            },
          ),
        ),
      ],
    );
  }
}
