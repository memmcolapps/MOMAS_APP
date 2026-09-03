import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/section_header_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_line.dart';

class AccessTokensShimmer extends StatelessWidget {
  const AccessTokensShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Concentric ring skeleton
        const SizedBox(
          width: 180,
          height: 180,
          child: CustomPaint(
            painter: _ConcentricRingSkeletonPainter(),
          ),
        ),
        const SizedBox(width: 24),
        // Legend
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  ShimmerBox(
                    width: 10,
                    height: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLine(
                          height: 11, width: 60 + (i % 2) * 20.0),
                      const SizedBox(height: 4),
                      const ShimmerLine(height: 10, width: 40),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ConcentricRingSkeletonPainter extends CustomPainter {
  const _ConcentricRingSkeletonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radii = [size.width / 2 - 4, size.width / 2 - 18, size.width / 2 - 32];
    final colors = [
      const Color(0xFFE8E8E8),
      const Color(0xFFEEEEEE),
      const Color(0xFFF2F2F2),
    ];

    for (int i = 0; i < radii.length; i++) {
      final paint = Paint()
        ..color = colors[i]
        ..strokeWidth = 10
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radii[i], paint);
    }

    // Center text placeholder
    final innerPaint = Paint()
      ..color = const Color(0xFFEEEEEE)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 32, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}