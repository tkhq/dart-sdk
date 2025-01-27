import 'package:flutter/material.dart';

class Country {
  final String name;
  final String flag;
  final String code;

  Country({required this.name, required this.flag, required this.code});
}

class PhoneNumberInput extends StatefulWidget {
  const PhoneNumberInput({super.key});

  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  static final List<Country> _countries = [
    Country(name: 'United States', flag: '🇺🇸', code: '+1'),
    Country(name: 'Canada', flag: '🇨🇦', code: '+1'),
  ];

  Country _selectedCountry = _countries[0];

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
              DropdownButton<Country>(
                value: _selectedCountry,
                items: _countries.map((Country country) {
                  return DropdownMenuItem<Country>(
                    value: country,
                    child: Text('${country.flag} ${country.code}'),
                  );
                }).toList(),
                onChanged: (Country? newValue) {
                  setState(() {
                    _selectedCountry = newValue!;
                  });
                },
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity, // Set the width to fill the parent
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // Rectangular shape
              ),
            ),
            child: Text('Continue'),
          ),
        ),
      ],
    );
  }
}
