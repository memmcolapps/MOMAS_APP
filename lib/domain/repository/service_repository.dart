import 'package:momaspayplus/domain/data/response/artisan_list_response.dart';
import 'package:momaspayplus/domain/data/response/generic_response.dart';
import 'package:momaspayplus/domain/data/response/service_type_response.dart';

import '../../core/network/routes.dart';
import '../data/response/comment_response.dart';
import '../data/response/service_data_response.dart';
import '../data/response/service_response.dart';
import '../../core/network/request.dart';

class ServiceRepository {
  final ServerRequest _request = ServerRequest();

  Future<ServiceTypeResponse> getServiceType() async {
    var response = await _request.getData(path: Routes.serviceType);
    return ServiceTypeResponse.fromJson(response.data);
  }

  Future<ArtisanListResponse> getArtisanByService(int serviceId) async {
    var response = await _request.getData(
        path: Routes.artisanByService,
        dataToSend: {"service_id": serviceId.toString()});
    return ArtisanListResponse.fromJson(response.data);
  }

  Future<ServiceDataResponse> getService() async {
    var response = await _request.getData(path: Routes.serviceProperties);
    return ServiceDataResponse.fromJson(response.data);
  }

  Future<ServiceSearchResponse> searchService(
      String serviceId, String estateId) async {
    var response = await _request.postData(
        path: Routes.serviceSearch,
        body: {"estate_id": estateId, "service_id": serviceId});
    return ServiceSearchResponse.fromJson(response.data);
  }

  Future<GenericResponse> saveServiceComment(
      String jobId, String rate, String comment) async {
    var response = await _request.postData(
        path: Routes.saveComment,
        body: {"job_id": jobId, "rate": rate, "comment": comment});
    return GenericResponse.fromJson(response.data);
  }

  Future<CommentResponse> getServiceComment(
    String jobId,
  ) async {
    var response = await _request
        .postData(path: Routes.getComment, body: {"job_id": jobId});
    return CommentResponse.fromJson(response.data);
  }
}
