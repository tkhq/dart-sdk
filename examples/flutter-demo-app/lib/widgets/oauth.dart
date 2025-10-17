import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

import '../widgets/buttons.dart';

class OAuthButtons extends StatefulWidget {
  const OAuthButtons({super.key});

  @override
  State<OAuthButtons> createState() => _OAuthButtonsState();
}

class _OAuthButtonsState extends State<OAuthButtons> {
  bool _googleLoading = false;
  bool _appleLoading = false;
  bool _xLoading = false;
  bool _discordLoading = false;

  Future<void> _handleOAuth(
    Future<void> Function() action,
    void Function(bool) setLoading,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    setLoading(true);
    try {
      await action();
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('OAuth sign-in failed: $e')),
      );
    } finally {
      if (mounted) setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: LoadingButton(
            isLoading: _googleLoading,
            onPressed: () => _handleOAuth(
              () => turnkeyProvider.handleGoogleOAuth(),
              (val) => setState(() => _googleLoading = val),
            ),
            child: SvgPicture.asset('assets/images/google.svg', height: 20),
          ),
        ),
        Expanded(
          child: LoadingButton(
            isLoading: _appleLoading,
            onPressed: () => _handleOAuth(
              () => turnkeyProvider.handleAppleOAuth(),
              (val) => setState(() => _appleLoading = val),
            ),
            child: SvgPicture.asset('assets/images/apple.svg', height: 20),
          ),
        ),
        Expanded(
          child: LoadingButton(
            isLoading: _xLoading,
            onPressed: () => _handleOAuth(
              () => turnkeyProvider.handleXOAuth(),
              (val) => setState(() => _xLoading = val),
            ),
            child: SvgPicture.asset('assets/images/xtwitter.svg', height: 20),
          ),
        ),
        Expanded(
          child: LoadingButton(
            isLoading: _discordLoading,
            onPressed: () => _handleOAuth(
              () => turnkeyProvider.handleDiscordOAuth(),
              (val) => setState(() => _discordLoading = val),
            ),
            child: SvgPicture.asset('assets/images/discord.svg', height: 20),
          ),
        ),
      ],
    );
  }
}
