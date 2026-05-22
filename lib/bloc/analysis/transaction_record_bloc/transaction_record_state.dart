import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TransactionRecordState extends Equatable {
  final String selectedYear;
  final List<String> availableYears;

  const TransactionRecordState({
    required this.selectedYear,
    required this.availableYears,
  });

  @override
  List<Object?> get props => [selectedYear, availableYears];
}

class TransactionRecordInitial extends TransactionRecordState {
  const TransactionRecordInitial()
      : super(selectedYear: 'This year', availableYears: const ['This year']);
}

class TransactionRecordLoading extends TransactionRecordState {
  const TransactionRecordLoading({
    required super.selectedYear,
    required super.availableYears,
  });
}

class TransactionRecordSuccess extends TransactionRecordState {
  final double totalMonthAmount;
  final double monthChangePercent;

  const TransactionRecordSuccess({
    required this.totalMonthAmount,
    required this.monthChangePercent,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props,
    totalMonthAmount,
    monthChangePercent,];
}

class TransactionRecordFailure extends TransactionRecordState {
  final String error;

  const TransactionRecordFailure({
    required this.error,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, error];
}