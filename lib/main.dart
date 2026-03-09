import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/app_version_bloc/update_bloc.dart';
import 'package:momaspayplus/bloc/auth_bloc/auth_cubit.dart';
import 'package:momaspayplus/core/app_entry.dart';
import 'package:momaspayplus/core/app_update_wrapper.dart';

import 'package:momaspayplus/utils/navigation.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferenceHelper.init();
  runApp(const MomasPayApp());
  debugPrint("Current flavor: $appFlavor");
}

class MomasPayApp extends StatelessWidget {
  const MomasPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUpdateBloc>(
          create: (context) => AppUpdateBloc()..checkForUpdate(),
        ),
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()..loadUser())
      ],
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        navigatorKey: NavigationService.navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Momas Pay',
        theme: ThemeConfig.buildCustomTheme(),
        home: const AppUpdateWrapper(child: AppEntry()),
      ),
    );
  }
}
