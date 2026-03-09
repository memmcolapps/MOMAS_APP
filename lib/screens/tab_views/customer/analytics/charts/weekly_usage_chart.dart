import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/chart_data.dart';
import 'package:momaspayplus/utils/colors.dart';

class WeeklyUsageChart extends StatefulWidget {
  final List<DayUsageData> data;

  const WeeklyUsageChart({
    super.key,
    required this.data,
  });

  @override
  State<WeeklyUsageChart> createState() => _WeeklyUsageChartState();
}

class _WeeklyUsageChartState extends State<WeeklyUsageChart> {
  int? _selectedIndex;

  DayUsageData get _peakDay => widget.data.reduce(
        (a, b) => a.totalKwh > b.totalKwh ? a : b,
  );

  double get _maxY {
    final max = widget.data
        .map((d) => d.totalKwh)
        .reduce((a, b) => a > b ? a : b);
    return (max + 3).ceilToDouble(); // extra space for floating label
  }

  @override
  Widget build(BuildContext context) {
    final peak = _peakDay;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Peak badge — consistent with daily chart
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: MoColors.mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: MoColors.mainColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt, size: 16, color: MoColors.mainColor),
              const SizedBox(width: 4),
              Text(
                'Peak: ${peak.day} • ${peak.totalKwh} kWh • Peak hour: ${peak.peakTime}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: MoColors.mainColor,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 240,
          child: BarChart(
            BarChartData(
              maxY: _maxY,
              minY: 0,
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => MoColors.mainColorII,
                  tooltipBorderRadius: BorderRadius.circular(8),
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  tooltipMargin: 8,
                  direction: TooltipDirection.top,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final day = widget.data[groupIndex];
                    return BarTooltipItem(
                      '${day.totalKwh} kWh\n',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: 'Peak ${day.peakTime} • ${day.peakKwh} kWh',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event is FlTapUpEvent) {
                    final index = response?.spot?.touchedBarGroupIndex;
                    setState(() {
                      _selectedIndex = (_selectedIndex == index) ? null : index;
                    });
                  }
                },
                handleBuiltInTouches: true,
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= widget.data.length) {
                        return const SizedBox.shrink();
                      }
                      final isSelected = _selectedIndex == index;
                      final isPeak = widget.data[index].day == peak.day;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          widget.data[index].day,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected || isPeak
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isSelected
                                ? MoColors.mainColor
                                : isPeak
                                ? Colors.red.shade400
                                : Colors.grey.shade500,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text(
                      'kWh',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 4,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= widget.data.length) {
                        return const SizedBox.shrink();
                      }
                      final isSelected = _selectedIndex == index;
                      final isPeak = widget.data[index].day == peak.day;

                      // Show value above selected bar or peak bar
                      if (isSelected) {
                        return Text(
                          '${widget.data[index].totalKwh}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: MoColors.mainColor,
                          ),
                        );
                      }

                      if (isPeak && _selectedIndex == null) {
                        return Text(
                          '${widget.data[index].totalKwh}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade400,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 4,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: Colors.grey.shade100,
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(widget.data.length, (index) {
                final isSelected = _selectedIndex == index;
                final isPeak = widget.data[index].day == peak.day;
                final day = widget.data[index];

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: day.totalKwh,
                      width: 28,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: isSelected
                            ? [MoColors.mainColorII, MoColors.mainColor] // selected — full brand green
                            : isPeak
                            ? [Colors.red.shade200, Colors.red.shade400] // peak day — red
                            : [
                          MoColors.mainColor.withOpacity(0.15),
                          MoColors.mainColor.withOpacity(0.35),
                        ], // others — subtle
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}