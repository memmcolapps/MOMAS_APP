import 'package:equatable/equatable.dart';

abstract class ResetState extends Equatable {
  const ResetState();

  @override
  List<Object> get props => [];
}

class ResetInitial extends ResetState {}

class ResetLoading extends ResetState {}

// class ResetSuccess extends ResetState {
//   final String message;
//   const ResetSuccess(this.message);
//
//   @override
//   List<Object> get props => [message];
// }
//
// class ResetProcessFailure extends ResetState {
//   final String error;
//   const ResetProcessFailure(this.error);
//
//   @override
//   List<Object> get props => [error];
// }

// class EmailCheckSuccess extends ResetState {
//   final String email;
//   const EmailCheckSuccess(this.email);
//
//   @override
//   List<Object> get props => [email];
// }
// class EmailCheckFail extends ResetState {
//   final String error;
//   const EmailCheckFail(this.error);
//
//   @override
//   List<Object> get props => [error];
// }

// class EmailVerificationSuccess extends ResetState {
// }
// class  EmailVerificationFail extends ResetState {
//   final String error;
//   const EmailVerificationFail(this.error);
//
//   @override
//   List<Object> get props => [error];
// }

class ResetRequestSuccess extends ResetState {
  final String email;
  const ResetRequestSuccess(this.email);

  @override
  List<Object> get props => [email];
}

class ResetRequestFail extends ResetState {
  final String error;
  const ResetRequestFail(this.error);

  @override
  List<Object> get props => [error];
}

class OtpVerifySuccess extends ResetState {
  final String resetToken;
  const OtpVerifySuccess(this.resetToken);

  @override
  List<Object> get props => [resetToken];
}

class OtpVerifyFailure extends ResetState {
  final String error;
  const OtpVerifyFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ResetPasswordSuccess extends ResetState {
  final String message;
  const ResetPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ResetPasswordFailure extends ResetState {
  final String error;
  const ResetPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}