import 'package:equatable/equatable.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_bloc.dart';

import '../../domain/data/request/momas_payment_request.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class MakePayment extends PaymentEvent {

  final MomasPaymentRequest momasPaymentRequest;

  const MakePayment(
      {required this.momasPaymentRequest});

  @override
  List<Object> get props => [momasPaymentRequest];
}

// class MakePayment extends PaymentEvent {
//   final PaymentType payType;
//   final String amount;
//   final ServiceType serviceType;
//   final String action;
//   final String tariffId;
//
//   const MakePayment(
//       {required this.serviceType,
//       required this.payType,
//       required this.amount,
//       required this.tariffId,
//       required this.action});
//
//   @override
//   List<Object> get props => [payType, amount, serviceType, tariffId, action];
// }

class VerifyPayment extends PaymentEvent {
  final String ref;

  const VerifyPayment({required this.ref});

  @override
  List<Object> get props => [ref];
}

class SearchPayment extends PaymentEvent {
  const SearchPayment();

  @override
  List<Object> get props => [];
}

class GenerateAccount extends PaymentEvent {
  const GenerateAccount();

  @override
  List<Object> get props => [];
}

class RetryPayment extends PaymentEvent {
  const RetryPayment(this.transactionId);
  final String transactionId;

  @override
  List<Object> get props => [];
}

class ViewReceipt extends PaymentEvent {
  final String transactionId;
  const ViewReceipt(this.transactionId);

  @override
  List<Object> get props => [];
}
