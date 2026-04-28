import 'package:flutter/material.dart';

import 'package:momaspayplus/features/auth/screens/auth_screen.dart';
import 'package:momaspayplus/features/onboarding/screens/intro_page.dart';

import 'package:momaspayplus/utils/shared_pref.dart';

class AppEntry extends StatelessWidget {
  const  AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return
        SharedPreferenceHelper.hasSeenOnboarding
            ? const AuthScreen()
            : const IntroPage();
  }
}
