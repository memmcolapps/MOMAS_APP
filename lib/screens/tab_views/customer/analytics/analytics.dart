import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_bloc.dart';
import 'package:momaspayplus/domain/repository/analysis_data_repository.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/analytics_view.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = AnalysisDataRepository();

    final transactionAnalysisBloc = TransactionAnalysisBloc(repo);
    final utilityMetricsBloc = UtilityMetricsBloc(repo);
    final tokenReportBloc = TokenReportBloc(repo);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AnalysisBloc(
            repository: repo,
              transactionAnalysisBloc: transactionAnalysisBloc,
              utilityMetricsBloc: utilityMetricsBloc,
              tokenReportBloc: tokenReportBloc
          )..add(GetAnalysis()),
        ),
        BlocProvider.value(value: transactionAnalysisBloc),
        BlocProvider.value(value: utilityMetricsBloc),
        BlocProvider.value(value: tokenReportBloc),
      ],
      child: const AnalyticsView(),
    );
  }
}