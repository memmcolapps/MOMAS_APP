import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/model/analytics_data/chart_data.dart';
import 'package:momaspayplus/utils/colors.dart';

class DailyUsageChart extends StatefulWidget {
  final List<DailyUsageData> data;

  const DailyUsageChart({
    super.key,
    required this.data,
  });

  @override
  State<DailyUsageChart> createState() => _DailyUsageChartState();
}

class _DailyUsageChartState extends State<DailyUsageChart> {
  int? _touchedIndex;

  // Clipped data — only up to current hour
  List<DailyUsageData> get _clippedData {
    final currentHour = DateTime.now().hour;
    return widget.data.where((d) => d.hour <= currentHour).toList();
  }

// Peak based on clipped data only
  DailyUsageData get _peakData => _clippedData.reduce(
        (a, b) => a.kwh > b.kwh ? a : b,
  );

// Current usage — last item in clipped data
  DailyUsageData get _currentUsage => _clippedData.last;

// Spots based on clipped data only
  List<FlSpot> get _spots => _clippedData
      .map((d) => FlSpot(d.hour.toDouble(), d.kwh))
      .toList();

  String _formatHour(int hour) {
    if (hour == 0) return '12AM';
    if (hour == 12) return '12PM';
    if (hour < 12) return '${hour}AM';
    return '${hour - 12}PM';
  }

  // // Find peak usage hour
  // DailyUsageData get _peakData => widget.data.reduce(
  //       (a, b) => a.kwh > b.kwh ? a : b,
  // );
  //
  // DailyUsageData get _currentUsage {
  //   final currentHour = DateTime.now().hour;
  //   return widget.data.firstWhere(
  //         (d) => d.hour == currentHour,
  //     orElse: () => widget.data.last,
  //   );
  // }
  //
  // List<FlSpot> get _spots => widget.data
  //     .map((d) => FlSpot(d.hour.toDouble(), d.kwh))
  //     .toList();
  //
  // String _formatHour(int hour) {
  //   if (hour == 0) return '12AM';
  //   if (hour == 12) return '12PM';
  //   if (hour < 12) return '${hour}AM';
  //   return '${hour - 12}PM';
  // }

  @override
  Widget build(BuildContext context) {
    final peak = _peakData;
    final currentUsage = _currentUsage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Peak usage badge
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
                'Peak: ${peak.kwh} kWh at ${_formatHour(peak.hour)}',
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
          height: 220,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 23,
              minY: 0,
              maxY: (_peakData.kwh + 1).ceilToDouble(),

              // Touch interaction — shows tooltip on tap
              lineTouchData: LineTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex = response?.lineBarSpots?.first.spotIndex;
                  });
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => Colors.black87,
                  getTooltipItems: (spots) => spots.map((spot) {
                    return LineTooltipItem(
                      '${spot.y.toStringAsFixed(1)} kWh\n${_formatHour(spot.x.toInt())}',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }).toList(),
                ),
              ),

              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: Colors.grey.shade100,
                  strokeWidth: 1,
                ),
              ),

              borderData: FlBorderData(show: false),

              titlesData: FlTitlesData(
                // Y axis — kWh
                leftTitles: AxisTitles(
                  axisNameWidget: const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text('kWh', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                // X axis — hours
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 6, // show 12AM, 6AM, 12PM, 6PM
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) => Text(
                      _formatHour(value.toInt()),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),

              lineBarsData: [
                LineChartBarData(
                  spots: _spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: MoColors.mainColor,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      if (spot.x == peak.hour.toDouble()) {
                        return FlDotCirclePainter(  // ✅ show dot only on peak
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 2.5,
                          strokeColor: MoColors.mainColor,
                        );
                      }
                      return FlDotCirclePainter(    // ✅ invisible dot for all others
                        radius: 0,
                        color: Colors.transparent,
                        strokeWidth: 0,
                        strokeColor: Colors.transparent,
                      );
                    },
                  ),
                  // Gradient fill under the line
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MoColors.mainColor.withOpacity(0.3),
                        MoColors.mainColor.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),

                // Peak marker — separate red dot on peak hour
                LineChartBarData(
                  spots: [FlSpot(peak.hour.toDouble(), peak.kwh)],
                  isCurved: false,
                  color: Colors.transparent,
                  barWidth: 0,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 6,
                          color: Colors.red.shade400,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                  ),
                ),
              ],

              // Vertical line at peak hour
              extraLinesData: ExtraLinesData(
                verticalLines: [
                  VerticalLine(
                    x: peak.hour.toDouble(),
                    color: Colors.red.shade300.withOpacity(0.4),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ],

                horizontalLines: [
                  HorizontalLine(
                    y: currentUsage.kwh, // current hour's kwh value
                    color: MoColors.mainColor.withOpacity(0.5),
                    strokeWidth: 1.2,
                    dashArray: [4, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: MoColors.mainColor,
                      ),
                      labelResolver: (_) =>
                      'Now ${currentUsage.kwh} kWh',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}