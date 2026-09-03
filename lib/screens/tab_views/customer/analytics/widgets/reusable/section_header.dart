import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionHeader),
        if (trailing != null) trailing!,
      ],
    );
  }
}