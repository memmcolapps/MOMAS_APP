import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_event.dart';
import 'package:momaspayplus/bloc/analysis/transaction_analysis_bloc/transaction_analysis_state.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/transaction_line_chart/empty_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/transaction_line_chart/transaction_line_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/transaction_history_shimmer.dart';

class TransactionHistory extends StatelessWidget {
  const TransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionAnalysisBloc, TransactionAnalysisState>(
      builder: (context, state) {
        return Column(
          children: [
            SectionHeader(
              title: "Transaction History",
              trailing: FilterDropdown(
                selected: state.selectedYear,
                data: state.availableYears,
                onChanged: (year) => context
                    .read<TransactionAnalysisBloc>()
                    .add(FilterTransactionAnalysis(selectedYear: year)),
              ),
            ),
            const SizedBox(height: 20),
            if (state is TransactionAnalysisLoading)
              const TransactionHistoryShimmer()
            else if (state is TransactionAnalysisFailure)
              const EmptyChart(message: "Something went wrong", isError: true,)
            else if (state is TransactionAnalysisSuccess)
                TransactionLineChart(
                  selectedYear: state.selectedYear,
                  transactions: state.data,
                )
              else
                const TransactionHistoryShimmer(),
          ],
        );
      },
    );
  }
}
