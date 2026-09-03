import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/auth/login.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton(
      {super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.green[700],
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}
