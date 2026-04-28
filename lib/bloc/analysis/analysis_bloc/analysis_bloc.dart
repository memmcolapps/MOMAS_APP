import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_state.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_bloc.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_event.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_event.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';

class AnalysisBloc extends Bloc<AnalysisEvent, AnalysisState> {
  final AnalysisDataRepository repository;

  final TransactionAnalysisBloc transactionAnalysisBloc;
  final UtilityMetricsBloc utilityMetricsBloc;
  final TokenReportBloc tokenReportBloc;

  AnalysisBloc({
    required this.repository,
    required this.transactionAnalysisBloc,
    required this.utilityMetricsBloc,
    required this.tokenReportBloc,
  }) : super(const AnalysisInitial()) {
    on<GetAnalysis>(_onGetAnalysis);
  }

  Future<void> _onGetAnalysis(
      GetAnalysis event, Emitter<AnalysisState> emit) async {
    emit(const AnalysisLoading());
    try {
      final response = await repository.getAnalysis();

      if (response.status) {
        final data = response.data;

        // Seed each section BLoC with its slice of the combined response
        transactionAnalysisBloc.add(SeedTransactionAnalysis(data: data));
        utilityMetricsBloc
            .add(SeedUtilityMetrics(data: data));
        tokenReportBloc
            .add(SeedTokenReport(data: data));

        emit(AnalysisSuccess(
          selectedYear: data.selectedYear,
          availableYears: data.availableYears,
          totalMonthAmount: data.totalMonthAmount,
          monthChangePercent: data.monthChangePercent,
        ));
      } else {
        emit(AnalysisFailure(error: response.message ?? 'Network error'));
      }
    } catch (e) {
      emit(AnalysisFailure(error: e.toString()));
    }
  }
}
