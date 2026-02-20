import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:momaspayplus/app_entry.dart';
import 'package:momaspayplus/utils/navigation.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/theme.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent,
  //   statusBarIconBrightness: Brightness.light,
  //   statusBarBrightness: Brightness.dark
  // ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferenceHelper.init();
  runApp(const MomasPayApp());
}

class MomasPayApp extends StatelessWidget {
  const MomasPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Momas Pay',
      theme: ThemeConfig.buildCustomTheme(),
      home: const AppEntry(),
    );
  }
}
