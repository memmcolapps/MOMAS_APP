import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_event.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_state.dart';
import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/reuseable/error_modal.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_passcode.dart';
import 'package:momaspayplus/utils/colors.dart';

class OtpVerifyBody extends StatefulWidget {
  final TextEditingController emailController;
  const OtpVerifyBody({super.key, required this.emailController});

  @override
  State<OtpVerifyBody> createState() => _OtpVerifyBodyState();
}

class _OtpVerifyBodyState extends State<OtpVerifyBody> {
  String _code = "";

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetBloc, ResetState>(
      listener: (context, state) {
        switch (state) {
          // case OtpVerifyFailure():
          //   showErrorBottomSheet(context, state.error);
          // case OtpVerifySuccess():
          //   context.read<AuthViewCubit>().showResetPassword();
          default:
            log("state not implemented");
        }
      },
      child: Column(
        children: [
          const SizedBox(height: 100),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                children: [
                  const TextSpan(text: '6 digit code has been sent to '),
                  TextSpan(
                    text: widget.emailController.text,
                    style: const TextStyle(
                      color: MoColors.mainColorII,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: '.\nCheck your inbox or spam folder.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: DynamicPasscodeForm(
              title: 'Enter Code',
              passcodeLength: 6,
              onPasscodeEntered: (v) {
                _code = v;
              },
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: MoButton(
                    isLoading: context.watch<ResetBloc>().state is ResetLoading,
                    title: "VERIFY",
                    onTap: () {
                      // context.read<ResetBloc>().add(
                      //   VerifyOtpEvent(
                      //     widget.emailController.text,
                      //     _code,
                      //   ),
                      // );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          TextButton(
            onPressed: () =>
                context.read<AuthViewCubit>().showForgotPassword(),
            child: const Text('Back'),
          ),
        ],
      ),
    );
  }
}