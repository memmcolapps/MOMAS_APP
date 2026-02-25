import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/app_version_bloc/update_bloc.dart';

import 'package:momaspayplus/core/app_entry.dart';
import 'package:momaspayplus/core/app_update_wrapper.dart';
import 'package:momaspayplus/domain/repository/app_update_repository.dart';
import 'package:momaspayplus/utils/navigation.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.light,
  //   statusBarBrightness: Brightness.dark
  // ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  await SharedPreferenceHelper.init();
  runApp(const MomasPayApp());
  debugPrint("Current flavor: $appFlavor");
}

class MomasPayApp extends StatelessWidget {
  const MomasPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppUpdateBloc>(
      create: (context) => AppUpdateBloc()..checkForUpdate(),
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
