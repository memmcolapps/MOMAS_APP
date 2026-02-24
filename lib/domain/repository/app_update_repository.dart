import 'package:momaspayplus/domain/data/response/app_version_response.dart';
import 'package:momaspayplus/domain/request.dart';
import 'package:momaspayplus/utils/routes.dart';

class AppUpdateRepository {
  final ServerRequest _request = ServerRequest();

  Future<AppUpdateResponse> checkAppUpdate() async {
    var response = await _request.getData(
      path: Routes.checkAppUpdate,
    );
    return AppUpdateResponse.fromJson(response.data);
  }
}