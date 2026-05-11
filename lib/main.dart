import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';

import 'package:momaspayplus/app/app.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/core/storage/shared_pref.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await SharedPreferenceHelper.init();
  getIt.registerLazySingleton(() => AuthCubit());
  await getIt<AuthCubit>().loadUser();

  runApp(const MomasPayApp());
}
