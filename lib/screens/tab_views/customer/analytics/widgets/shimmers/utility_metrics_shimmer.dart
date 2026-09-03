import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/section_header_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_line.dart';

class UtilityMetricsShimmer extends StatelessWidget {
  const UtilityMetricsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Row(
        children: List.generate(3, (index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 12),
            child: Container(
              width: 130,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE8E8E8)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ShimmerLine(height: 12, width: 60),
                      ShimmerBox(
                        width: 22,
                        height: 22,
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const ShimmerLine(height: 18, width: 80),
                  const SizedBox(height: 8),
                  // Trend badge
                  ShimmerBox(
                    width: 52,
                    height: 20,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}