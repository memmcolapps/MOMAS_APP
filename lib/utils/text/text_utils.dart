import 'dart:ui';

import 'package:momaspayplus/utils/colors.dart';

class TextUtils {

  static double percentSpacing(double fontSize, double percent) {
    return fontSize * (percent / 100);
  }

  static TextStyle? label({
    double fontSize = 10,
    Color? color,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacingPercent = 4,
  }) {
    return TextStyle(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? MoColors.dustyGrey,
      letterSpacing: percentSpacing(fontSize, letterSpacingPercent),
    );
  }

  // static TextStyle ({
  //   double fontSize = 10,
  //   Color? color,
  //   FontWeight fontWeight = FontWeight.w600,
  //   double letterSpacingPercent = 4,
  // }) {
  //   return TextStyle(
  //     fontWeight: fontWeight,
  //     fontSize: fontSize,
  //     color: color ?? MoColors.dustyGrey,
  //     letterSpacing: percentSpacing(fontSize, letterSpacingPercent),
  //   );
  // }

}