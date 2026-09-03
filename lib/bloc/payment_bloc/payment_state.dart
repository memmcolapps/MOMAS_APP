import 'package:equatable/equatable.dart';
import 'package:momaspayplus/domain/data/response/payment_verification_response.dart';

import '../../domain/data/response/momas_payent_response.dart';
import '../../domain/data/response/bank_details.dart';
import '../../domain/data/response/transaction_data_response.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

abstract class PaymentFailureState extends PaymentState {
  final String error;
  const PaymentFailureState({required this.error});

  @override
  List<Object> get props => [error];
}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class ReceiptLoading extends PaymentState {
  const ReceiptLoading();
}

class ReceiptFailure extends PaymentFailureState {
  const ReceiptFailure({required super.error});
}

class RetryLoading extends PaymentState {
  const RetryLoading();
}

class RetryFailure extends PaymentFailureState {
  const RetryFailure({required super.error});
}

class PaymentVerified extends PaymentState {
  final String paymentStatus;
  final String ref;

  const PaymentVerified({required this.paymentStatus, required this.ref});

  @override
  List<Object> get props => [paymentStatus, ref];
}

class PaymentSuccess extends PaymentState {
  final String url;

  const PaymentSuccess({required this.url});

  @override
  List<Object> get props => [url];
}

class PaymentWalletSuccess extends PaymentState {
  final String message;
  final String ref;

  const PaymentWalletSuccess({required this.message, required this.ref});

  @override
  List<Object> get props => [message, ref];
}

class PaymentFailure extends PaymentFailureState {
  const PaymentFailure({required super.error});
}

class PaymentHistorySuccess extends PaymentState {
  final List<TransactionData> data;

  const PaymentHistorySuccess(this.data);

  @override
  List<Object> get props => [];
}

class MomasPaymentSuccess extends PaymentState {
  final MomasPaymentResponse momasPaymentResponse;

  const MomasPaymentSuccess(this.momasPaymentResponse);

  @override
  List<Object> get props => [momasPaymentResponse];
}

class MomasGenerateBank extends PaymentState {
  final BankDetail bankDetail;

  const MomasGenerateBank(this.bankDetail);

  @override
  List<Object> get props => [bankDetail];
}

class ViewMomasPaymentSuccess extends PaymentState {
  final MomasPaymentResponse momasPaymentResponse;

  const ViewMomasPaymentSuccess(this.momasPaymentResponse);

  @override
  List<Object> get props => [momasPaymentResponse];
}
