import 'package:flutter/material.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int count;
  final int total;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
    required this.count,
    required this.total,
  });

  String get _pct {
    if (total == 0) return '0%';
    return '${(count / total * 100).toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(0, 0, 0, 0.7),
              ),
            ),
            Text(
              '$count tokens · $_pct',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }
}