import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/turnkey.dart';
import 'buttons.dart';

class OAuthButtons extends StatelessWidget {
  const OAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: <Widget>[
        Expanded(
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return LoadingButton(
                onPressed: () {
                  turnkeyProvider.signInWithGoogle(context);
                },
                isLoading: turnkeyProvider.isLoading('signInWithGoogle'),
                child: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 20,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return LoadingButton(
                onPressed: () {
                  turnkeyProvider.signInWithApple(context);
                },
                isLoading: turnkeyProvider.isLoading('signInWithApple'),
                child: SvgPicture.asset(
                  'assets/images/apple.svg',
                  height: 20,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
