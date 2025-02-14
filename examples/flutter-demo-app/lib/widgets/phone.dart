import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';

import '../providers/turnkey.dart';
import 'buttons.dart';

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  final TextEditingController _phoneInputController = TextEditingController();
  String _selectedCountryCode = '+1';

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

  List<Map<String, String>> getAllowedCountries() {
    return codes
        .where((country) =>
            !unsupportedCountryCodes.contains(country['dial_code']))
        .toList();
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length == 10 && !phoneNumber.contains(RegExp(r'[()-]'))) {
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)}-${phoneNumber.substring(6)}';
    }
    return phoneNumber;
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    _selectedCountryCode = country.dialCode!;
                  });
                },
                padding: EdgeInsets.zero,
                pickerStyle: PickerStyle.dialog,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                initialSelection: 'US',
                favorite: ['US', 'CA'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                countryFilter: getAllowedCountries()
                    .map((country) => country['code']!)
                    .toList(),
              ),
              Expanded(
                child: TextField(
                  controller: _phoneInputController,
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      _phoneInputController.text = formatPhoneNumber(value);
                      _phoneInputController.selection =
                          TextSelection.fromPosition(
                        TextPosition(offset: _phoneInputController.text.length),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: Consumer<TurnkeyProvider>(
            builder: (context, turnkeyProvider, child) {
              return LoadingButton(
                isLoading: turnkeyProvider.isLoading('initPhoneLogin'),
                onPressed: () async {
                  final phoneNumber =
                      '$_selectedCountryCode ${_phoneInputController.text}';
                  if (_phoneInputController.text.isNotEmpty) {
                    await turnkeyProvider.initPhoneLogin(context, phoneNumber);
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
