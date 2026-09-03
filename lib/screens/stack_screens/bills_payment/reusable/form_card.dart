

import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class FormCard extends StatelessWidget {
  const FormCard({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MoColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MoColors.borderIdle, width: 1),
      ),
      child: child,
    );
  }
}