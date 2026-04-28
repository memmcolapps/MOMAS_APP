import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class StatCard extends StatelessWidget {
  final String type;
  final double amount;
  final double value;

  const StatCard(
      {super.key,
        required this.type,
        required this.amount,
        required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130 ,
      height: 125,
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color(0xFFD9D9D9),
              width: 1
          ),
          borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: AppTextStyles.labelMedium,
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Color(0xFFBFD3FE),
                  shape: BoxShape.circle,
                ),
                child: ImageIcon(
                  AssetImage(MoImage.checkedCircle),
                  // color: MoColors.accentBlue,
                  size: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            AmountFormatter.abbreviatedWithSign(amount),
            style: AppTextStyles.amountMedium,
          ),
          TrendBadge(value: value)
        ],
      ),
    );
  }
}