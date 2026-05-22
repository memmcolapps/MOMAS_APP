import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_state.dart';
import 'package:momaspayplus/reuseable/views/error_view.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/access_tokens.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/power_usage_section.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/analytics_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_history.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_record.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_record_section.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/utility_metrics/utility_metrics.dart';
import 'package:momaspayplus/screens/tab_views/shared/tabview_skeleton.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return TabViewSkeleton(
        appBarTitle: "Analytics",
        body: BlocBuilder<AnalysisBloc, AnalysisState>(
          builder: (context, state) {

            if (state is AnalysisSuccess) {
              return const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      TransactionHistory(),
                      SizedBox(height: 24),
                      TransactionRecordSection()
                    ],
                  ),
                ),
              );
            }

            if (state is AnalysisFailure) {
              return ErrorView(
                message: state.error,
                onRetry: () => context.read<AnalysisBloc>().add(GetAnalysis()),
              );
            }

            return const AnalyticsShimmer();
          }
        ));
  }
}
