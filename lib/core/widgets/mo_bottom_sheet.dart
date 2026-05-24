import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class MoBottomSheet extends StatelessWidget {
  const MoBottomSheet({
    super.key,
    required this.child,
    this.showHandle = true,
  });

  final Widget child;
  final bool showHandle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: 20),
            Container(
              width: 128,
              height: 2,
              decoration: BoxDecoration(
                color: MoColors.ticketInfo.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 8),
          ],
          child,
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}