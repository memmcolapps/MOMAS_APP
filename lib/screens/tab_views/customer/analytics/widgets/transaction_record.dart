import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_bloc.dart';
import 'package:momaspayplus/bloc/analysis/transaction_record_bloc/transaction_record_state.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/transaction_record_shimmer.dart'; // create if needed
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TransactionRecord extends StatelessWidget {
  const TransactionRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionRecordBloc, TransactionRecordState>(
      listener: (context, state) {
        if (state is TransactionRecordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is TransactionRecordLoading) {
          return const TransactionRecordShimmer();
        }

        if (state is TransactionRecordSuccess) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: BoxBorder.all(color: const Color(0xFFD9D9D9)),
            ),
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
                      onTap: () => context.read<TabCubit>().changeTab(1),
                      child: const Icon(
                        Icons.chevron_right_sharp,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AmountFormatter.abbreviatedWithSign(state.totalMonthAmount),
                          style: AppTextStyles.amountLarge,
                        ),
                        const Text("Total Amount Vended", style: AppTextStyles.label),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TrendBadge(value: state.monthChangePercent),
                        const Text("This year", style: AppTextStyles.label),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return const TransactionRecordShimmer();
      },
    );
  }
}