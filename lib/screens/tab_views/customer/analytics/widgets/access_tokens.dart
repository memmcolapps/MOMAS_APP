import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/model/analytics_data/ring_data.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/concentric_ring_chart/concentric_ring_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/filter_dropdown.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/section_header.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/date_utils.dart';

class AccessTokens extends StatefulWidget {
  const AccessTokens({super.key});

  @override
  State<AccessTokens> createState() => _AccessTokensState();
}

class _AccessTokensState extends State<AccessTokens> {
  String _selectedYear = "This year";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: "Access Tokens",
          trailing: FilterDropdown(
            selected: _selectedYear,
            data: MoDateUtils.years,
            onChanged: (year) => setState(() => _selectedYear = year),
          ),
        ),
        const SizedBox(height: 20),

        const ConcentricRingChart(
          size: 180,
          rings: [
            RingData(label: 'Used',    count: 33, color: MoColors.glacierBlue),
            RingData(label: 'Pending', count: 9,  color: MoColors.tigerOrange),
            RingData(label: 'Failed',  count: 45, color: MoColors.flareRed),
          ],
        )
      ],
    );
  }
}

