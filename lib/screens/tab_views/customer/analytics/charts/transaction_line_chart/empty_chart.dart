import 'package:flutter/material.dart';

class EmptyChart extends StatelessWidget {
  final String message;
  final bool isError;

  const EmptyChart({
    super.key,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isError
        ? const Color(0xFFFA6060)
        : const Color(0xFF7086FD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Container(
          height: 260,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isError ? Icons.error_outline_rounded : Icons.bar_chart_rounded,
                size: 48,
                color: color.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}