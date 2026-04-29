import 'package:equatable/equatable.dart';
import 'package:momaspayplus/features/auth/data/models/reset_request.dart';

import '../../../../domain/data/request/register.dart';

abstract class ResetEvent extends Equatable {
  const ResetEvent();
}
//
// class UserResetEvent extends ResetEvent {
//   final Register register;
//   const UserResetEvent(this.register);
//
//   @override
//   List<Object> get props => [register];
// }
//
// class CheckEmailEvent extends ResetEvent {
//   final String email;
//   final CheckEmail checkEmailType;
//   const CheckEmailEvent(this.email, this.checkEmailType);
//
//   @override
//   List<Object> get props => [email];
// }

class VerifyEmailEvent extends ResetEvent {
  final String email;
  final String code;
  const VerifyEmailEvent(this.email, this.code);

  @override
  List<Object> get props => [email, code];
}

class ResetAccountEvent extends ResetEvent {
  final ResetRequest resetData;
  const ResetAccountEvent(this.resetData);

  @override
  List<Object> get props => [resetData];
}

class ResetPasswordEvent extends ResetEvent {
  final String email;
  final String password;
  final String confirmPassword;

  const ResetPasswordEvent(this.email, this.password, this.confirmPassword);

  @override
  List<Object> get props => [email, password, confirmPassword];
}

enum CheckEmail { register, reset }
