import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/domain/request.dart';
import 'package:momaspayplus/utils/routes.dart';

class AnalysisDataRepository {
  final ServerRequest _request = ServerRequest();

  String _resolveYear(String year) =>
      year == 'This year' ? DateTime.now().year.toString() : year;

  Future<AnalysisResponse> getAnalysis() async {
    var response = await _request.getData(
      path: Routes.getAnalysis,
    );

    return AnalysisResponse.fromJson(response.data);
  }

  Future<TransactionAnalysisResponse> getTransactionAnalysis(
      String year) async {
    var response = await _request.getData(
        path: Routes.getTransactionAnalysis,
        dataToSend: {'year': _resolveYear(year)});

    return TransactionAnalysisResponse.fromJson(response.data);
  }

  Future<UtilityMetricsResponse> getUtilityMetrics(String year) async {
    var response = await _request.getData(
        path: Routes.getUtilityMetrics,
        dataToSend: {'year': _resolveYear(year)});

    return UtilityMetricsResponse.fromJson(response.data);
  }

  Future<AccessTokenReportResponse> getAccessTokenReport(String year) async {
    var response = await _request.getData(
        path: Routes.getAccessTokenReport,
        dataToSend: {'year': _resolveYear(year)});

    return AccessTokenReportResponse.fromJson(response.data);
  }
}
