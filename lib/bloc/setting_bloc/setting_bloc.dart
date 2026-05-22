import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_event.dart';
import 'package:momaspayplus/bloc/setting_bloc/setting_state.dart';
import 'package:momaspayplus/core/storage/shared_pref.dart';
import 'package:momaspayplus/utils/strings.dart';

import '../../domain/repository/setting_repository.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingRepository serviceRepository;

  SettingsBloc(this.serviceRepository) : super(SettingsStateInitial()) {
    on<SupportSettingEvent>((event, emit) async => onServiceEvent(event, emit));
    on<DeleteEvent>((event, emit) async => onDeleteEvent(event, emit));
    on<RequestMeterEvent>(
        (event, emit) async => onRequestMeteEvent(event, emit));
  }

  void onServiceEvent(
      SupportSettingEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);

    final cached = SharedPreferenceHelper.getSupport();
    if (cached != null) {
      emit(SettingsSupportStateLoading(data: cached));
    } else {
      emit(SettingsStateLoading());
    }

    try {
      var response = await serviceRepository.support();
      if (response.status == true && response.data != null) {
        await SharedPreferenceHelper.saveSupport(response.data!);
        emit(SettingsSupportStateLoading(data: response.data!));
      } else {
        if (cached == null) {
          emit(const SettingsStateFailed('Unable to load support contacts. Please try again.'));
        }
      }
    } catch (e) {
      log('[SettingsBloc] onServiceEvent error: $e');
      if (cached == null) emit(SettingsStateFailed(e.toString()));
    }
  }

  void onDeleteEvent(DeleteEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);
    try {
      emit(SettingsStateLoading());
      var response = await serviceRepository.deleteUser(event.email);
      if (response.status == true) {
        emit(SettingsSupportStateSuccess(response.message ?? ""));
      } else {
        emit(const SettingsStateFailed('Account deletion failed. Please try again.'));
      }
    } catch (e) {
      log('[SettingsBloc] onDeleteEvent error: $e');
      emit(SettingsStateFailed(e.toString()));
    }
  }

  void onRequestMeteEvent(
      RequestMeterEvent event, Emitter<SettingsState> emit) async {
    super.onEvent(event);
    try {
      emit(SettingsStateLoading());
      var response = await serviceRepository.requestMeter(
          event.email, event.fullName, event.phoneNumber, event.address);
      if (response.status == true) {
        emit(SettingsSupportStateSuccess(response.message ?? ""));
        return;
      } else {
        emit(SettingsStateFailed(
            extractError(response.message)));
      }
    } catch (e) {
      log('[SettingsBloc] onRequestMeteEvent error: $e');
      emit(SettingsStateFailed(e.toString()));
    }
  }
}
