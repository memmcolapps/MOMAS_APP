import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';

class InitialsAvatar extends StatelessWidget {
  final User? user;
  const InitialsAvatar({super.key, required this.user});

  String _initials() {
    final first = user?.firstName?.trim() ?? '';
    final last = user?.lastName?.trim() ?? '';

    if (first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    if (first.isNotEmpty) return first[0].toUpperCase();
    if (last.isNotEmpty) return last[0].toUpperCase();

    // Fallback: first char of email local part
    final email = user?.email?.trim() ?? '';
    if (email.isNotEmpty) return email[0].toUpperCase();

    return '?'; // Absolute last resort
  }

  @override
  Widget build(BuildContext context) {
    final initials = _initials();
    final bool hasInitials = initials != '?';

    return CircleAvatar(
      radius: 26,
      backgroundColor:
          Colors.white.withValues(alpha: hasInitials ? 0.25 : 0.15),
      child: hasInitials
          ? Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            )
          : const Icon(
              Icons.person_outline_rounded,
              color: Colors.white,
              size: 26,
            ),
    );
  }
}
