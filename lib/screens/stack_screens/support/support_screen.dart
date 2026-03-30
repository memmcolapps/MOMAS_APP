import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:momaspayplus/screens/stack_screens/stack_screen_skeleton.dart';
import 'package:momaspayplus/screens/stack_screens/support/widgets/support_option_card.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../../bloc/setting_bloc/setting_bloc.dart';
import '../../../bloc/setting_bloc/setting_event.dart';
import '../../../bloc/setting_bloc/setting_state.dart';
import '../../../domain/data/response/setting_response.dart';
import '../../../domain/repository/setting_repository.dart';
import '../../../reuseable/error_modal.dart';
import '../../../reuseable/pop_button.dart';
import '../../../reuseable/shadow_container.dart';
import '../../../utils/colors.dart';
import '../../../utils/launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StackScreenSkeleton(
      heading: 'Support',
      body: BlocConsumer<SettingsBloc, SettingsState>(
        // bloc: settingsBloc,
        builder: (context, state) {
          if (state is SettingsSupportStateLoading) {
            debugPrint("(state is SettingsSupportStateLoading) loading >>>>>");
          }
          final supportData = (state is SettingsSupportStateLoading) ? state.data : null;
          if (state is SettingsStateLoading) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: SpinKitFadingCircle(
                  color: MoColors.mainColor,
                  size: 30.0,
                ),
              ),
            );
          }

          return Padding(
            padding: context.isTablet
                ? EdgeInsets.only(
                    right: MediaQuery.of(context).size.width * 0.15,
                    left: MediaQuery.of(context).size.width * 0.15,
                  )
                : const EdgeInsets.all(0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Reach out to us for any issues, we are always here to support you',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.payment,
                  title: 'Payment Issues',
                  subtitle: 'Connect to us on all payment issues',
                  onTap: () {
                    Launcher().launchInBrowser(
                        Uri.parse(supportData?.paymentSupport ?? ""));
                  },
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.electric_meter,
                  title: 'Meter Issues',
                  subtitle: 'Connect to us on all meter issues',
                  onTap: () {
                    Launcher().launchInBrowser(
                        Uri.parse(supportData?.meterSupport ?? ""));
                  },
                ),
                const SizedBox(height: 20),
                SupportOption(
                  icon: Icons.help_outline,
                  title: 'Other Issues',
                  subtitle: 'Connect to us on all other issues',
                  onTap: () {
                    Launcher().launchInBrowser(
                        Uri.parse(supportData?.generalSupport ?? ""));
                  },
                ),
              ],
            ),
          );
        },
        listener: (BuildContext context, SettingsState state) {
          switch (state) {
            case SettingsStateFailed():
              showErrorBottomSheet(context, state.error);
            case SettingsSupportStateLoading():
              // supportData = state.data;
            default:
              log("state not implemented");
          }
        },
      ),
    );
  }
}


