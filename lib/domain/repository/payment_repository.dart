import 'package:momaspayplus/domain/data/response/payment_verification_response.dart';

import '../../core/network/routes.dart';
import '../data/request/momas_payment_request.dart';
import '../data/response/momas_payent_response.dart';
import '../data/response/bank_details.dart';
import '../data/response/is_admin_fees_paid.dart';
import '../data/response/payment_response.dart';
import '../data/response/transaction_data_response.dart';
import '../../core/network/request.dart';

class PaymentRepository {
  final ServerRequest _request = ServerRequest();

  Future<PaymentResponse> fudWallet(MomasPaymentRequest data) async {
    var response = await _request.postData(path: Routes.pay, body: data.toJson());
    return PaymentResponse.fromJson(response.data);
  }

  // Future<PaymentResponse> fudWallet(
  //     String amount, String paymentType, String serviceType, String tariffId) async {
  //   var response = await _request.postData(path: Routes.pay, body: {
  //     'pay_type': paymentType,
  //     'amount': amount,
  //     "service_type": serviceType,
  //     "action_payload": {
  //       "action": "momas_meter"
  //     },
  //     "tariff_id": tariffId,
  //   });
  //   return PaymentResponse.fromJson(response.data);
  // }

  Future<TransactionDataResponse> searchTransaction() async {
    var response = await _request.getData(path: Routes.getTransaction);
    return TransactionDataResponse.fromJson(response.data);
  }

  Future<PaymentVerificationResponse> verifyPayment(String ref) async {
    var response = await _request.getData(
        path: Routes.verifyPayment,
        dataToSend: {"reference": ref, "access_point": "mobile"});
    return PaymentVerificationResponse.fromJson(response.data);
  }

  Future<MomasPaymentResponse> retryPayment(String transactionRef) async {
    var response = await _request
        .postData(path: Routes.retryMeter, body: {"trxref": transactionRef});
    return MomasPaymentResponse.fromJson(response.data);
  }

  Future<BankDetail> generateAccount() async {
    var response = await _request.getData(
      path: Routes.getAccount,
    );
    return BankDetail.fromJson(response.data);
  }

  Future<IsAdminPaidModel> checkAminFeeIsPayed() async {
    var response = await _request.getData(
      path: Routes.adminFeeCheck,
    );
    return IsAdminPaidModel.fromJson(response.data);
  }

  Future<MomasPaymentResponse> getReceipt(String transactionRef) async {
    var response = await _request.getData(
        path: Routes.getTrx, dataToSend: {"transaction_id": transactionRef});
    return MomasPaymentResponse.fromJson(response.data);
  }
}
