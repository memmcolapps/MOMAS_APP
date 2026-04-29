import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_bloc.dart';

import 'package:momaspayplus/features/auth/cubit/auth_view_cubit.dart';
import 'package:momaspayplus/features/auth/data/repositories/auth_repository.dart';
import 'package:momaspayplus/features/auth/data/services/auth_service.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/images.dart';
import 'package:momaspayplus/utils/screen_utils.dart';

import 'login_body.dart';
import 'forgot_password_body.dart';
import 'otp_verify_body.dart';
import 'reset_password_body.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthViewCubit(),
      child: const _AuthScaffold(),
    );
  }
}

class _AuthScaffold extends StatefulWidget {
  const _AuthScaffold();

  @override
  State<_AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<_AuthScaffold> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final view = context.watch<AuthViewCubit>().state;

    final headerTitle = switch (view) {
      AuthView.login => 'Welcome Back',
      AuthView.forgotPassword => 'Forgot Password',
      AuthView.otpVerify => 'Verify OTP',
      AuthView.resetPassword => 'Reset Password',
    };

    final headerSubtitle = switch (view) {
      AuthView.login => 'Login',
      AuthView.forgotPassword => 'Enter your email',
      AuthView.otpVerify => 'Enter the code sent to your email',
      AuthView.resetPassword => 'Enter your new password',
    };

    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) =>
              LoginBloc(AuthService(AuthRepository())),
        ),
        BlocProvider<ResetBloc>(
            create: (BuildContext context) =>
                ResetBloc(AuthService(AuthRepository()))),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: MoColors.mainColorII,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // ── Shared header ──────────────────────────────────
                Container(
                  color: MoColors.scaffoldWhite,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0.5, 0.8],
                        colors: [MoColors.mainColor, MoColors.mainColorII],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(100),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Center(child: Image.asset(MoImage.logo)),
                        const Spacer(),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Column(
                            key: ValueKey(view), // triggers animation on switch
                            children: [
                              Text(
                                headerTitle,
                                style: const TextStyle(
                                    fontSize: 32, color: Colors.white),
                              ),
                              Text(
                                headerSubtitle,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),

                // ── Swappable body ─────────────────────────────────
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                    color: MoColors.scaffoldWhite,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  padding: context.isTablet
                      ? EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.2)
                      : const EdgeInsets.all(0.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: switch (view) {
                      AuthView.login => LoginBody(
                          key: const ValueKey('login'),
                          emailController: emailController),
                      AuthView.forgotPassword => ForgotPasswordBody(
                          key: const ValueKey('forgot'),
                          emailController: emailController),
                      AuthView.otpVerify => OtpVerifyBody(
                          key: const ValueKey('otp'),
                          emailController: emailController),
                      AuthView.resetPassword => ResetPasswordBody(
                          key: const ValueKey('reset'),
                          resetToken:
                              context.read<AuthViewCubit>().resetToken ?? '',
                          isFirstLogin: false,
                        ),
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
