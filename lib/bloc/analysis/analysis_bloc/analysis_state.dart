import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object> get props => [];
}

class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

class AnalysisLoading extends AnalysisState {
  const AnalysisLoading();
}

class AnalysisSuccess extends AnalysisState {
  final String selectedYear;
  final List<String> availableYears;
  final double totalMonthAmount;
  final double monthChangePercent;

  const AnalysisSuccess({
    required this.selectedYear,
    required this.availableYears,
    required this.totalMonthAmount,
    required this.monthChangePercent,
  });

  @override
  List<Object> get props => [
    selectedYear,
    availableYears,
    totalMonthAmount,
    monthChangePercent,
  ];
}

class AnalysisFailure extends AnalysisState {
  final String error;

  const AnalysisFailure({required this.error});

  @override
  List<Object> get props => [error];
}
