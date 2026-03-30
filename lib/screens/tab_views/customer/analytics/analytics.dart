import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/access_tokens.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/power_usage_section.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_history.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/transaction_record.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/utility_metrics/utility_metrics.dart';
import 'package:momaspayplus/screens/tab_views/shared/tabview_skeleton.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabViewSkeleton(
        appBarTitle: "Analytics",
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                TransactionRecord(),
                SizedBox(height: 24),
                TransactionHistory(),
                SizedBox(height: 24),
                UtilityMetrics(),
                // PowerUsageSection(),
                SizedBox(height: 24),
                AccessTokens(),
                SizedBox(height: 100),
              ],
            ),
          ),
        ));
  }
}
