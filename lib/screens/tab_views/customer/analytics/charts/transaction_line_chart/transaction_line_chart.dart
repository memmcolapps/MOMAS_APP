import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/analytics_data_response.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/transaction_line_chart/empty_chart.dart';
import 'package:momaspayplus/utils/amount_formatter.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/month_helper.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TransactionLineChart extends StatefulWidget {
  final String selectedYear;
  final List<MonthlyTransaction> transactions;

  const TransactionLineChart({
    super.key,
    required this.selectedYear,
    required this.transactions,
  });

  @override
  State<TransactionLineChart> createState() => _TransactionLineChartState();
}

class _TransactionLineChartState extends State<TransactionLineChart> {
  bool get _isEmpty => widget.transactions.every((t) => t.totalAmount == 0);

  int? _touchedIndex;

  static const double _xPadding = 0.5;

  double get _maxY {
    final max = widget.transactions
        .map((t) => t.totalAmount)
        .reduce((a, b) => a > b ? a : b);
    final magnitude = _niceNumber(max / 5);
    return (max / magnitude).ceil() * magnitude;
  }

  double get _interval => _maxY / 5;

  double _niceNumber(double value) {
    if (value <= 0) return 1;
    final exponent =
    (value.abs().toString().split('.')[0].length - 1).toDouble();
    final magnitude = _pow(10, exponent);
    final fraction = value / magnitude;
    if (fraction <= 1) return magnitude;
    if (fraction <= 2) return 2 * magnitude;
    if (fraction <= 5) return 5 * magnitude;
    return 10 * magnitude;
  }

  double _pow(double base, double exp) {
    double result = 1;
    for (int i = 0; i < exp; i++) result *= base;
    return result;
  }

  static const TextStyle _axisStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(0, 0, 0, 0.7),
  );

  static const double _yAxisReservedSize = 36;

  @override
  void initState() {
    super.initState();
    _touchedIndex = widget.transactions.length - 1;
  }

  @override
  void didUpdateWidget(TransactionLineChart old) {
    super.didUpdateWidget(old);
    if (old.selectedYear != widget.selectedYear) {
      setState(() => _touchedIndex = widget.transactions.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return const EmptyChart(message: "No transactions for this year");
    }

    final spots = widget.transactions
        .map((t) => FlSpot((t.month - 1).toDouble(), t.totalAmount))
        .toList();

    final barData = LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: const Color(0XFF6090FA),
      barWidth: 1,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF6090FA).withValues(alpha: 0.15),
            const Color(0xFF6090FA).withValues(alpha: 0.0),
          ],
        ),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) {
          if (index != _touchedIndex) {
            return FlDotCirclePainter(
              radius: 0,
              color: Colors.transparent,
              strokeColor: Colors.transparent,
              strokeWidth: 0,
            );
          }
          return _ChartDotPainter();
        },
      ),
    );

    final touched = _touchedIndex != null ? widget.transactions[_touchedIndex!] : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Info bar
        Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: touched != null
                ? Container(
              key: ValueKey(_touchedIndex),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF7086FD).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF7086FD).withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    MonthHelper.fullName(touched.month),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 1,
                    height: 12,
                    color: const Color(0xFF7086FD).withValues(alpha: 0.3),
                  ),
                  Text(
                    AmountFormatter.full(touched.totalAmount),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: MoColors.mainColor,
                    ),
                  ),
                ],
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),

        const SizedBox(height: 12),

        // Chart
        SizedBox(
          height: 260,
          child: LineChart(
            LineChartData(
              minX: -_xPadding,
              maxX: 11 + _xPadding,
              minY: 0,
              maxY: _maxY,
              clipData: const FlClipData.all(),
              lineTouchData: LineTouchData(
                handleBuiltInTouches: false,
                touchCallback: (event, response) {
                  if (event is FlPointerExitEvent ||
                      event is FlTapUpEvent ||
                      event is FlPanEndEvent) {
                    return;
                  }
                  if (response?.lineBarSpots != null) {
                    setState(() {
                      _touchedIndex = response!.lineBarSpots!.first.spotIndex;
                    });
                  }
                },
              ),
              extraLinesData: ExtraLinesData(
                extraLinesOnTop: false,
                verticalLines: _touchedIndex != null
                    ? [
                  VerticalLine(
                    x: spots[_touchedIndex!].x,
                    color: const Color(0xFF7086FD).withValues(alpha: 0.25),
                    strokeWidth: 1,
                    dashArray: [4, 4],
                  ),
                ]
                    : [],
                horizontalLines: [
                  HorizontalLine(
                    y: 0,
                    color: const Color.fromRGBO(0, 0, 0, 0.7),
                    strokeWidth: 1.2,
                  ),
                  HorizontalLine(
                    y: _maxY,
                    color: const Color.fromRGBO(0, 0, 0, 0.2),
                    strokeWidth: 1,
                    dashArray: [4, 6],
                  ),
                ],
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _interval,
                getDrawingHorizontalLine: (value) {
                  if (value == 0) {
                    return const FlLine(color: Colors.transparent, strokeWidth: 0);
                  }
                  return const FlLine(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    strokeWidth: 1,
                    dashArray: [4, 6],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 || index >= MonthHelper.shortLabels.length) {
                        return const SizedBox.shrink();
                      }
                      if ((value - index).abs() > 0.01) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(MonthHelper.shortLabels[index], style: _axisStyle),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameSize: 20,
                  axisNameWidget: Text(
                    "Amount",
                    style: AppTextStyles.sectionHeader.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(0, 0, 0, 0.7),
                    ),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: _interval,
                    reservedSize: _yAxisReservedSize,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Text(
                          AmountFormatter.abbreviated(value),
                          style: _axisStyle,
                          textAlign: TextAlign.right,
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [barData],
            ),
          ),
        ),
      ],
    );
  }
}

// _ChartDotPainter unchanged
class _ChartDotPainter extends FlDotPainter {
  _ChartDotPainter();

  @override
  List<Object?> get props => [];

  @override
  FlDotPainter lerp(FlDotPainter a, FlDotPainter b, double t) => b;

  @override
  void draw(Canvas canvas, FlSpot spot, Offset center) {
    canvas.drawCircle(center, 8,
        Paint()
          ..color = const Color(0XFF7086FD).withValues(alpha: 0.25)
          ..style = PaintingStyle.fill);
    canvas.drawCircle(center, 4,
        Paint()
          ..color = const Color(0XFF7086FD)
          ..style = PaintingStyle.fill);
    canvas.drawCircle(center, 4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1);
  }

  @override
  Size getSize(FlSpot spot) => const Size(16, 16);

  @override
  Color get mainColor => MoColors.mainColor;
}

