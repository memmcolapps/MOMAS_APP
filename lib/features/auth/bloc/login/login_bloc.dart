import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_event.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_state.dart';
import 'package:momaspayplus/features/auth/data/services/auth_service.dart';
import 'package:momaspayplus/core/storage/shared_pref.dart';
import 'package:momaspayplus/utils/strings.dart';

import '../../../../domain/data/response/user_model.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;

  LoginBloc(this.authService) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async => onLoginEvent(event, emit));
  }

  void onLoginEvent(LoginEvent event, Emitter<LoginState> emit) async {
    super.onEvent(event);

    if (event is UserLoginEvent) {
      try {
        emit(LoginLoading());
        UserModel response = await authService.login(event.login);
        if (response.status == true) {
          SharedPreferenceHelper.saveUser(response.user!.toJson());
          SharedPreferenceHelper.saveFeature(response.features!);
          SharedPreferenceHelper.saveLogin(event.login.toJson());
          SharedPreferenceHelper.saveToken(response.user!.token!);
          emit(LoginSuccess(
            role: response.user!.userRole!,
            user: response.user!,
            features: response.features!,
          ));
        } else {
          emit(LoginFailure(extractError(response.message)));
        }
      } catch (e) {
        log('[LoginBloc] login error: $e');
        emit(LoginFailure(e.toString()));
      }
    }
  }
}
