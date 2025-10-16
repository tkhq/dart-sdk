import 'package:flutter/material.dart';

class OrSeperator extends StatelessWidget {
  const OrSeperator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
