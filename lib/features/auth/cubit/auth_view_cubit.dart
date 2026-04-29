import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthView {
  login,
  forgotPassword,
  otpVerify,
  resetPassword
}

class AuthViewCubit extends Cubit<AuthView> {
  AuthViewCubit() : super(AuthView.login);

  void showLogin() => emit(AuthView.login);
  void showForgotPassword() => emit(AuthView.forgotPassword);
  void showOtpVerify() => emit(AuthView.otpVerify);
  void showResetPassword() => emit(AuthView.resetPassword);
}