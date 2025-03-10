import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import 'buttons.dart';

class OAuthButtons extends StatelessWidget {
  const OAuthButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: <Widget>[
        Expanded(
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                onPressed: () {
                  authRelayerProvider.signInWithGoogle();
                },
                isLoading: authRelayerProvider.isLoading('signInWithGoogle'),
                child: SvgPicture.asset(
                  'assets/images/google.svg',
                  height: 20,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                onPressed: () {
                  authRelayerProvider.signInWithApple();
                },
                isLoading: authRelayerProvider.isLoading('signInWithApple'),
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
