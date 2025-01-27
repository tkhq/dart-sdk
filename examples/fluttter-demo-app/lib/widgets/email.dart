import 'package:flutter/material.dart';
import 'package:turnkey_flutter_demo_app/screens/otp.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: 'Email',
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          width: double.infinity, // Set the width to fill the parent
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OTPScreen()),
              );
            },
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
