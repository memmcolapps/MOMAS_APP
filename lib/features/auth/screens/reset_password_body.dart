import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_event.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_state.dart';
import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/main.dart';
import 'package:momaspayplus/reuseable/app_error_display.dart';
import 'package:momaspayplus/reuseable/error_modal.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_form.dart';

class ResetPasswordBody extends StatefulWidget {
  final String resetToken;

  const ResetPasswordBody({
    super.key,
    required this.resetToken,
  });

  @override
  State<ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<ResetPasswordBody> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetBloc, ResetState>(
      listener: (context, state) {
        switch (state) {
          case ResetPasswordFailure():
            AppErrorDisplay.show(context, state.error);
          case ResetPasswordSuccess():
            context.read<AuthViewCubit>().showLogin();
          default:
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 100),
          MoFormWidget(
            controller: passwordController,
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            title: "New Password",
            isPassword: true,
          ),
          MoFormWidget(
            controller: confirmPasswordController,
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
            title: "Confirm Password",
            isPassword: true,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: MoButton(
                    isLoading: context.watch<ResetBloc>().state is ResetLoading,
                    title: "RESET PASSWORD",
                    onTap: () {
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        showErrorBottomSheet(context, "Passwords do not match");
                        return;
                      }
                      context.read<ResetBloc>().add(
                            ResetPasswordEvent(
                              widget.resetToken,
                              passwordController.text,
                            ),
                          );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          TextButton(
            onPressed: () => context.read<AuthViewCubit>().showOtpVerify(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}
