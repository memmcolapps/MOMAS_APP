import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TransactionAnalysisEvent extends Equatable {
  const TransactionAnalysisEvent();
}

class SeedTransactionAnalysis extends TransactionAnalysisEvent {
  final AnalysisData data;
  const SeedTransactionAnalysis({required this.data});

  @override
  List<Object?> get props => [data];
}

class FilterTransactionAnalysis extends TransactionAnalysisEvent {
  final String selectedYear;
  const FilterTransactionAnalysis({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}
