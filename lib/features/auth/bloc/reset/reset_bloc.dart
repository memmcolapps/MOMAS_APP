import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/domain/data/response/generic_response.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_event.dart';
import 'package:momaspayplus/features/auth/bloc/reset/reset_state.dart';

import '../../data/services/auth_service.dart';

class ResetBloc extends Bloc<ResetEvent, ResetState> {
  final AuthService authService;

  ResetBloc(this.authService) : super(ResetInitial()) {
    on<ResetAccountEvent>(_onCheckEmail);
    // on<VerifyOtpEvent>(_onVerifyOtp);
    // on<ResetPasswordEvent>(_onResetPassword);
  }

Future<void> _onCheckEmail(ResetAccountEvent event, Emitter<ResetState> emit) async {
  try {
    emit(ResetLoading());
    final response = await authService.checkEmail(event.resetData);
    if (response.status == true) {
      emit(EmailCheckSuccess(event.resetData.email ?? event.resetData.meterNo ?? ''));
    } else {
      emit(EmailCheckFail(response.message ?? ""));
    }
  } catch (e) {
    emit(EmailCheckFail(e.toString()));
  }
}

  // Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<ResetState> emit) async {
  //   try {
  //     emit(ResetLoading());
  //     final response = await authService.verifyOtp(event.email, event.code);
  //     if (response.status == true) {
  //       emit(OtpVerifySuccess());
  //     } else {
  //       emit(OtpVerifyFailure(response.message ?? ""));
  //     }
  //   } catch (e) {
  //     emit(OtpVerifyFailure(e.toString()));
  //   }
  // }

  // Future<void> _onResetPassword(ResetPasswordEvent event, Emitter<ResetState> emit) async {
  //   try {
  //     emit(ResetLoading());
  //     final response = await authService.resetPassword(event.password);
  //     if (response.status == true) {
  //       emit(ResetPasswordSuccess());
  //     } else {
  //       emit(ResetPasswordFailure(response.message ?? ""));
  //     }
  //   } catch (e) {
  //     emit(ResetPasswordFailure(e.toString()));
  //   }
  // }
}
