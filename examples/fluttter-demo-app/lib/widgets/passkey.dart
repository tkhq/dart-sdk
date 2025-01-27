import 'package:flutter/material.dart';

class PasskeyInput extends StatelessWidget {
  const PasskeyInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: double.infinity, // Set the width to fill the parent
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6), // Rectangular shape
                  side: BorderSide(color: Colors.black, width: 0.5)),
            ),
            child: Text('Log in with passkey'),
          ),
        ),
        SizedBox(height: 1),
        SizedBox(
          width: double.infinity, // Set the width to fill the parent
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6), // Rectangular shape
              ),
            ),
            child: Text('Sign up with passkey'),
          ),
        ),
      ],
    );
  }
}
