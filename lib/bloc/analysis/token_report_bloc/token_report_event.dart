import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TokenReportEvent extends Equatable {
  const TokenReportEvent();
}

class LoadingTokenReport extends TokenReportEvent {
  final String selectedYear;
  final List<String> availableYears;

  const LoadingTokenReport({required this.selectedYear, required this.availableYears});
  @override
  List<Object?> get props => [selectedYear, availableYears];
}

class SeedTokenReport extends TokenReportEvent {
  final AnalysisData data;
  const SeedTokenReport({
    required this.data
  });

  @override
  List<Object?> get props => [data];
}

// class FilterTokenReport extends TokenReportEvent {
//   final String selectedYear;
//   const FilterTokenReport({required this.selectedYear});
//
//   @override
//   List<Object?> get props => [selectedYear];
// }
