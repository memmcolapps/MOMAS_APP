import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_event.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/screens/profile/request_meter_screen.dart';
import 'package:momaspayplus/screens/tab_views/customer/profile/widgets/profile_info_card.dart';
import 'package:momaspayplus/screens/tab_views/shared/tabview_skeleton.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/screen_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../bloc/setting_bloc/setting_bloc.dart';
import '../../../../bloc/setting_bloc/setting_state.dart';
import '../../../../domain/data/response/user_model.dart';
import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../domain/repository/setting_repository.dart';
import '../../../../features/auth/data/services/auth_service.dart';
import '../../../../reuseable/error_modal.dart';
import '../../../../utils/alert_dialog-view.dart';
import '../../../../core/storage/shared_pref.dart';
import '../../../../utils/strings.dart';
import '../../../auth/email_code_screen.dart';
import '../../../stack_screens/support/support_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  // late SettingsBloc settingsBloc;
  bool isDeleteAccount = false;
  @override
  void initState() {
    super.initState();
    // load();
    _loadBiometricPreference();
  }

  bool _isBiometricEnabled = false;

  /// Load biometric preference from SharedPreferences
  Future<void> _loadBiometricPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('biometric_enabled') ?? false;
    });
  }

  /// Save biometric preference to SharedPreferences
  Future<void> _saveBiometricPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', value);
    setState(() {
      _isBiometricEnabled = value;
    });
  }

  load() async {
    // settingsBloc = SettingsBloc(SettingRepository());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TabViewSkeleton(
        appBarTitle: 'PROFILE',
        body:

            // BlocConsumer<SettingsBloc, SettingsState>(
            //   // bloc: settingsBloc,
            //   builder: (context, state) {
            //     return
            SingleChildScrollView(
          child: Padding(
            padding: context.isTablet
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15)
                : const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const ProfileInfoCard(),

                // TODO(DON): Work on forgot password
                // Options
                // OptionTile(
                //   icon: Icons.lock,
                //   title: 'Reset Password',
                //   onTap: () {
                //     if (isNotEmpty(user?.email)) {
                //       AuthService(AuthRepository())
                //           .checkEmail(user!.email!, "reset")
                //           .then((value) {
                //         if (value.status == true) {
                //           Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                   builder: (_) => EmailCodeScreen(
                //                         email: user?.email ?? "",
                //                         passCode: PassCode.resetPassword,
                //                       )));
                //         } else {
                //           showErrorBottomSheet(
                //               context, value.message ?? "Error occurred!");
                //         }
                //       });
                //     }
                //   },
                // ),
                OptionTile(
                  icon: Icons.electric_meter,
                  title: 'Request for a meter',
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RequestMeterScreen())),
                ),
                OptionTile(
                    icon: Icons.support_agent,
                    title: 'Support',
                    onTap: () {
                      final settingBloc = context.read<SettingsBloc>();
                      settingBloc.add(SupportSettingEvent());
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                    value: settingBloc,
                                    child: const SupportScreen(),
                                  )));
                    }),
                OptionTile(
                    icon: Icons.delete,
                    title: 'Delete account',
                    onTap: () {
                      showAlertDialog(
                        context,
                        message:
                            "Are you sure you want to delete your account?",
                        onTap: () {
                          Navigator.pop(context);
                          setState(() => isDeleteAccount = true);

                          SettingRepository()
                              .deleteAccount(user!.email!)
                              .then((value) {
                            if (value.status == true) {
                              SharedPreferenceHelper.clearUser();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/", (route) => false);
                            }
                            setState(() => isDeleteAccount = false);
                          }).catchError((error) {
                            setState(() => isDeleteAccount = false);
                            SharedPreferenceHelper.clearUser();
                            Navigator.pushNamedAndRemoveUntil(
                                context, "/", (route) => false);
                          });
                        },
                      );
                    }),
                OptionTile(
                  icon: Icons.logout,
                  title: 'Log out',
                  onTap: () {
                    context.read<AuthCubit>().logout();
                    // SharedPreferenceHelper.clearUser();
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, "/", (route) => false);
                  },
                ),
                OptionTile(
                  icon: Icons.fingerprint,
                  title: "Enable Biometric Login",
                  showSwitch: true,
                  switchValue: _isBiometricEnabled,
                  onSwitchChanged: (value) => _saveBiometricPreference(value),
                )
              ],
            ),
          ),
        )
        // },
        // listener: (BuildContext context, SettingsState state) {
        //   switch (state) {
        //     case SettingsStateFailed():
        //       showErrorBottomSheet(context, state.error);
        //     case SettingsSupportStateSuccess():
        //       showSuccessBottomSheet(context, state.message);
        //     default:
        //       log("state not implemented");
        //   }
        // },
        // ),
        );
  }
}

class OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final bool showSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onSwitchChanged;

  const OptionTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.showSwitch = false,
    this.switchValue = false,
    this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Icon(icon, color: Colors.green),
            ),
            title: Text(
              title,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: showSwitch
                ? Switch(
                    activeTrackColor: MoColors.mainColor.withOpacity(0.5),
                    activeColor: MoColors.mainColor,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey
                        .withOpacity(0.5), // Grey track when disabled
                    value: switchValue,
                    onChanged: onSwitchChanged,
                  )
                : null,
            onTap: onTap,
          ),
        ),
        const Divider(
          thickness: 0.2,
          color: Colors.grey,
        )
      ],
    );
  }
}
