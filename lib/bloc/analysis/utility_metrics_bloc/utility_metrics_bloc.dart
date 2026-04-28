import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_event.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_state.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';

class UtilityMetricsBloc
    extends Bloc<UtilityMetricsEvent, UtilityMetricsState> {
  final AnalysisDataRepository repository;

  UtilityMetricsBloc(this.repository) : super(const UtilityMetricsInitial()) {
    on<SeedUtilityMetrics>(_onSeed);
    on<FilterUtilityMetrics>(_onFilter);
  }

  void _onSeed(SeedUtilityMetrics event, Emitter<UtilityMetricsState> emit) {
    emit(UtilityMetricsSuccess(
        data: event.data.byServiceType,
      selectedYear: event.data.selectedYear,
      availableYears: event.data.availableYears
    ));
  }

  Future<void> _onFilter(
      FilterUtilityMetrics event, Emitter<UtilityMetricsState> emit) async {

    emit(UtilityMetricsLoading(selectedYear: event.selectedYear, availableYears: state.availableYears));
    try {
      final response = await repository.getUtilityMetrics(event.selectedYear);

      if (response.status) {
        emit(UtilityMetricsSuccess(
            data: response.data.byServiceType,
            selectedYear: event.selectedYear,
          availableYears: response.data.availableYears
        ));
      } else {
        emit(UtilityMetricsFailure(
          error: response.message ?? 'Network error',
          selectedYear: state.selectedYear,
          availableYears: state.availableYears,
        ));
      }
    } catch (e) {
      emit(UtilityMetricsFailure(
        error: e.toString(),
        selectedYear: state.selectedYear,
        availableYears: state.availableYears,
      ));
    }
  }
}
