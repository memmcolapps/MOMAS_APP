class AppUpdateResponse {
  bool? status;
  String? message;
  AppUpdateData? data;

  AppUpdateResponse({this.status, this.message, this.data});

  AppUpdateResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? AppUpdateData.fromJson(json['data']) : null;
  }
}

class AppUpdateData {
  final String minVersion;
  final String latestVersion;
  String? desc;
  String? lastUpdateDate;
  String? appSize;
  String? appStoreUrl;
  String? playStoreUrl;

  AppUpdateData(
      {required this.minVersion,
      required this.latestVersion,
      this.desc,
      this.lastUpdateDate,
      this.appSize,
      this.appStoreUrl,
      this.playStoreUrl});

  factory AppUpdateData.fromJson(Map<String, dynamic> json) {
    return AppUpdateData(
        minVersion: json['minimum_version'],
        latestVersion: json['latest_version'],
        desc: json['description'],
        lastUpdateDate: json['last_update_date'],
        appSize: json['app_size'],
        appStoreUrl: json['app_store_url'],
        playStoreUrl: json['play_store_url']);
  }
}
