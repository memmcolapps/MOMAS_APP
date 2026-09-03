import 'package:flutter/material.dart';
import 'package:momaspayplus/utils/colors.dart';

class ArrearsEmpty extends StatelessWidget {
  const ArrearsEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: MoColors.mainColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history_edu_rounded,
                  size: 48, color: MoColors.mainColor),
            ),
            const SizedBox(height: 20),
            const Text(
              "All Clear!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "You have no outstanding arrears at this time.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: Colors.grey[500], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}