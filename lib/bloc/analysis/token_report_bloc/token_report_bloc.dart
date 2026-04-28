import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_event.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_state.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';

class TokenReportBloc extends Bloc<TokenReportEvent, TokenReportState> {
  final AnalysisDataRepository repository;

  TokenReportBloc(this.repository) : super(const TokenReportInitial()) {
    on<SeedTokenReport>(_onSeed);
    on<FilterTokenReport>(_onFilter);
  }

  void _onSeed(SeedTokenReport event, Emitter<TokenReportState> emit) {
    emit(
        TokenReportSuccess(data: event.data.tokenStatusBreakdown, selectedYear: event.data.selectedYear, availableYears: event.data.availableYears));
  }

  Future<void> _onFilter(
      FilterTokenReport event, Emitter<TokenReportState> emit) async {
    emit(TokenReportLoading(selectedYear: event.selectedYear, availableYears: state.availableYears));
    try {
      final response =
          await repository.getAccessTokenReport(event.selectedYear);

      if (response.status) {
        emit(TokenReportSuccess(
            data: response.data.tokenStatusBreakdown,
            selectedYear: event.selectedYear,
          availableYears: response.data.availableYears
        ));
      } else {
        emit(TokenReportFailure(
          error: response.message ?? 'Network error',
          selectedYear: state.selectedYear,
          availableYears: state.availableYears,
        ));
      }
    } catch (e) {
      emit(TokenReportFailure(
        error: e.toString(),
        selectedYear: state.selectedYear,
        availableYears: state.availableYears,
      ));
    }
  }
}
