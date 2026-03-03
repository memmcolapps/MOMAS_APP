import 'package:flutter/material.dart';

import 'package:momaspayplus/screens/auth/login.dart';
import 'package:momaspayplus/screens/home_page/intro_page/intro_page.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

class AppEntry extends StatelessWidget {
  const  AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return
        SharedPreferenceHelper.hasSeenOnboarding
            ? const LoginScreen()
            : const IntroPage();
    // );
  }
}
