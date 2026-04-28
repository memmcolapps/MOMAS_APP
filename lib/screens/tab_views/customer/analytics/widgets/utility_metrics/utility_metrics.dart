import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_bloc.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_event.dart';
import 'package:momaspayplus/bloc/analysis/utility_metrics_bloc/utility_metrics_state.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/utility_metrics_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/utility_metrics/stat_card.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/date_utils.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class UtilityMetrics extends StatelessWidget {
  const UtilityMetrics({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UtilityMetricsBloc, UtilityMetricsState>(
      listener: (context, state) {
        if (state is UtilityMetricsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            SectionHeader(
              title: "Utility Metrics",
              trailing: FilterDropdown(
                selected: state.selectedYear,
                data: state.availableYears,
                onChanged: (year) => context
                    .read<UtilityMetricsBloc>()
                    .add(FilterUtilityMetrics(selectedYear: year)),
              ),
            ),
            const SizedBox(height: 10),
            if (state is UtilityMetricsLoading)
              const UtilityMetricsShimmer()
            else if (state is UtilityMetricsSuccess)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: state.data.mapIndexed((index, data) =>
                        Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
                          child: StatCard(
                            type: data.serviceType.displayName,
                            amount: data.totalAmount,
                            value: data.changePercent,
                          ),
                        ),
                    ).toList(),
                  ),
                )
              else
                const UtilityMetricsShimmer(),
          ],
        );
      },
    );
  }
}
