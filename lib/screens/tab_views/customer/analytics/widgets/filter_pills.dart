import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/chart_data.dart';
import 'package:momaspayplus/utils/colors.dart';

class FilterPills extends StatelessWidget {
  final AnalyticsFilter selected;
  final ValueChanged<AnalyticsFilter> onFilterChanged;

  const FilterPills({
    super.key,
    required this.selected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AnalyticsFilter.values.map((filter) {
        final bool isSelected = selected == filter;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onFilterChanged(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? MoColors.mainColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? MoColors.mainColor : Colors.grey.shade300,
                ),
              ),
              child: Text(
                filter.name[0].toUpperCase() + filter.name.substring(1),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}