import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/models/country_list.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';
import 'package:turnkey_sdk_flutter/turnkey_sdk_flutter.dart';
import 'buttons.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  PhoneNumberInputState createState() => PhoneNumberInputState();
}

class PhoneNumberInputState extends State<PhoneNumberInput> {
  PhoneNumber initialNumber = PhoneNumber(isoCode: 'US');
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');
  bool _isLoading = false;

  final unsupportedCountryCodes = [
    '+93', // Afghanistan
    '+964', // Iraq
    '+963', // Syria
    '+249', // Sudan
    '+98', // Iran
    '+850', // North Korea
    '+53', // Cuba
    '+250', // Rwanda
    '+379', // Vatican City
  ];

  List<String> getAllowedCountryCodes() {
    return Countries.countryList
        .where((country) =>
            country['dial_code'] != null &&
            country['alpha_2_code'] != null &&
            !unsupportedCountryCodes.contains(country['dial_code']))
        .map((country) => country['alpha_2_code'] as String)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final turnkeyProvider = Provider.of<TurnkeyProvider>(context, listen: false);

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: InternationalPhoneNumberInput(
            textAlignVertical: TextAlignVertical.top,
            onInputChanged: (PhoneNumber number) {
              setState(() => _phoneNumber = number);
            },
            initialValue: initialNumber,
            selectorConfig: const SelectorConfig(
              trailingSpace: false,
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            formatInput: true,
            countries: getAllowedCountryCodes(),
            inputDecoration: const InputDecoration(
              hintText: 'Phone number',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: LoadingButton(
            isLoading: _isLoading,
            onPressed: () async {
              final phone = _phoneNumber.phoneNumber?.trim() ?? '';

              if (phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a phone number')),
                );
                return;
              }

              setState(() => _isLoading = true);

              try {
                final otpId = await turnkeyProvider.initOtp(
                  otpType: OtpType.SMS,
                  contact: phone,
                );

                // we need to ensure widget is still mounted before using context
                if (!context.mounted) return;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OTPScreen(
                      otpId: otpId,
                      contact: phone,
                      otpType: OtpType.SMS,
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
