import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/core/cubit/auth_cubit/auth_state.dart';
import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void loginSuccess(User user, Feature features) {
    emit(AuthAuthenticated(user, features));
  }

  Future<void> loadUser() async {
    final user = await SharedPreferenceHelper.getUser();

    if (user != null) {
      final features = SharedPreferenceHelper.getCachedFeature();
      emit(AuthAuthenticated(user, features));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void sessionExpired() {
    if (state is AuthUnauthenticated) return;
    SharedPreferenceHelper.clearUser();
    emit(AuthUnauthenticated());
  }

  void logout() {
    SharedPreferenceHelper.clearUser();
    emit(AuthUnauthenticated());
  }

  void clearDefaultPassword() {
    if (state is AuthAuthenticated) {
      final current = state as AuthAuthenticated;
      current.user.isDefaultPassword = false;
      emit(AuthAuthenticated(current.user, current.features));
    }
  }
}
