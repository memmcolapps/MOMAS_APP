import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_event.dart';
import 'package:momaspayplus/features/auth/bloc/login/login_state.dart';
import 'package:momaspayplus/features/auth/data/services/auth_service.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

import '../../../../domain/data/response/generic_response.dart';
import '../../../../domain/data/response/user_model.dart';
import '../../../../utils/strings.dart';

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
          print("MI ${response.user!.monthlyAdminFee}");
          SharedPreferenceHelper.saveLogin(event.login.toJson());
          SharedPreferenceHelper.saveToken(response.user!.token!);
          emit(LoginSuccess(
            role: response.user!.userRole!,
            user: response.user!,
            features: response.features!,
          ));
        } else {
          emit(LoginFailure(response.message ?? ""));
        }
      } catch (_, e) {
        print(e);
        emit(LoginFailure(formatError(_.toString())));
      }
    }
  }
}
