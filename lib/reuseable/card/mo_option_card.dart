import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

enum MoCardTrailing {
  navigate,
  external,
}

class MoOptionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onTap;
  final MoCardTrailing trailing;

  const MoOptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onTap,
    this.trailing = MoCardTrailing.navigate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: MoColors.mainColor.withOpacity(0.06),
        highlightColor: MoColors.mainColor.withOpacity(0.04),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MoColors.borderIdle, width: 1),
          ),
          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MoColors.mainColorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: MoColors.mainColor, size: 20),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: MoColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              description,
              style: const TextStyle(
                color: MoColors.textSecondary,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              trailing == MoCardTrailing.external
                  ? Icons.open_in_new_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: MoColors.textHint,
              size: trailing == MoCardTrailing.external ? 16 : 13,
            ),
          ),
        ),
      ),
    );
  }
}