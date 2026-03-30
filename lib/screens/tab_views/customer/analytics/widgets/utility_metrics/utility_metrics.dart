import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/trend_badge.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/date_utils.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class UtilityMetrics extends StatefulWidget {
  const UtilityMetrics({super.key});

  @override
  State<UtilityMetrics> createState() => _UtilityMetricsState();
}

class _UtilityMetricsState extends State<UtilityMetrics> {
  String _selectedYear = "This year";

  static const List<_StatCardData> _cards = [
    _StatCardData(type: 'Airtime', amount: 45000, value: 12),
    _StatCardData(type: 'Data', amount: 32000, value: -5),
    _StatCardData(type: 'Cable TV', amount: 280000, value: 8),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Utility Metrics",
          trailing: FilterDropdown(
            selected: _selectedYear,
            data: MoDateUtils.years,
            onChanged: (year) => setState(() => _selectedYear = year),
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: _cards.mapIndexed((index, card) => Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 0 : 12,
              ),
              child: StatCard(
                type: card.type,
                amount: card.amount,
                value: card.value,
              ),
            )).toList(),
          ),
        ),
      ],
    );
  }
}

class _StatCardData {
  final String type;
  final double amount;
  final double value;

  const _StatCardData({
    required this.type,
    required this.amount,
    required this.value,
  });
}

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
          const SizedBox(height: 10),
          Text(
            AmountFormatter.abbreviatedWithSign(amount),
            style: AppTextStyles.amountMedium,
          ),
          const SizedBox(height: 6),
          TrendBadge(value: value)
        ],
      ),
    );
  }
}
