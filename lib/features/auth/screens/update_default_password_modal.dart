import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_event.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_state.dart';
import 'package:momaspayplus/features/auth/data/repositories/auth_repository.dart';
import 'package:momaspayplus/features/auth/data/services/auth_service.dart';
import 'package:momaspayplus/main.dart';
import 'package:momaspayplus/reuseable/app_error_display.dart';
import 'package:momaspayplus/reuseable/error_modal.dart';
import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_form.dart';

class UpdateDefaultPasswordModal extends StatefulWidget {
  const UpdateDefaultPasswordModal({super.key});

  @override
  State<UpdateDefaultPasswordModal> createState() =>
      _UpdateDefaultPasswordModalState();
}

class _UpdateDefaultPasswordModalState
    extends State<UpdateDefaultPasswordModal> {
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    oldPasswordController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetBloc(AuthService(AuthRepository())),
      child: BlocConsumer<ResetBloc, ResetState>(
        listener: (context, state) {
          switch (state) {
            case ResetPasswordSuccess():
              getIt<AuthCubit>().clearDefaultPassword();
              Navigator.pop(context);
            case ResetPasswordFailure():
              AppErrorDisplay.show(context, state.error);
            default:
              break;
          }
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Update Your Password",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "You are using a default password. Please update it to continue.",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  MoFormWidget(
                    controller: oldPasswordController,
                    prefixIcon: const Icon(Icons.lock_open, color: Colors.grey),
                    title: "Current Password",
                    isPassword: true,
                  ),
                  MoFormWidget(
                    controller: passwordController,
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    title: "New Password",
                    isPassword: true,
                  ),
                  MoFormWidget(
                    controller: confirmController,
                    prefixIcon:
                    const Icon(Icons.lock_outline, color: Colors.grey),
                    title: "Confirm Password",
                    isPassword: true,
                  ),
                  const SizedBox(height: 24),
                  MoButton(
                    isLoading: state is ResetLoading,
                    title: "UPDATE PASSWORD",
                    onTap: () {
                      if (passwordController.text != confirmController.text) {
                        showErrorBottomSheet(context, "Passwords do not match");
                        return;
                      }
                      context.read<ResetBloc>().add(
                        SetFirstPasswordEvent(
                          oldPasswordController.text,
                          passwordController.text,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}