import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle label = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: MoColors.dustyGrey,
    letterSpacing: 0.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: Colors.black,
    letterSpacing: 0.48,
  );

  static const TextStyle labelLarge = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.black,
    letterSpacing: 0.8,
  );

  static const TextStyle sectionHeader = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    color: Colors.black,
    letterSpacing: 0.56,
  );

  static const TextStyle amountMedium = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: Colors.black,
    letterSpacing: 0.96,
  );

  static const TextStyle amountLarge = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    color: Colors.black,
    letterSpacing: 1.12,
  );

  static const TextStyle accent = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 8,
    color: MoColors.mainColor,
    letterSpacing: 0.32,
  );

   static const TextStyle ticketHeading = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: MoColors.mainColor,
  );

  static const TextStyle ticketText = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: Colors.black,
  );

  static const TextStyle ticketInfo = TextStyle(
    fontWeight: FontWeight.w400,
    color: MoColors.ticketInfo,
    fontSize: 10,
  );
}
