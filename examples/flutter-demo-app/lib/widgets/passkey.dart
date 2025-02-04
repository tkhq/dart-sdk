import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_flutter_demo_app/widgets/buttons.dart';

import '../providers/turnkey.dart';

class PasskeyInput extends StatelessWidget {
  const PasskeyInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return LoadingButton(
                onPressed: () {
                  if (!turnkeyProvider.isLoading('loginWithPasskey')) {
                    turnkeyProvider.loginWithPasskey(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rectangular shape
                    side: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                isLoading: turnkeyProvider.isLoading('loginWithPasskey'),
                text: 'Log in with passkey',
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return LoadingButton(
                onPressed: () {
                  if (!turnkeyProvider.isLoading('signUpWithPasskey')) {
                    turnkeyProvider.signUpWithPasskey(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rectangular shape
                  ),
                ),
                isLoading: turnkeyProvider.isLoading('signUpWithPasskey'),
                text: 'Sign up with passkey',
              );
            },
          ),
        ),
      ],
    );
  }
}
