import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/turnkey.dart';

class PasskeyInput extends StatelessWidget {
  const PasskeyInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity, // Set the width to fill the parent
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return ElevatedButton(
                onPressed: turnkeyProvider.isLoading('loginWithPasskey')
                    ? null
                    : () async {
                        await turnkeyProvider.loginWithPasskey(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rectangular shape
                    side: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                child: turnkeyProvider.isLoading('loginWithPasskey')
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      )
                    : Text('Log in with passkey'),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          //TODO: Replace with loader button
          width: double.infinity, // Set the width to fill the parent
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return TextButton(
                onPressed: turnkeyProvider.isLoading('signUpWithPasskey')
                    ? null
                    : () async {
                        await turnkeyProvider.signUpWithPasskey(context);
                      },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6), // Rectangular shape
                  ),
                ),
                child: turnkeyProvider.isLoading('signUpWithPasskey')
                    ? CircularProgressIndicator()
                    : Text('Sign up with passkey'),
              );
            },
          ),
        ),
      ],
    );
  }
}
