import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/features/app_update/bloc/update_state.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/app_info.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/modal_content_header.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/whats_new.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';

class UpdateActionButtons extends StatelessWidget {
  final VoidCallback onUpdate;

  const UpdateActionButtons({
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onUpdate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MoColors.mainColorII, // Your main green color
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 1,
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
    );
  }
}
