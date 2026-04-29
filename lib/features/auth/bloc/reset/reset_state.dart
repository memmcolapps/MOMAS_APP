


import 'package:equatable/equatable.dart';

abstract class ResetState extends Equatable {
  const ResetState();

  @override
  List<Object> get props => [];
}



class ResetInitial extends ResetState {}

class ResetLoading extends ResetState {}

class ResetSuccess extends ResetState {
  final String message;
  const ResetSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ResetProcessFailure extends ResetState {
  final String error;
  const ResetProcessFailure(this.error);

  @override
  List<Object> get props => [error];
}


class EmailCheckSuccess extends ResetState {
  final String email;
  const EmailCheckSuccess(this.email);

  @override
  List<Object> get props => [email];
}
class EmailCheckFail extends ResetState {
  final String error;
  const EmailCheckFail(this.error);

  @override
  List<Object> get props => [error];
}


class EmailVerificationSuccess extends ResetState {
}
class  EmailVerificationFail extends ResetState {
  final String error;
  const EmailVerificationFail(this.error);

  @override
  List<Object> get props => [error];
}