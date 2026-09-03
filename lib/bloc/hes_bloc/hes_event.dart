

import 'package:equatable/equatable.dart';

import '../../domain/data/model/meter_stream_event_data.dart';
import '../../utils/network_enum.dart';

abstract class HesEvent extends Equatable {
  HesEvent();

  @override
  List<Object> get props => [];
}

class ConnectMeterStream extends HesEvent {}

class DisconnectMeterStream extends HesEvent {}

class MeterStatusReceived extends HesEvent {

  final MeterStreamEventModel meter;

  MeterStatusReceived(this.meter);
}

class LoadToken extends HesEvent {
  final String serial;
  final String token;

  LoadToken({required this.serial, required this.token});

  @override
  List<Object> get props => [serial, token];
}

class HesMeter extends HesEvent {
  final String serial;

  HesMeter({required this.serial});

  @override
  List<Object> get props => [serial];
}

// class LoadToken extends HesEvent {
//   final Network network;
//   LoadToken({required this.network});
//
//   @override
//   List<Object> get props => [network];
// }

