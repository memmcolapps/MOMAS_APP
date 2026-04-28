import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/section_header_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/access_tokens_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/transaction_history_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/transaction_record_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/shimmers/utility_metrics_shimmer.dart';

class AnalyticsShimmer extends StatelessWidget {
  const AnalyticsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            TransactionRecordShimmer(),
            SectionHeaderShimmer(),
            TransactionHistoryShimmer(),
            SectionHeaderShimmer(),
            UtilityMetricsShimmer(),
            SectionHeaderShimmer(),
            AccessTokensShimmer(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}