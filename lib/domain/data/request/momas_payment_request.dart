


import '../../../bloc/payment_bloc/payment_bloc.dart';

class MomasPaymentRequest {

  final String pay_type;
  final String amount;
  final String service_type;
  final ActionRequest action;
  final String tariff_id;

  MomasPaymentRequest({
    required this.pay_type,
    required this.amount,
    required this.service_type,
    required this.action,
    required this.tariff_id,
  });

  Map<String, dynamic> toJson() {
    return {
      'pay_type': pay_type,
      'amount': amount,
      'service_type': service_type,
      'action_payload': action,
      'tariff_id': tariff_id
    };
  }
}

class ActionRequest {

  final String type;

  ActionRequest({
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'action': type,
    };
  }
}