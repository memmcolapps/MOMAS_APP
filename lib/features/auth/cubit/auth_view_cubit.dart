import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthView {login, forgotPassword}

class AuthViewCubit extends Cubit<AuthView> {
  AuthViewCubit() : super(AuthView.login);

  void showLogin() => emit(AuthView.login);
  void showForgotPassword() => emit(AuthView.forgotPassword);
}