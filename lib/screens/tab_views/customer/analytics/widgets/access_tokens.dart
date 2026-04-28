import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_bloc.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_event.dart';
import 'package:momaspayplus/bloc/analysis/token_report_bloc/token_report_state.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/concentric_ring_chart/concentric_ring_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/access_tokens_shimmer.dart';

class AccessTokens extends StatelessWidget {
  const AccessTokens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TokenReportBloc, TokenReportState>(
      listener: (context, state) {
        if (state is TokenReportFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            SectionHeader(
              title: "Access Tokens",
              trailing: FilterDropdown(
                selected: state.selectedYear,
                data: state.availableYears,
                onChanged: (year) => context
                    .read<TokenReportBloc>()
                    .add(FilterTokenReport(selectedYear: year)),
              ),
            ),
            const SizedBox(height: 20),
            if (state is TokenReportLoading)
              const AccessTokensShimmer()
            else if (state is TokenReportSuccess)
                ConcentricRingChart(
                  size: 180,
                  rings: state.data
                      .where((t) => t.status != TokenStatus.unknown)
                      .map((t) => t.toRingData())
                      .toList(),
                )
              else
                const AccessTokensShimmer(),
          ],
        );
      },
    );
  }
}