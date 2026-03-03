import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}


class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserRole role;

  const LoginSuccess({required this.role});

}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure(this.error);

  @override
  List<Object> get props => [error];
}
