import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TransactionRecord extends StatelessWidget {
  const TransactionRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: BoxBorder.all(color: const Color(0xFFD9D9D9))),
      child: const Column(
        children: [
          // --- Section header + Redirect Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Transaction Record",
                style: AppTextStyles.sectionHeader,
              ),
              Icon(
                Icons.chevron_right_sharp,
                color: Colors.black,
                size: 20,
              )
            ],
          ),
           SizedBox(height: 10),

          // --- Amount Vended + Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Amount Vended
               Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("₦500k", style: AppTextStyles.amountLarge),
                  Text("Total Amount Vended", style: AppTextStyles.label),
                ],
              ),

              // Stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 TrendBadge(value: -12),
                  Text("This month", style: AppTextStyles.label),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}