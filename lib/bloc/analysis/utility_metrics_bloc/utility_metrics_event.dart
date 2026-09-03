import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class UtilityMetricsEvent extends Equatable {
  const UtilityMetricsEvent();
}

class LoadingUtilityMetrics extends UtilityMetricsEvent {
  final String selectedYear;
  final List<String> availableYears;

  const LoadingUtilityMetrics({required this.selectedYear, required this.availableYears});
  @override
  List<Object?> get props => [selectedYear, availableYears];
}


class SeedUtilityMetrics extends UtilityMetricsEvent {
  final AnalysisData data;

  const SeedUtilityMetrics({required this.data});

  @override
  List<Object?> get props => [data];
}



// class FilterUtilityMetrics extends UtilityMetricsEvent {
//   final String selectedYear;
//   const FilterUtilityMetrics({required this.selectedYear});
//
//   @override
//   List<Object?> get props => [selectedYear];
// }
