import 'package:momaspayplus/features/app_update/data/models/app_version_response.dart';
import 'package:momaspayplus/core/network/request.dart';
import 'package:momaspayplus/core/network/routes.dart';

class AppUpdateRepository {
  final ServerRequest _request = ServerRequest();

  Future<AppUpdateResponse> checkAppUpdate() async {
    var response = await _request.getData(
      path: Routes.checkAppUpdate,
    );
    return AppUpdateResponse.fromJson(response.data);
  }
}