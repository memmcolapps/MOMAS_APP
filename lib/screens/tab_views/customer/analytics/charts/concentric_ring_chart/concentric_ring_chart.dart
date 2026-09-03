import 'dart:math';
import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/model/analytics_data/ring_data.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/concentric_ring_chart/legend_item.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/charts/concentric_ring_chart/ring_painter.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class ConcentricRingChart extends StatelessWidget {
  final List<RingData> rings;
  final double size;

  const ConcentricRingChart({
    super.key,
    required this.rings,
    this.size = 180,
  });

  int get _total => rings.fold(0, (sum, r) => sum + r.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: RingPainter(
                  rings: rings.map((r) => r.copyWithPct(_total)).toList(),
                ),
              ),
              // Center label
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$_total',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: const Color.fromRGBO(0, 0, 0, 0.85),
                      )),
                  const Text(
                    'Total',
                    style: AppTextStyles.label
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rings
              .map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: LegendItem(
                      color: r.color,
                      label: r.label,
                      count: r.count,
                      total: _total,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
