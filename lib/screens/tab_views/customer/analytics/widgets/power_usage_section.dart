import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/daily_usage_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/weekly_usage_chart.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/chart_data.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/filter_pills.dart';

class PowerUsageSection extends StatefulWidget {
  const PowerUsageSection({
    super.key,
  });

  @override
  State<PowerUsageSection> createState() => _PowerUsageSectionState();
}

class _PowerUsageSectionState extends State<PowerUsageSection> {
  AnalyticsFilter _selected = AnalyticsFilter.daily;

  // Dummy data — replace with real bloc data later
  final List<DailyUsageData> _dummyDailyData = [
    DailyUsageData(hour: 0,  kwh: 0.5),
    DailyUsageData(hour: 1,  kwh: 0.3),
    DailyUsageData(hour: 2,  kwh: 0.2),
    DailyUsageData(hour: 3,  kwh: 0.2),
    DailyUsageData(hour: 4,  kwh: 0.3),
    DailyUsageData(hour: 5,  kwh: 0.6),
    DailyUsageData(hour: 6,  kwh: 1.2),
    DailyUsageData(hour: 7,  kwh: 2.1),
    DailyUsageData(hour: 8,  kwh: 2.8),
    DailyUsageData(hour: 9,  kwh: 2.5),
    DailyUsageData(hour: 10, kwh: 2.3),
    DailyUsageData(hour: 11, kwh: 2.6),
    DailyUsageData(hour: 12, kwh: 3.1),
    DailyUsageData(hour: 13, kwh: 2.9),
    DailyUsageData(hour: 14, kwh: 2.7),
    DailyUsageData(hour: 15, kwh: 2.4),
    DailyUsageData(hour: 16, kwh: 2.8),
    DailyUsageData(hour: 17, kwh: 3.8), // peak
    DailyUsageData(hour: 18, kwh: 4.2), // peak
    DailyUsageData(hour: 19, kwh: 3.9),
    DailyUsageData(hour: 20, kwh: 3.2),
    DailyUsageData(hour: 21, kwh: 2.5),
    DailyUsageData(hour: 22, kwh: 1.8),
    DailyUsageData(hour: 23, kwh: 0.9),
  ];

  final List<DayUsageData> _dummyWeeklyData = [
    DayUsageData(day: 'Mon', totalKwh: 10.2, peakKwh: 3.1, peakTime: '7PM', avgKwh: 0.43),
    DayUsageData(day: 'Tue', totalKwh: 8.7,  peakKwh: 2.8, peakTime: '6PM', avgKwh: 0.36),
    DayUsageData(day: 'Wed', totalKwh: 12.4, peakKwh: 4.2, peakTime: '6PM', avgKwh: 0.52),
    DayUsageData(day: 'Thu', totalKwh: 9.1,  peakKwh: 3.0, peakTime: '8PM', avgKwh: 0.38),
    DayUsageData(day: 'Fri', totalKwh: 11.3, peakKwh: 3.7, peakTime: '7PM', avgKwh: 0.47),
    DayUsageData(day: 'Sat', totalKwh: 14.6, peakKwh: 4.8, peakTime: '2PM', avgKwh: 0.61),
    DayUsageData(day: 'Sun', totalKwh: 13.2, peakKwh: 4.5, peakTime: '3PM', avgKwh: 0.55),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "Power Usage",
        //   style: TextStyle(
        //     fontSize: 22,
        //     fontWeight: FontWeight.w800,
        //     color: Colors.black87,
        //   ),
        // ),
        // Text(
        //   "Your power consumption insights",
        //   style: TextStyle(
        //     fontSize: 13,
        //     fontWeight: FontWeight.w400,
        //     color: Colors.grey.shade700,
        //   ),
        // ),
        // const SizedBox(height: 20),
        // FilterPills(
        //   selected: _selected,
        //   onFilterChanged: (filter) {
        //     setState(() => _selected = filter);
        //   },
        // ),
        // const SizedBox(height: 20),
        // Daily
        if (_selected == AnalyticsFilter.daily) DailyUsageChart(data: _dummyDailyData),
        if (_selected == AnalyticsFilter.weekly) WeeklyUsageChart(data: _dummyWeeklyData),
      ],
    );
  }
}
