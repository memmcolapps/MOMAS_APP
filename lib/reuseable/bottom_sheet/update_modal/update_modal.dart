import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momaspayplus/features/app_update/bloc/update_state.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/modal_content.dart';
import 'package:momaspayplus/utils/colors.dart';

class UpdateModal extends StatelessWidget {
  final AppUpdateRequired state;

  const UpdateModal({
    required this.state,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRequired = state.required;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child:
      Container(
        height: isRequired ? screenHeight : null,
        decoration: BoxDecoration(
          color: MoColors.whiteColor,
          borderRadius: isRequired
              ? null
              : const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: isRequired
              ? SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
                child: ModalContent(mandatory: isRequired, state: state),
              )
              : SingleChildScrollView(
                  child: ModalContent(mandatory: isRequired, state: state),
                ),
        ),
      ),
    );
  }
}
