import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';

abstract class TokenReportState extends Equatable {
  final String selectedYear;
  final List<String> availableYears;

  const TokenReportState({
    required this.selectedYear,
    required this.availableYears,
  });

  @override
  List<Object?> get props => [selectedYear, availableYears];
}

class TokenReportInitial extends TokenReportState {
  const TokenReportInitial()
      : super(selectedYear: 'This year', availableYears: const ['This year']);
}

class TokenReportLoading extends TokenReportState {
  const TokenReportLoading({
    required super.selectedYear,
    required super.availableYears,
  });
}

class TokenReportSuccess extends TokenReportState {
  final List<TokenStatusBreakdown> data;

  const TokenReportSuccess({
    required this.data,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, data];
}

class TokenReportFailure extends TokenReportState {
  final String error;

  const TokenReportFailure({
    required this.error,
    required super.selectedYear,
    required super.availableYears,
  });

  @override
  List<Object?> get props => [...super.props, error];
}
