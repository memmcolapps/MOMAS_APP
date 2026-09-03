import 'dart:ui';

import 'package:momaspayplus/utils/colors.dart';

class RingData {
  final String label;
  final int count;
  final Color color;
  final Color trackColor;

  const RingData({
    required this.label,
    required this.count,
    required this.color,
    this.trackColor = MoColors.icyMist,
  });

  RingDataWithPct copyWithPct(int total) => RingDataWithPct(
    label: label,
    percentage: total == 0 ? 0 : count / total,
    color: color,
    trackColor: trackColor,
  );
}

class RingDataWithPct {
  final String label;
  final double percentage;
  final Color color;
  final Color trackColor;

  const RingDataWithPct({
    required this.label,
    required this.percentage,
    required this.color,
    required this.trackColor,
  });
}