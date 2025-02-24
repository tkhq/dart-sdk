import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// ignore: implementation_imports
import 'package:intl_phone_number_input/src/models/country_list.dart';

import '../providers/auth.dart';
import 'buttons.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  PhoneNumber initialNumber = PhoneNumber(isoCode: 'US');
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  final unsupportedCountryCodes = [
    "+93", // Afghanistan
    "+964", // Iraq
    "+963", // Syria
    "+249", // Sudan
    "+98", // Iran
    "+850", // North Korea
    "+53", // Cuba
    "+250", // Rwanda
    "+379", // Vatican City
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
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: InternationalPhoneNumberInput(
            textAlignVertical: TextAlignVertical.top,
            onInputChanged: (PhoneNumber number) {
              setState(() {
                _phoneNumber = number;
              });
            },
            initialValue: initialNumber,
            selectorConfig: SelectorConfig(
              trailingSpace: false,
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            formatInput: true,
            countries: getAllowedCountryCodes(),
            inputDecoration: InputDecoration(
              hintText: 'Phone number',
              border: InputBorder.none,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Consumer<AuthRelayerProvider>(
            builder: (context, authRelayerProvider, child) {
              return LoadingButton(
                isLoading: authRelayerProvider.isLoading('initPhoneLogin'),
                onPressed: () async {
                  if (_phoneNumber.phoneNumber != null &&
                      _phoneNumber.phoneNumber!.isNotEmpty) {
                    await authRelayerProvider.initPhoneLogin(
                        context, _phoneNumber.phoneNumber!);
                  } else {
                    // Show an error message if phone number box is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a phone number')),
                    );
                  }
                },
                text: 'Continue',
              );
            },
          ),
        ),
      ],
    );
  }
}
