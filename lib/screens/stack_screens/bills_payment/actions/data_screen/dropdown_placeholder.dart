import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class DropdownPlaceholder extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isLoading;

  const DropdownPlaceholder({
    super.key,
    required this.icon,
    required this.message,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: MoColors.cardBgAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: MoColors.borderIdle, width: 1),
      ),
      child: Row(
        children: [
          if (isLoading)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(MoColors.mainColor),
              ),
            )
          else
            Icon(icon, size: 16, color: MoColors.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: MoColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}