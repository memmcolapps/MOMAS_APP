import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/transaction_line_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  String _selectedYear = "This year";

  final List<String> _years = [
    "This year",
    ...List.generate(
      5,
          (index) => (DateTime.now().year - 1 - index).toString(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Transaction History",
          trailing: FilterDropdown(
            selected: _selectedYear,
            data: _years,
            onChanged: (year) => setState(() => _selectedYear = year),
          ),
        ),
        const SizedBox(height: 20),
        TransactionLineChart(selectedYear: _selectedYear),
      ],
    );
  }
}