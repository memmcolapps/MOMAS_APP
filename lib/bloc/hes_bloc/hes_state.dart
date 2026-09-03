
import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/hes_connection_response.dart';
import 'package:momaspayplus/domain/data/response/set_token_response.dart';

import '../../domain/data/model/meter_stream_event_data.dart';

abstract class HesState extends Equatable {
  HesState();

  @override
  List<Object> get props => [];
}

class HesInitial extends HesState {}

class HesLoading extends HesState {}

class HesPlansLoading extends HesState {}

class SetTokenSuccess extends HesState {
  final SetTokenResponse response;

  SetTokenSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class HesConnectionSuccess extends HesState {
  final HesConnectionResponse response;

  HesConnectionSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class MeterConnecting extends HesState {}

class MeterConnected extends HesState {

  final List<MeterStreamEventModel> meters;

  MeterConnected(this.meters);
}

// class DataFailure extends DataState {
//   final String error;
//
//   const DataFailure({required this.error});
//
//   @override
//   List<Object> get props => [error];
// }

class HesError extends HesState {

  final String error;

  HesError({required this.error});

  @override
  List<Object> get props => [error];
}