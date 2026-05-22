import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_event.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_state.dart';

import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/features/auth/data/models/reset_request.dart';
import 'package:momaspayplus/reuseable/app_error_display.dart';
import 'package:momaspayplus/reuseable/error_modal.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_form.dart';
import 'package:momaspayplus/utils/validators.dart';

class ForgotPasswordBody extends StatefulWidget {
  final TextEditingController emailController;
  const ForgotPasswordBody({super.key, required this.emailController});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetBloc, ResetState>(
      listener: (context, state) {
        switch (state) {
          case ResetRequestSuccess():
            context.read<AuthViewCubit>().showOtpVerify();
          case ResetRequestFail():
            AppErrorDisplay.show(context, state.error);
          default:
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 100),
            MoFormWidget(
              controller: widget.emailController,
              // keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              title: "Email or Meter Number",
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: MoButton(
                      isLoading: state is ResetLoading,
                      title: "CONTINUE",
                      onTap: () {
                        var meterNo = "";
                        var email = "";
                        if (FormValidators.isValidEmail(
                            widget.emailController.text)) {
                          email = widget.emailController.text;
                        } else {
                          meterNo = widget.emailController.text;
                        }
                        final resetRequest = ResetRequest(
                            meterNo: meterNo, email: email, action: CheckEmail.reset.name);
                        context.read<ResetBloc>().add(ResetAccountEvent(resetRequest));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            TextButton(
              onPressed: () => context.read<AuthViewCubit>().showLogin(),
              child: const Text('Back to Login'),
            ),
          ],
        );
      },
    );
  }
}
