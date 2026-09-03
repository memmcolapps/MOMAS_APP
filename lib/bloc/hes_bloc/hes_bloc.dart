import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/domain/data/request/set_token_request.dart';
import 'package:momaspayplus/domain/data/response/hes_connection_response.dart';
import 'package:momaspayplus/domain/data/response/set_token_response.dart';

import '../../domain/data/model/meter_stream_event_data.dart';
import '../../domain/repository/hes_repository.dart';
import '../../domain/repository/meter_stream_repository.dart';
import '../../utils/strings.dart';
import 'hes_event.dart';
import 'hes_state.dart';


class HesBloc extends Bloc<HesEvent, HesState> {
  final HesRepository repository;

  HesBloc({required this.repository}) : super(HesInitial()) {

    on<LoadToken>((event, emit) async {
      await mapEventToState(event, emit);
    });

    on<HesMeter>((event, emit) async {
      await mapOnlineEventToState(event, emit);
    });
  }

  Future mapEventToState(HesEvent event, Emitter<HesState> emit) async {
    if (event is LoadToken) {
      emit(HesLoading());
      try {
        final request = SetTokenRequest(
          serial: event.serial,
          token: event.token,
        );

        final response = await repository.hesLoadToken(request);

        if (response.status!.toLowerCase().contains("success")
            && response.data!.status.toLowerCase().contains("success")
            && response.data!.tokenStatus!.toLowerCase().contains("success")) {
          emit(SetTokenSuccess(response: response));
        } else {
          emit(HesError(error: getTokenError(response.data)));
        }
      } catch (e) {
        log('[HesBloc] Hes error: $e');
        emit(HesError(error: extractError(e.toString())));
      }
    }
  }

  String getTokenError(SetTokenData? data) {
    if (data == null) return "Operation failed.";

    if (data.message?.trim().isNotEmpty == true) {
      return data.message!;
    }

    switch (data.tokenStatus) {
      case "REJECT_TOKEN":
        return "The meter rejected the token.";
      case "REJECT":
        return "The meter rejected the token.";
      case "USED_TOKEN":
        return "This token has already been used.";
      case "USED":
        return "This token has already been used.";
      case "EXPIRED_TOKEN":
        return "The token has expired.";
      case "EXPIRED":
        return "The token has expired.";
      default:
        return data.tokenStatus ?? "Operation failed.";
    }
  }

  Future mapOnlineEventToState(HesEvent event, Emitter<HesState> emit) async {
    if (event is HesMeter) {
      emit(HesLoading());
      try {
        final request = HesConnectionRequest(
          serial: event.serial,
        );

        final response = await repository.hesMeterStatus(request);

        if (response.meterNo != null) {
          emit(HesConnectionSuccess(response: response));
        } else {
          emit(HesError(
            error: extractError("Error accessing data. Please try again."),
          ));
        }
      } catch (e) {
        log('[HesBloc] Hes error: $e');
        emit(HesError(error: extractError(e.toString())));
      }
    }
  }
}


class MeterStreamBloc
    extends Bloc<HesEvent, HesState> {

  final MeterRepository repository;

  StreamSubscription? _subscription;

  final List<MeterStreamEventModel> _meters = [];

  MeterStreamBloc(this.repository) : super(HesInitial()) {

    on<ConnectMeterStream>(_connect);

    on<MeterStatusReceived>(_received);

    on<DisconnectMeterStream>(_disconnect);

  }

  Future<void> _connect(
      ConnectMeterStream event,
      Emitter<HesState> emit) async {

    emit(MeterConnecting());

    _subscription?.cancel();

    _subscription = repository.streamMeters().listen(

          (meter) {

        add(MeterStatusReceived(meter));

      },

      onError: (_) {

        Future.delayed(
          const Duration(seconds: 2),
              () => add(ConnectMeterStream()),
        );

      },

      onDone: () {

        Future.delayed(
          const Duration(seconds: 2),
              () => add(ConnectMeterStream()),
        );

      },
    );
  }

  void _received(
      MeterStatusReceived event,
      Emitter<HesState> emit) {

    _meters.removeWhere(
            (m) => m.meterNo == event.meter.meterNo);

    _meters.add(event.meter);

    emit(MeterConnected(List.from(_meters)));
  }

  Future<void> _disconnect(
      DisconnectMeterStream event,
      Emitter<HesState> emit) async {

    await _subscription?.cancel();

    repository.dispose();

    emit(HesInitial());
  }

  @override
  Future<void> close() {

    _subscription?.cancel();

    repository.dispose();

    return super.close();
  }
}


