import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthView {
  login,
  forgotPassword,
  otpVerify,
  resetPassword
}

class AuthViewCubit extends Cubit<AuthView> {
  AuthViewCubit() : super(AuthView.login);

  String? resetToken;

  void showLogin() => emit(AuthView.login);
  void showForgotPassword() => emit(AuthView.forgotPassword);
  void showOtpVerify() => emit(AuthView.otpVerify);
  void showResetPassword({String? token}) {
    resetToken = token;
    emit(AuthView.resetPassword);
  }
}