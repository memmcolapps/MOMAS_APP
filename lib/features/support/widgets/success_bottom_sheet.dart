import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:momaspayplus/core/widgets/mo_bottom_sheet.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/utils/images.dart'; // MoImage.lottieSuccess
import 'package:momaspayplus/utils/text/text_styles.dart';

class SuccessBottomSheet extends StatelessWidget {
  const SuccessBottomSheet({
    super.key,
    required this.message,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return MoBottomSheet(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Lottie.asset(
                MoImage.lottieSuccess,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ticket #136905',
              style: AppTextStyles.ticketHeading.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.ticketText.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 24),
            MoButton(
              title: 'Dismiss',
              onTap: onDismiss ?? () => Navigator.of(context).pop(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}