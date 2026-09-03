import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_line.dart';

class TransactionRecordShimmer extends StatelessWidget {
  const TransactionRecordShimmer({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerLine(height: 16, width: 160),
              ShimmerBox(
                width: 20,
                height: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(height: 32, width: 100),
                  SizedBox(height: 6),
                  ShimmerLine(height: 12, width: 130),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShimmerBox(
                    width: 60,
                    height: 24,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  const SizedBox(height: 6),
                  const ShimmerLine(height: 12, width: 70), // "This month"
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

