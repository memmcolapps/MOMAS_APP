import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/utils/shared_pref.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(null);

  Future<void> loadUser() async {
    final user = await SharedPreferenceHelper.getUser();
    emit(user);
  }

  // void logout() {
  //   SharedPreferenceHelper.clearUser();
  //   emit(null);
  // }
}