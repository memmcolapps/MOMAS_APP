import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/text/text_styles.dart';

class TrendBadge extends StatelessWidget {
  final double value;

  const TrendBadge({super.key, required this.value});

  bool get _isPositive => value >= 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: _isPositive
            ? MoColors.mintMist
            : MoColors.palePeach,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isPositive
                ? Icons.north_east_sharp
                : Icons.south_west_sharp,
            size: 12,
            color: _isPositive
                ? MoColors.mainColor
                : MoColors.brickRed,
          ),
          const SizedBox(width: 4),
          Text(
            '${value.abs().toStringAsFixed(0)}%',
            style: AppTextStyles.accent.copyWith(
              color: _isPositive
                  ? MoColors.mainColor
                  : MoColors.brickRed,
            ),
          ),
        ],
      ),
    );
  }
}