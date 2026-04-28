import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/tab_cubit/tab_cubit.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_bloc.dart';

import 'package:momaspayplus/core/cubit/auth_cubit/auth_cubit.dart';
import 'package:momaspayplus/domain/data/request/login.dart';
import 'package:momaspayplus/domain/repository/auth_repository.dart';
import 'package:momaspayplus/domain/service/auth_service.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_event.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_state.dart';

import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/main.dart';
import 'package:momaspayplus/reuseable/error_modal.dart';

import 'package:momaspayplus/reuseable/mo_button.dart';
import 'package:momaspayplus/reuseable/mo_form.dart';

import 'package:momaspayplus/tabs/root_screen.dart';
import 'package:momaspayplus/utils/bio_metric_widget.dart';

import 'package:momaspayplus/utils/colors.dart';

import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/validators.dart';

class LoginBody extends StatefulWidget {
  final TextEditingController emailController;

  const LoginBody({super.key, required this.emailController});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController generalController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SharedPreferenceHelper.getLogin().then((onValue) {
      setState(() {
        if (onValue?.email != null) {
          generalController.text = onValue!.email!;
        }
        if (onValue?.meterNo != null) {
          generalController.text = onValue!.meterNo!;
        }
      });
    });
  }

  void _goToForgotPassword(BuildContext context) {
    context.read<AuthViewCubit>().showForgotPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        MoFormWidget(
          controller: generalController,
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.grey,
          ),
          title: "Email or Meter Number",
        ),
        MoFormWidget(
          controller: passwordController,
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          title: "Password",
          isPassword: true,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          child: Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => _goToForgotPassword(context),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(color: MoColors.mainColor),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthService(AuthRepository())),
          child: BlocConsumer<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: MoButton(
                        title: "LOGIN",
                        isLoading:
                            context.watch<LoginBloc>().state is LoginLoading,
                        onTap: () {
                          var meterNo = "";
                          var email = "";
                          if (FormValidators.isValidEmail(
                              generalController.text)) {
                            email = generalController.text;
                          } else {
                            meterNo = generalController.text;
                          }
                          final password = passwordController.text;
                          final login = Login(
                              meterNo: meterNo,
                              password: password,
                              email: email);
                          context
                              .read<LoginBloc>()
                              .add(UserLoginEvent(login));
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    BiometricLoginWidget(
                      onLoginSuccess: () {
                        SharedPreferenceHelper.getLogin().then((onValue) {
                          if (onValue != null && context.mounted) {
                            context
                                .read<LoginBloc>()
                                .add(UserLoginEvent(onValue));
                          }
                        });
                      },
                    )
                  ],
                ),
              );
            },
            listener: (BuildContext context, LoginState state) {
              switch (state) {
                case LoginFailure():
                  showErrorBottomSheet(context, state.error);
                case LoginSuccess():
                  context.read<TabCubit>().changeTab(0);
                  getIt<AuthCubit>().loginSuccess(state.user, state.features);
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (_) => const RootScreen()),
                  //     (v) => false);
                default:
                  log("state not implemented");
              }
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
