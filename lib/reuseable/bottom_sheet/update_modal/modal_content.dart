import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momaspayplus/features/app_update/bloc/update_state.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/app_info.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/modal_content_header.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/update_action_buttons.dart';
import 'package:momaspayplus/reuseable/bottom_sheet/update_modal/whats_new.dart';
import 'package:momaspayplus/utils/launcher.dart';

class ModalContent extends StatelessWidget {
  final bool mandatory;
  final AppUpdateRequired state;

  const ModalContent({
    required this.mandatory,
    required this.state,
    super.key,
  });

  void _onClose(BuildContext context) {
    if (context.mounted) Navigator.pop(context);
  }

  void _onUpdate(bool isIOS) {
    Launcher().launchInBrowser(
        Uri.parse(isIOS ? state.appStoreUrl : state.playStoreUrl));
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ModalContentHeader(
          mandatory: mandatory,
          isIOS: isIOS,
          onClose: _onClose,
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Update available',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F1F1F),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'To use this app, download the latest version.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5F6368),
            ),
          ),
        ),
        const SizedBox(height: 24),
        AppInfo(
          appSize: state.appSize,
          version: state.latestVersion,
        ),
        const SizedBox(height: 24),
        WhatsNew(
          whatsNewContent: state.appDesc,
          updateDate: state.lastUpdateDate,
        ),
        const SizedBox(height: 24),
        UpdateActionButtons(
          onUpdate: () => _onUpdate(isIOS),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
