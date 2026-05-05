import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_event.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/access_tokens.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_record.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/utility_metrics/utility_metrics.dart';

class TransactionRecordSection extends StatelessWidget {
  const TransactionRecordSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TransactionRecordBloc>().state;

    return Column(
      children: [
        SectionHeader(
          title: "Filter By: ",
          trailing: FilterDropdown(
            selected: state.selectedYear,
            data: state.availableYears,
            onChanged: (year) => context
                .read<TransactionRecordBloc>()
                .add(GetTransactionSummary(selectedYear: year)),
          ),
        ),
        const SizedBox(height: 10),
        const TransactionRecord(),
        const SizedBox(height: 24),
        const UtilityMetrics(),
        const SizedBox(height: 24),
        const AccessTokens(),
        const SizedBox(height: 100),
      ],
    );
  }
}
