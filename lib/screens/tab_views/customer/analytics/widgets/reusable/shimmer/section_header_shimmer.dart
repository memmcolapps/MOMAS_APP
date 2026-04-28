import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_line.dart';

class SectionHeaderShimmer extends StatelessWidget {
  const SectionHeaderShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ShimmerLine(height: 16, width: 140),
            ShimmerBox(
              width: 90,
              height: 32,
              borderRadius: BorderRadius.circular(20),
            ),
          ],
        ),
        const SizedBox(height: 12)
      ],
    );
  }
}

