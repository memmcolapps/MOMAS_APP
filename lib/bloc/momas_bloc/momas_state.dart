import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/token_fee_calc_response.dart';
import 'package:momaspayplus/domain/data/response/vending_properties.dart';

import '../../domain/data/response/momas_payent_response.dart';
import '../../domain/data/response/meter_payment_response.dart';
import '../../domain/data/response/momas_meter_response.dart';
import '../../domain/data/response/trx_history_response.dart';

abstract class MomasPaymentState extends Equatable {
  const MomasPaymentState();

  @override
  List<Object> get props => [];
}

class MomasPaymentInitial extends MomasPaymentState {}

class MomasPaymentLoading extends MomasPaymentState {}

class MomasVerificationLoading extends MomasPaymentState {}

class energyCalcLoading extends MomasPaymentState {}

class MomasMeterVerificationState extends MomasPaymentState {
  final MomasVerificationResponse response;

  const MomasMeterVerificationState({required this.response});
}

class EnergyCalcSuccess extends MomasPaymentState {
  final TokenFeeCalculationResponse response;

  const EnergyCalcSuccess({required this.response});
}

class MomasPaymentFailure extends MomasPaymentState {
  final String error;

  const MomasPaymentFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class MomasPaymentSuccess extends MomasPaymentState {
  final MomasPaymentResponse momasPaymentResponse;

  const MomasPaymentSuccess(this.momasPaymentResponse);

  @override
  List<Object> get props => [momasPaymentResponse];
}

class MomasMeterSuccess extends MomasPaymentState {
  final MeterPaymentResponse meterPaymentResponse;

  const MomasMeterSuccess(this.meterPaymentResponse);

  @override
  List<Object> get props => [meterPaymentResponse];
}

class MomasVendingProperties extends MomasPaymentState {
  final VendingPropertiesData vendingPropertiesData;

  const MomasVendingProperties(this.vendingPropertiesData);

  @override
  List<Object> get props => [vendingPropertiesData];
}

class MomasReprintTokenSuccess extends MomasPaymentState {
  final MomasPaymentResponse response;

  const MomasReprintTokenSuccess({required this.response});
}

class MomasFailedTransactionSuccess extends MomasPaymentState {
  final TrxHistoryResponse response;

  const MomasFailedTransactionSuccess({required this.response});
}