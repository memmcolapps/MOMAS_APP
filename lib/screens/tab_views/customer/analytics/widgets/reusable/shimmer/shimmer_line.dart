import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';

class ShimmerLine extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius borderRadius;

  const ShimmerLine({
    super.key,
    this.height = 14,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width ?? double.infinity,
      height: height,
      borderRadius: borderRadius,
    );
  }
}
