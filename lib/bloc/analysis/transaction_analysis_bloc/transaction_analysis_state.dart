import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TransactionAnalysisState extends Equatable {
  final String selectedYear;
  final List<String> availableYears;

  const TransactionAnalysisState({
    required this.selectedYear,
    required this.availableYears,
  });

  @override
  List<Object?> get props => [selectedYear, availableYears];
}

class TransactionAnalysisInitial extends TransactionAnalysisState {
  const TransactionAnalysisInitial()
      : super(selectedYear: 'This year', availableYears: const ['This year']);
}

class TransactionAnalysisLoading extends TransactionAnalysisState {
  const TransactionAnalysisLoading({
    required super.selectedYear,
    required super.availableYears,
  });
}

class TransactionAnalysisSuccess extends TransactionAnalysisState {
  final List<MonthlyTransaction> data;

  const TransactionAnalysisSuccess({
    required this.data,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, data];
}

class TransactionAnalysisFailure extends TransactionAnalysisState {
  final String error;

  const TransactionAnalysisFailure({
    required this.error,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, error];
}