import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TransactionRecordEvent extends Equatable {
  const TransactionRecordEvent();
}

class SeedTransactionRecord extends TransactionRecordEvent {
  final AnalysisData data;
  const SeedTransactionRecord({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetTransactionSummary extends TransactionRecordEvent {
  final String selectedYear;
  const GetTransactionSummary({required this.selectedYear});

  @override
  List<Object?> get props => [selectedYear];
}