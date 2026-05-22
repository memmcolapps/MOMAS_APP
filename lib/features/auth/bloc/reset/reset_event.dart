import 'package:equatable/equatable.dart';
import 'package:momaspayplus/features/auth/data/models/reset_request.dart';
import 'package:momaspayplus/features/auth/data/models/verify_otp_request.dart';

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

// class VerifyEmailEvent extends ResetEvent {
//   final String email;
//   final String code;
//   const VerifyEmailEvent(this.email, this.code);
//
//   @override
//   List<Object> get props => [email, code];
// }

class ResetAccountEvent extends ResetEvent {
  final ResetRequest resetData;
  const ResetAccountEvent(this.resetData);

  @override
  List<Object> get props => [resetData];
}

class VerifyOtpEvent extends ResetEvent {
  final VerifyOtpRequest otpData;
  const VerifyOtpEvent(this.otpData);

  @override
  List<Object> get props => [otpData];
}

class ResetPasswordEvent extends ResetEvent {
  final String resetToken;
  final String password;

  const ResetPasswordEvent(this.resetToken, this.password);

  @override
  List<Object> get props => [resetToken, password];
}


class SetFirstPasswordEvent extends ResetEvent {
  final String currentPassword;
  final String newPassword;

  const SetFirstPasswordEvent(this.currentPassword, this.newPassword);

  @override
  List<Object> get props => [currentPassword, newPassword];
}

enum CheckEmail { register, reset }
