import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_bloc.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/analytics_view.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final _repo = AnalysisDataRepository();

  late final TransactionAnalysisBloc _transactionAnalysisBloc;
  late final UtilityMetricsBloc _utilityMetricsBloc;
  late final TokenReportBloc _tokenReportBloc;
  late final TransactionRecordBloc _transactionRecordBloc;
  late final AnalysisBloc _analysisBloc;

  @override
  void initState() {
    super.initState();
    _transactionAnalysisBloc = TransactionAnalysisBloc(_repo);
    _utilityMetricsBloc = UtilityMetricsBloc(_repo);
    _tokenReportBloc = TokenReportBloc(_repo);
    _transactionRecordBloc = TransactionRecordBloc(
      repository: _repo,
      utilityMetricsBloc: _utilityMetricsBloc,
      tokenReportBloc: _tokenReportBloc,
    );
    _analysisBloc = AnalysisBloc(
      repository: _repo,
      transactionRecordBloc: _transactionRecordBloc,
      transactionAnalysisBloc: _transactionAnalysisBloc,
      utilityMetricsBloc: _utilityMetricsBloc,
      tokenReportBloc: _tokenReportBloc,
    )..add(GetAnalysis());
  }

  @override
  void dispose() {
    _analysisBloc.close();
    _transactionRecordBloc.close();
    _transactionAnalysisBloc.close();
    _utilityMetricsBloc.close();
    _tokenReportBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _analysisBloc),
        BlocProvider.value(value: _transactionRecordBloc),
        BlocProvider.value(value: _transactionAnalysisBloc),
        BlocProvider.value(value: _utilityMetricsBloc),
        BlocProvider.value(value: _tokenReportBloc),
      ],
      child: const AnalyticsView(),
    );
  }
}