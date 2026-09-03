import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/app_update/bloc/update_state.dart';
import 'package:momaspayplus/features/app_update/data/repositories/app_update_repository.dart';
import 'package:momaspayplus/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateCubit extends Cubit<AppUpdateState> {
  // final AppUpdateRepository appUpdateRepository;

  AppUpdateCubit() : super(const AppUpdateInitial());

  Future<void> checkForUpdate() async {
    if (state is AppUpdateLoading) return;

    emit(const AppUpdateLoading());

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await AppUpdateRepository().checkAppUpdate();
      if (response.status == true && response.data != null) {
        final data = response.data!;
        final needsUpdate =
            _compareVersion(data.latestVersion, currentVersion) > 0;
        final forceUpdate =
            _compareVersion(data.minVersion, currentVersion) > 0;

        if (forceUpdate) {
          emit(AppUpdateRequired(
              true,
              data.appSize ?? '',
              data.desc ?? '',
              data.lastUpdateDate ?? '',
              data.appStoreUrl ?? MoConstants.appStoreUrl,
              data.playStoreUrl ?? MoConstants.playStoreUrl,
              data.latestVersion
          ));
        } else if (needsUpdate) {
          emit(AppUpdateRequired(
              false,
              data.appSize ?? '',
              data.desc ?? '',
              data.lastUpdateDate ?? '',
              data.appStoreUrl ?? MoConstants.appStoreUrl,
              data.playStoreUrl ?? MoConstants.playStoreUrl,
              data.latestVersion
          ));
        } else {
          emit(const AppUpdateNotRequired());
        }
      } else {
        emit(const AppUpdateNotRequired());
      }
    } catch (e) {
      // TODO: Handle gracefully, put retry or use cached config
      emit(AppUpdateError(e.toString()));
    }
  }

  int _compareVersion(String verA, String verB) {
    List<int> parse(String v) =>
        v.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final parsedVerA = parse(verA), parsedVerB = parse(verB);

    for (int i = 0; i < parsedVerA.length || i < parsedVerB.length; i++) {
      final vA = i < parsedVerA.length ? parsedVerA[i] : 0;
      final vB = i < parsedVerB.length ? parsedVerB[i] : 0;
      if (vA != vB) return vA.compareTo(vB);
    }

    return 0;
  }
}
