import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_state.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';
import 'package:momaspayplus/utils/strings.dart';

class TransactionAnalysisBloc
    extends Bloc<TransactionAnalysisEvent, TransactionAnalysisState> {
  final AnalysisDataRepository repository;

  TransactionAnalysisBloc(this.repository)
      : super(const TransactionAnalysisInitial()) {
    on<SeedTransactionAnalysis>(_onSeed);
    on<FilterTransactionAnalysis>(_onFilter);
  }

  void _onSeed(
      SeedTransactionAnalysis event, Emitter<TransactionAnalysisState> emit) {
    emit(TransactionAnalysisSuccess(
        data: event.data.byYear,
        selectedYear: event.data.selectedYear,
        availableYears: event.data.availableYears));
  }

  Future<void> _onFilter(FilterTransactionAnalysis event,
      Emitter<TransactionAnalysisState> emit) async {
    emit(TransactionAnalysisLoading(
      selectedYear: event.selectedYear,
      availableYears: state.availableYears,
    ));
    try {
      final response =
          await repository.getTransactionAnalysis(event.selectedYear);

      if (response.status) {
        emit(TransactionAnalysisSuccess(
            data: response.data.byYear,
            selectedYear: event.selectedYear,
            availableYears: response.data.availableYears));
      } else {
        emit(TransactionAnalysisFailure(
          error: extractError(response.message),
          selectedYear: state.selectedYear,
          availableYears: state.availableYears,
        ));
      }
    } catch (e) {
      emit(TransactionAnalysisFailure(
        error: e.toString(),
        selectedYear: state.selectedYear,
        availableYears: state.availableYears,
      ));
    }
  }
}
