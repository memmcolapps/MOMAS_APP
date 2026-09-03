

import 'package:equatable/equatable.dart';
import 'package:momaspayplus/utils/network_enum.dart';

abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class BuyData extends DataEvent {
  final String serviceId;
  final String amount;
  final String phone;
  final String variationCode;
  final String ref;

  const BuyData({required this.serviceId, required this.amount, required this.phone, required this.variationCode, required this.ref});

  @override
  List<Object> get props => [serviceId, amount, phone, variationCode, ref];
}


class GetData extends DataEvent {
  final Network network;
  const GetData({required this.network});

  @override
  List<Object> get props => [network];
}