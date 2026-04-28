import 'package:flutter/material.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/section_header_shimmer.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_box.dart';
import 'package:momaspayplus/screens/tab_views/customer/analytics/widgets/reusable/shimmer/shimmer_line.dart';

class TransactionHistoryShimmer extends StatelessWidget {
  const TransactionHistoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Info badge
        ShimmerBox(
          width: 160,
          height: 32,
          borderRadius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 16),
        // Chart area
        SizedBox(
          height: 260,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Y-axis labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  6,
                      (_) => const ShimmerLine(height: 10, width: 28),
                ),
              ),
              const SizedBox(width: 8),
              // Chart body
              Expanded(
                child: Column(
                  children: [
                    const Expanded(
                      child: CustomPaint(
                        painter: _LineChartSkeletonPainter(),
                        child: SizedBox.expand(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // X-axis month labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        12,
                            (_) => const ShimmerLine(height: 10, width: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _LineChartSkeletonPainter extends CustomPainter {
  const _LineChartSkeletonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Grid lines
    for (int i = 1; i <= 4; i++) {
      final y = size.height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Wavy placeholder line
    final linePaint = Paint()
      ..color = const Color(0xFFD0D0D0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const points = [0.0, 0.4, 0.25, 0.65, 0.35, 0.2, 0.55, 0.1, 0.7, 0.45, 0.3, 0.6];
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      final x = size.width * i / (points.length - 1);
      final y = size.height * (1 - points[i]);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final prevX = size.width * (i - 1) / (points.length - 1);
        final prevY = size.height * (1 - points[i - 1]);
        final cpX = (prevX + x) / 2;
        path.cubicTo(cpX, prevY, cpX, y, x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    // Fill gradient below line
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF6090FA).withOpacity(0.08),
          const Color(0xFF6090FA).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fillPath, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}