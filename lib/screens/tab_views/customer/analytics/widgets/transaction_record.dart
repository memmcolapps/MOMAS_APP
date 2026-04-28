import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_bloc.dart';
import 'package:momaspayplus/bloc/analysis/analysis_bloc/analysis_state.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TransactionRecord extends StatelessWidget {
  const TransactionRecord({super.key});

  @override
  Widget build(BuildContext context) {
    final totalAmountVended = context.select((AnalysisBloc bloc) {
      final state = bloc.state;
      return state is AnalysisSuccess ? state.totalMonthAmount : 0.00;
    });

    final trendChange = context.select((AnalysisBloc bloc) {
      final state = bloc.state;
      return state is AnalysisSuccess ? state.monthChangePercent : 0.00;
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: BoxBorder.all(color: const Color(0xFFD9D9D9))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Transaction Record",
                style: AppTextStyles.sectionHeader,
              ),
              InkWell(
                child: const Icon(
                  Icons.chevron_right_sharp,
                  color: Colors.black,
                  size: 20,
                ),
                onTap: () {
                  context.read<TabCubit>().changeTab(1);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount Vended
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AmountFormatter.abbreviatedWithSign(totalAmountVended),
                      style: AppTextStyles.amountLarge),
                  const Text("Total Amount Vended", style: AppTextStyles.label),
                ],
              ),

              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TrendBadge(value: trendChange),
                  const Text("This month", style: AppTextStyles.label),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
