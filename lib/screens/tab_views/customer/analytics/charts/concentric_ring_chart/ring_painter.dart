import 'dart:math';

import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/model/analytics_data/ring_data.dart';

class RingPainter extends CustomPainter {
  final List<RingDataWithPct> rings;

  static const double _strokeWidth = 8;
  static const double _gap = 12;
  static const double _startAngleDeg = 0;

  RingPainter({required this.rings});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = (size.width / 2) - (_strokeWidth / 2);

    for (int i = 0; i < rings.length; i++) {
      final radius = outerRadius - i * (_strokeWidth + _gap);
      final ring = rings[i];

      // Track
      final trackPaint = Paint()
        ..color = ring.trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _strokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, trackPaint);

      // Arc
      if (ring.percentage > 0) {
        final sweepDeg = ring.percentage * 360;
        final startDeg = _startAngleDeg - sweepDeg / 2;
        final startRad = _toRad(startDeg);
        final sweepRad = _toRad(sweepDeg);

        final arcPaint = Paint()
          ..color = ring.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = _strokeWidth
          ..strokeCap = StrokeCap.round;

        final rect = Rect.fromCircle(center: center, radius: radius);
        canvas.drawArc(rect, startRad, sweepRad, false, arcPaint);
      }
    }
  }

  double _toRad(double deg) => deg * pi / 180;

  @override
  bool shouldRepaint(RingPainter old) => old.rings != rings;
}