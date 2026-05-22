import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class UtilityMetricsState extends Equatable {
  final String selectedYear;
  final List<String> availableYears;

  const UtilityMetricsState({
    required this.selectedYear,
    required this.availableYears,
  });

  @override
  List<Object?> get props => [selectedYear, availableYears];
}

class UtilityMetricsInitial extends UtilityMetricsState {
  const UtilityMetricsInitial()
      : super(selectedYear: 'This year', availableYears: const ['This year']);
}

class UtilityMetricsLoading extends UtilityMetricsState {
  const UtilityMetricsLoading(
      {
    required super.selectedYear,
    required super.availableYears,
  }
  );
}

class UtilityMetricsSuccess extends UtilityMetricsState {
  final List<ServiceTypeMetric> data;

  const UtilityMetricsSuccess({
    required this.data,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, data];
}

class UtilityMetricsFailure extends UtilityMetricsState {
  final String error;

  const UtilityMetricsFailure({
    required this.error,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, error];
}