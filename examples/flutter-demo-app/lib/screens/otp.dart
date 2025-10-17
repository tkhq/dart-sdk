import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';

import '../widgets/buttons.dart';

class OTPScreen extends StatefulWidget {
  final String otpId;
  final String? contact;
  final OtpType? otpType;

  const OTPScreen({
    super.key,
    required this.otpId,
    this.contact,
    this.otpType,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final turnkeyProvider =
        Provider.of<TurnkeyProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 350,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/images/logo.svg', height: 40),
              const SizedBox(height: 20),
              const Text(
                'Enter OTP Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Pinput(
                controller: _otpController,
                length: 6,
                isCursorAnimationEnabled: false,
                showCursor: false,
                pinAnimationType: PinAnimationType.fade,
                defaultPinTheme: PinTheme(
                  width: 45,
                  height: 60,
                  textStyle: const TextStyle(fontSize: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onCompleted: (value) => _otpController.text = value,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: LoadingButton(
                      isLoading: _isLoading,
                      text: 'Continue',
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        final otpCode = _otpController.text.trim();
                        if (otpCode.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please enter the OTP code'),
                            ),
                          );
                          return;
                        }

                        setState(() => _isLoading = true);

                        try {
                          await turnkeyProvider.loginOrSignUpWithOtp(
                            otpId: widget.otpId,
                            otpCode: otpCode,
                            contact: widget.contact!,
                            otpType: widget.otpType!,
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to verify OTP: $e'),
                            ),
                          );
                        } finally {
                          if (mounted) setState(() => _isLoading = false);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
