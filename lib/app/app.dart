import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:momaspayplus/core/cubit/app_version_cubit/update_cubit.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_state.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';

import 'package:momaspayplus/app/app_entry.dart';
import 'package:momaspayplus/core/app_update_wrapper.dart';
import 'package:momaspayplus/features/auth/screens/auth_screen.dart';
import 'package:momaspayplus/main.dart';
import 'package:momaspayplus/tabs/root_screen.dart';

import 'package:momaspayplus/utils/navigation.dart';
import 'package:momaspayplus/utils/theme.dart';

import 'package:momaspayplus/features/auth/screens/auth_screen.dart';
import 'package:momaspayplus/features/onboarding/screens/intro_page.dart';

import 'package:momaspayplus/utils/shared_pref.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MomasPayApp extends StatelessWidget {
  const MomasPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUpdateCubit>(
          create: (context) => AppUpdateCubit()..checkForUpdate(),
        ),
        BlocProvider<TabCubit>(create: (_) => TabCubit()),
        BlocProvider.value(value: getIt<AuthCubit>()),
      ],
      child: _MomasPayView(),
    );
  }
}

class _MomasPayView extends StatefulWidget {
  const _MomasPayView();

  @override
  State<_MomasPayView> createState() => _MomasPayViewState();
}

class _MomasPayViewState extends State<_MomasPayView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final home = switch (state) {
          AuthAuthenticated() => AppUpdateWrapper(child: const RootScreen()),
          AuthUnauthenticated() => const AuthScreen(),
          _ => SharedPreferenceHelper.hasSeenOnboarding
              ? const AuthScreen()
              : const IntroPage(),
        };

        return MaterialApp(
          navigatorObservers: [routeObserver],
          navigatorKey: NavigationService.navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Momas Pay',
          theme: ThemeConfig.buildCustomTheme(),
          home: home,
        );
      },
    );
  }
}

// class _MomasPayView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         log(" >>>>> log ${state.toString()}");
//         final home = switch (state) {
//           AuthAuthenticated() => AppUpdateWrapper(child: const RootScreen()),
//           AuthUnauthenticated() => const AuthScreen(),
//           _ => SharedPreferenceHelper.hasSeenOnboarding
//               ? const AuthScreen()
//               : const IntroPage(),
//         };
//
//         return MaterialApp(
//           navigatorObservers: [routeObserver],
//           navigatorKey: NavigationService.navigatorKey,
//           debugShowCheckedModeBanner: false,
//           title: 'Momas Pay',
//           theme: ThemeConfig.buildCustomTheme(),
//           home: home,
//         );
//       },
//     );
//   }
// }