import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_event.dart';
import 'package:momaspayplus/bloc/payment_bloc/payment_state.dart';
import 'package:momaspayplus/utils/strings.dart';

import '../../domain/data/request/momas_payment_request.dart';
import '../../domain/repository/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<MakePayment>((event, emit) async {
      await payment(event, emit);
    });
    on<VerifyPayment>((event, emit) async {
      await verifyPayment(event, emit);
    });
    on<SearchPayment>((event, emit) async {
      await searchPayment(event, emit);
    });
    on<RetryPayment>((event, emit) async {
      await retryPayment(event, emit);
    });

    on<GenerateAccount>((event, emit) async {
      await generateAccount(event, emit);
    });

    on<ViewReceipt>((event, emit) async {
      await viewPayment(event, emit);
    });
  }

  payment(PaymentEvent event, Emitter<PaymentState> emit) async {
    if (event is MakePayment) {
      emit(PaymentLoading());
      try {
        // final MomasPaymentRequest request = MomasPaymentRequest(
        //     pay_type: event.payType.name,
        //     amount: event.amount,
        //     service_type: event.serviceType.name,
        //     action: event,
        //     tariff_id: event.tariffId
        //   // serviceId: event.serviceId,
        //   // amount: event.amount,
        //   // phone: event.phone,
        //   // variationCode: event.variationCode,
        //   // ref: event.ref,
        // );
        final response = await repository.fudWallet(event.momasPaymentRequest);
        // final response = await repository.fudWallet(
        //     event.amount, event.payType.name, event.serviceType.name, event.tariffId);

        print("pay_type bloc:" +event.momasPaymentRequest.pay_type);
        print("pay_type bloc:" +PaymentType.wallet.name);

        if (response.status == true) {
          if (event.momasPaymentRequest.pay_type == PaymentType.wallet.name) {
            emit(PaymentWalletSuccess(
                message: "Wallet Payment was successful",
                ref: response.ref ?? ""));
            return;
          } else {
            emit(PaymentSuccess(url: response.url ?? ""));
          }
        } else {
          emit(PaymentFailure(error: extractError(response.message)));
        }
        // if (response.status == true) {
        //   if (event.payType == PaymentType.wallet) {
        //     emit(PaymentWalletSuccess(
        //         message: "Wallet Payment was successful",
        //         ref: response.ref ?? ""));
        //     return;
        //   } else {
        //     emit(PaymentSuccess(url: response.url ?? ""));
        //   }
        // } else {
        //   emit(PaymentFailure(error: extractError(response.message)));
        // }
      } catch (e) {
        log('[PaymentBloc] payment error: $e');
        emit(PaymentFailure(error: e.toString()));
      }
    }
  }

  verifyPayment(VerifyPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await repository.verifyPayment(event.ref);
      if (response.status == true) {
        emit(PaymentVerified(
            paymentStatus: response.data?.paymentStatus ?? "failure",
            ref: response.data?.ref ?? ''));
      } else {
        emit(PaymentFailure(error: extractError(response.message)));
      }
    } catch (e) {
      log('[PaymentBloc] verifyPayment error: $e');
      emit(PaymentFailure(error: e.toString()));
    }
  }

  searchPayment(SearchPayment event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await repository.searchTransaction();
      if (response.status == true) {
        emit(PaymentHistorySuccess(response.data ?? []));
      } else {
        emit(const PaymentFailure(
            error: 'Unable to load transactions. Please try again.'));
      }
    } catch (e) {
      log('[PaymentBloc] searchPayment error: $e');
      emit(PaymentFailure(error: e.toString()));
    }
  }

  retryPayment(RetryPayment event, Emitter<PaymentState> emit) async {
    emit(const RetryLoading());
    try {
      final response = await repository.retryPayment(event.transactionId);
      if (response.status == true) {
        emit(MomasPaymentSuccess(response));
      } else {
        emit(RetryFailure(error: extractError(response.message)));
      }
    } catch (e) {
      log('[PaymentBloc] retryPayment error: $e');
      emit(RetryFailure(error: e.toString()));
    }
  }

  viewPayment(ViewReceipt event, Emitter<PaymentState> emit) async {
    emit(const ReceiptLoading());
    try {
      final response = await repository.getReceipt(event.transactionId);
      if (response.status == true) {
        emit(ViewMomasPaymentSuccess(response));
      } else {
        emit(ReceiptFailure(error: extractError(response.message)));
      }
    } catch (e) {
      log('[PaymentBloc] viewPayment error: $e');
      emit(ReceiptFailure(error: e.toString()));
    }
  }

  generateAccount(GenerateAccount event, Emitter<PaymentState> emit) async {
    emit(PaymentLoading());
    try {
      final response = await repository.generateAccount();
      if (response.status == true) {
        emit(MomasGenerateBank(response));
      } else {
        emit(const PaymentFailure(
            error: 'Unable to generate bank account. Please try again.'));
      }
    } catch (e) {
      log('[PaymentBloc] generateAccount error: $e');
      emit(PaymentFailure(error: e.toString()));
    }
  }
}

enum PaymentType { paystack, wallet, flutterwave, remita, enkpay }

// For Payment request
enum ServiceType {
  credit_token,
  data,
  airtime,
  electricity,
  cable,
  utilities,
  admin_fee
}
