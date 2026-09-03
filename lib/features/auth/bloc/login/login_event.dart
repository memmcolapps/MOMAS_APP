
import 'package:equatable/equatable.dart';
import 'package:momaspayplus/features/auth/data/models/login_request.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class UserLoginEvent extends LoginEvent {
  final Login login;
  const UserLoginEvent(this.login);

  @override
  List<Object> get props => [login];
}