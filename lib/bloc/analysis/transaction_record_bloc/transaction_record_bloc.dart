import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_bloc.dart';
import 'package:momaspayplus/utils/strings.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_event.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_event.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_state.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_event.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';

class TransactionRecordBloc
    extends Bloc<TransactionRecordEvent, TransactionRecordState> {
  final AnalysisDataRepository repository;
  final UtilityMetricsBloc utilityMetricsBloc;
  final TokenReportBloc tokenReportBloc;

  TransactionRecordBloc({
    required this.repository,
    required this.utilityMetricsBloc,
    required this.tokenReportBloc,
  }) : super(const TransactionRecordInitial()) {
    on<SeedTransactionRecord>(_onSeed);
    on<GetTransactionSummary>(_onGetSummary);
  }

  void _onSeed(
      SeedTransactionRecord event, Emitter<TransactionRecordState> emit) {
    emit(TransactionRecordSuccess(
        totalMonthAmount: event.data.totalMonthAmount,
        monthChangePercent: event.data.monthChangePercent,
        selectedYear: event.data.selectedYear,
        availableYears: event.data.availableYears));
  }

  Future<void> _onGetSummary(
      GetTransactionSummary event, Emitter<TransactionRecordState> emit) async {
    final String selectedYear = event.selectedYear;
    final List<String> availableYears = state.availableYears;

    emit(TransactionRecordLoading(
      selectedYear: selectedYear,
      availableYears: availableYears,
    ));

    utilityMetricsBloc.add(LoadingUtilityMetrics(selectedYear: selectedYear, availableYears: availableYears));
    tokenReportBloc.add(LoadingTokenReport(selectedYear: selectedYear, availableYears: availableYears));

    try {
      final response = await repository.getAnalysisSummary(event.selectedYear);

      if (response.status) {
        final data = response.data;

        utilityMetricsBloc.add(SeedUtilityMetrics(data: data));
        tokenReportBloc.add(SeedTokenReport(data: data));

        emit(TransactionRecordSuccess(
          totalMonthAmount: data.totalMonthAmount,
          monthChangePercent: data.monthChangePercent,
          selectedYear: event.selectedYear,
          availableYears: state.availableYears,
        ));
      } else {
        emit(TransactionRecordFailure(
          error: extractError(response.message),
          selectedYear: state.selectedYear,
          availableYears: state.availableYears,
        ));
      }
    } catch (e) {
      emit(TransactionRecordFailure(
        error: e.toString(),
        selectedYear: state.selectedYear,
        availableYears: state.availableYears,
      ));
    }
  }
}
