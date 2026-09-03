import 'package:flutter/material.dart';

class ArrearsShimmer extends StatefulWidget {
  const ArrearsShimmer({super.key});

  @override
  State<ArrearsShimmer> createState() => _ArrearsShimmerState();
}

class _ArrearsShimmerState extends State<ArrearsShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemCount: 4,
      itemBuilder: (context, index) => _ShimmerCard(animation: _animation),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final Animation<double> animation;
  const _ShimmerCard({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ShimmerBox(
                    width: 130,
                    height: 16,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(6)),
                    animation: animation),
                _ShimmerBox(
                    width: 80,
                    height: 16,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(6)),
                    animation: animation),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _ShimmerBox(
                    width: 100,
                    height: 12,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(4)),
                    animation: animation),
                const Spacer(),
                _ShimmerBox(
                    width: 100,
                    height: 12,
                    borderRadius:
                    const BorderRadius.all(Radius.circular(4)),
                    animation: animation),
              ],
            ),
            const SizedBox(height: 14),
            _ShimmerBox(
              width: double.infinity,
              height: 44,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              animation: animation,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Animation<double> animation;
  final Color? baseColor;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, _) => DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(animation.value - 1, 0),
                end: Alignment(animation.value, 0),
                colors: [
                  baseColor ?? Colors.grey.shade200,
                  Colors.grey.shade100,
                  baseColor ?? Colors.grey.shade200,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}