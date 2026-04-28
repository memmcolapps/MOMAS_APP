import 'package:flutter/material.dart';
import 'package:momaspayplus/reuseable/pop_button.dart';
import 'package:momaspayplus/reuseable/shadow_container.dart';
import 'package:momaspayplus/utils/colors.dart';

class StackScreenSkeleton extends StatelessWidget {
  final Widget body;
  final String heading;

  const StackScreenSkeleton({
    super.key,
    required this.body,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MoColors.mainColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: MoColors.scaffoldWhite,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(height: 13),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MoColors.borderIdle, width: 1),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      PopButton().pop(context),
                      const SizedBox(width: 16),
                      Text(
                        heading,
                        style: const TextStyle(
                          color: MoColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
          ),
        ),
      ),
    );
  }
}