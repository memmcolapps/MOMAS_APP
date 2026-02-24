import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:momaspayplus/screens/auth/login.dart';
import 'package:momaspayplus/screens/home_page/intro_page/intro_page.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

// import 'bloc/registeration_bloc/register_bloc.dart';
//
// import 'domain/repository/auth_repository.dart';
// import 'domain/service/auth_service.dart';

class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  @override
  Widget build(BuildContext context) {
    return
      // MultiBlocProvider(
      //   providers: [
      //     BlocProvider(
      //       create: (context) => RegisterBloc(AuthService(AuthRepository())),
      //     ),
      //   ],
      //   child:
        SharedPreferenceHelper.hasSeenOnboarding
            ? const LoginScreen()
            : const IntroPage();
    // );
  }
}
