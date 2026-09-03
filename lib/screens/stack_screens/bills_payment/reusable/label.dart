import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class Label extends StatelessWidget {
  final String text;

  const Label({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: MoColors.textSecondary,
      ),
    );
  }
}