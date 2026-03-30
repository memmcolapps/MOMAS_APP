import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/screens/stack_screens/action_detail_skeleton.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import '../../bloc/setting_bloc/setting_bloc.dart';
import '../../bloc/setting_bloc/setting_event.dart';
import '../../bloc/setting_bloc/setting_state.dart';
import '../../domain/repository/setting_repository.dart';
import '../../reuseable/error_modal.dart';
import '../../reuseable/mo_form.dart';

class RequestMeterScreen extends StatefulWidget {
  const RequestMeterScreen({super.key});

  @override
  State<RequestMeterScreen> createState() => _RequestMeterScreenState();
}

class _RequestMeterScreenState extends State<RequestMeterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  late SettingsBloc settingsBloc;

  @override
  void initState() {
    super.initState();
    settingsBloc = SettingsBloc(SettingRepository());
      // ..add(SupportSettingEvent());
  }

  void _clearControllers() {
    fullNameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ActionDetailSkeleton(
      heading: "Request Meter",
      body: SingleChildScrollView(
        child: BlocConsumer<SettingsBloc, SettingsState>(
          bloc: settingsBloc,
          builder: (context, state) {
            return Padding(
              padding: context.isTablet
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15)
                  : const EdgeInsets.all(0),
              child: Column(
                children: [
                  MoFormWidget(
                    controller: fullNameController,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.grey,
                    ),
                    title: "Full Name",
                  ),
                  MoFormWidget(
                    controller: emailController,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    title: "Email Address",
                  ),
                  MoFormWidget(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    title: "Phone Number",
                  ),
                  MoFormWidget(
                    controller: addressController,
                    prefixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.grey,
                    ),
                    title: "Address",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: MoButton(
                        isLoading: state is SettingsStateLoading,
                        title: "Submit",
                        onTap: () {
                          settingsBloc.add(RequestMeterEvent(
                              emailController.text,
                              fullNameController.text,
                              phoneController.text,
                              addressController.text));
                        }),
                  )
                ],
              ),
            );
          },
          listener: (BuildContext context, SettingsState state) {
            switch (state) {
              case SettingsStateFailed():
                showErrorBottomSheet(context, state.error);
              case SettingsSupportStateSuccess():
                showSuccessBottomSheet(context, state.message);
                _clearControllers();
              default:
                log("state not implemented");
            }
          },
        ),
      ),
    );
  }
}
