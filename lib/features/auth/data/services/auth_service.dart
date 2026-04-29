import 'package:flutter/cupertino.dart';
import 'package:momaspayplus/domain/data/response/generic_response.dart';
import 'package:momaspayplus/features/auth/data/models/login_request.dart';
import 'package:momaspayplus/features/auth/data/models/reset_request.dart';
import 'package:momaspayplus/features/auth/data/models/verify_otp_request.dart';
import 'package:momaspayplus/features/auth/data/models/verify_otp_response.dart';
import 'package:momaspayplus/features/auth/data/repositories/auth_repository.dart';
import 'package:momaspayplus/utils/validators.dart';

import '../../../../domain/data/response/user_model.dart';

class AuthService {
  final AuthRepository repository;

  AuthService(this.repository);

  Future<UserModel> login(Login data) async {
    // if(isEmpty(data.meterNo) ){
    //   throw Exception("meter number is not valid");
    // }
    if (!FormValidators.isValidPassword(data.password ?? "")) {
      throw Exception("password is not valid");
    }

    return await repository.login(data);
  }

  // Future<GenericResponse> register(Register data) async {
  //   if (data.password != data.confirmPassword) {
  //     throw Exception("password mismatch");
  //   }
  //
  //   if (isEmpty(data.meterNo)) {
  //     throw Exception("meter number is not valid");
  //   }
  //   if (!FormValidators.isValidPassword(data.password ?? "")) {
  //     throw Exception("password is not valid");
  //   }
  //   if (isEmpty(data.firstName)) {
  //     throw Exception("first name can't be empty");
  //   }
  //   if (isEmpty(data.lastName)) {
  //     throw Exception("last name can't be empty");
  //   }
  //   return await repository.register(data);
  // }

  // Future<GenericResponse> checkEmail(ResetRequest data) async {
  //   // if (!FormValidators.isValidEmail(email)) {
  //   //   throw Exception("This email is not valid");
  //   // }
  //   return await repository.checkEmail(data);
  // }

  // Future<GenericResponse> verifyEmail(String email, String code) async {
  //   return await repository.verifyEmail(email, code);
  // }

  Future<GenericResponse> requestReset(ResetRequest data) async {
    return await repository.requestReset(data);
  }

  Future<VerifyOtpResponse> verifyOtp(VerifyOtpRequest data) async {
    return await repository.verifyOtp(data);
  }

  Future<GenericResponse> resetPassword(
      String resetToken, String password) async {
    return await repository.resetPassword(resetToken, password);
  }
}
