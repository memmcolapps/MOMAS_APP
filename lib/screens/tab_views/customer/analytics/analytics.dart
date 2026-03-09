import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/power_usage_section.dart';
import 'package:momaspayplus/screens/tab_views/shared/tabview_skeleton.dart';

class Analytics extends StatelessWidget {
  const Analytics({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabViewSkeleton(
        appBarTitle: "Analytics",
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              PowerUsageSection(),

            ],
          ),
        ));
  }
}
