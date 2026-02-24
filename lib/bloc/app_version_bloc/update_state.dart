import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/app_version_response.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object> get props => [];
}

class AppUpdateInitial extends AppUpdateState {
  const AppUpdateInitial();
}

class AppUpdateLoading extends AppUpdateState {
  const AppUpdateLoading();
}

class AppUpdateRequired extends AppUpdateState {
  final bool required;
  final String appSize;
  final String appDesc;
  final String latestVersion;
  final String lastUpdateDate;
  final String appStoreUrl;
  final String playStoreUrl;

  const AppUpdateRequired(this.required, this.appSize, this.appDesc,
      this.lastUpdateDate, this.appStoreUrl, this.playStoreUrl, this.latestVersion);

  @override
  List<Object> get props =>
      [required, appSize, appDesc, lastUpdateDate, appStoreUrl, playStoreUrl, latestVersion];
}

class AppUpdateNotRequired extends AppUpdateState {
  const AppUpdateNotRequired();
}

class AppUpdateError extends AppUpdateState {
  final String error;

  const AppUpdateError(this.error);

  @override
  List<Object> get props => [error];
}
