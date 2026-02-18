import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class ThemeConfig {
  static ThemeData buildCustomTheme() {
    final ColorScheme colorScheme = ColorScheme(
      primary: MoColors.mainColor,
      secondary: Colors.orange,
      surface: Colors.white,
      // background: Colors.grey[200],
      error: Colors.red,
      onPrimary: MoColors.mainColor,
      onSecondary: MoColors.mainColor.withValues(alpha: 0.1),
      onSurface: MoColors.mainColor,
      onError: Colors.red,
      brightness: Brightness.light,
    );
    final ThemeData base = ThemeData(fontFamily: "Effra");
    return base.copyWith(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MoColors.mainColor,
        selectionColor: MoColors.mainColor.withValues(alpha: 0.5),
        selectionHandleColor: MoColors.mainColor,
      ),
      colorScheme: colorScheme,
      primaryColor: MoColors.mainColor,
      scaffoldBackgroundColor: Colors.grey[200],
      appBarTheme: AppBarTheme(
        backgroundColor: MoColors.mainColor,
        // systemOverlayStyle:  const SystemUiOverlayStyle (
        //   statusBarIconBrightness: Brightness.light,
        //   statusBarBrightness: Brightness.dark,
        // ),
        iconTheme: IconThemeData(
          color: MoColors.whiteColor,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: MoColors.mainColor,
        textTheme: ButtonTextTheme.primary,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.orange,
      ),
    );
  }
}
