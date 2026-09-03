import 'transaction_data_response.dart';

class MomasPaymentResponse {
  bool? status;
  MomasPaymentDataWrapper? data;
  String? message;

  MomasPaymentResponse({this.status, this.data, this.message});

  MomasPaymentResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? MomasPaymentDataWrapper.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MomasPaymentDataWrapper {
  MomasPaymentData? receipt;

  MomasPaymentDataWrapper.fromJson(Map<String, dynamic> json) {
    receipt = json['receipt'] != null
        ? MomasPaymentData.fromJson(json['receipt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (receipt != null) {
      data['receipt'] = receipt!.toJson();
    }

    return data;
  }
}

class MomasPaymentData {
  String? fullName;
  String? estateTitle;
  String? address;
  String? email;
  String? userId;
  String? vatAmount;
  String? token;
  String? unitKwh;
  String? amount;
  String? miscellaneous;
  String? miscellaneousTrxAmount;
  String? trxId;
  String? date;
  String? meterNo;
  PaymentStatus? status;
  String? service;
  String? serviceType;

  String? orderId;
  String? vendingAmount;
  String? vendAmountKwPerNaira;
  String? kctToken1;
  String? kctToken2;

  MomasPaymentData({
    this.fullName,
    this.estateTitle,
    this.address,
    this.email,
    this.userId,
    this.vatAmount,
    this.token,
    this.unitKwh,
    this.amount,
    this.miscellaneous,
    this.miscellaneousTrxAmount,
    this.trxId,
    this.date,
    this.meterNo,
    this.status,
    this.service,
    this.serviceType,

    this.orderId,
    this.vendingAmount,
    this.vendAmountKwPerNaira,
    this.kctToken1,
    this.kctToken2,

  });

  MomasPaymentData.fromJson(Map<String, dynamic> json) {
    fullName = json['fullname'];
    estateTitle = json['title'];
    address = json['address'];
    email = json['email'];
    userId = json['user_id'];
    vatAmount = json['vatAmount'];
    token = json['token'];
    unitKwh = json['unitkwh'];
    amount = json['amount'];
    miscellaneous = json['miscellaneous'];
    miscellaneousTrxAmount = json['miscellaneous_trx_amount'];
    trxId = json['trx_id'];
    date = json['updated_at'];
    meterNo = json['meterNo'];
    service = json['service'];
    serviceType = json['service_type'];

    orderId = json['order_id'];
    vendingAmount = json['vending_amount'];
    vendAmountKwPerNaira = json['vend_amount_kw_per_naira'];
    kctToken1 = json['kct_token1'];
    kctToken2 = json['kct_token2'];
    status = json['status'] != null
        ? PaymentStatus.fromValue(json['status'])
        : PaymentStatus.none;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullname'] = fullName;
    data['title'] = estateTitle;
    data['address'] = address;
    data['email'] = email;
    data['user_id'] = userId;
    data['vatAmount'] = vatAmount;
    data['token'] = token;
    data['unitkwh'] = unitKwh;
    data['amount'] = amount;
    data['miscellaneous'] = miscellaneous;
    data['miscellaneousTrxAmount'] = miscellaneousTrxAmount;
    data['trx_id'] = trxId;
    data['updated_at'] = date;
    data['meterNo'] = meterNo;
    data['service'] = service;
    data['service_type'] = serviceType;

    data['order_id'] = orderId;
    data['vending_amount'] = vendingAmount;
    data['vend_amount_kw_per_naira'] = vendAmountKwPerNaira;
    data['kct_token1'] = kctToken1;
    data['kct_token2'] = kctToken2;
    data['status'] = status;
    return data;
  }
}


// class MomasPaymentData {
//   String? fullName;
//   String? address;
//   String? service;
//   String? serviceType;
//   String? orderId;
//   String? token;
//   String? amount;
//   String? date;
//   String? meterNo;
//   String? kctToken1;
//   String? kctToken2;
//   String? vendingAmount;
//   String? vendAmountKwPerNaira;
//   String? vatAmount;
//   PaymentStatus? status;
//
//   MomasPaymentData({
//     this.fullName,
//     this.address,
//     this.service,
//     this.serviceType,
//     this.orderId,
//     this.token,
//     this.amount,
//     this.date,
//     this.meterNo,
//     this.kctToken1,
//     this.kctToken2,
//     this.vendingAmount,
//     this.vendAmountKwPerNaira,
//     this.vatAmount,
//     this.status,
//   });
//
//   MomasPaymentData.fromJson(Map<String, dynamic> json) {
//     fullName = json['full_name'];
//     address = json['address'];
//     service = json['service'];
//     serviceType = json['service_type'];
//     orderId = json['order_id'];
//     token = json['token'];
//     amount = json['amount'];
//     date = json['date'];
//     meterNo = json['meterNo'];
//     kctToken1 = json['kct_token1'];
//     kctToken2 = json['kct_token2'];
//     vendingAmount = json['vending_amount'];
//     vendAmountKwPerNaira = json['vend_amount_kw_per_naira'];
//     vatAmount = json['vat_amount'];
//     status = json['status'] != null
//         ? PaymentStatus.fromValue(json['status'])
//         : PaymentStatus.none;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['full_name'] = fullName;
//     data['address'] = address;
//     data['service'] = service;
//     data['service_type'] = serviceType;
//     data['order_id'] = orderId;
//     data['token'] = token;
//     data['amount'] = amount;
//     data['date'] = date;
//     data['meterNo'] = meterNo;
//     data['kct_token1'] = kctToken1;
//     data['kct_token2'] = kctToken2;
//     data['vend_amount_kw_per_naira'] = vendAmountKwPerNaira;
//     data['vending_amount'] = vendingAmount;
//     data['vat_amount'] = vatAmount;
//     data['status'] = status;
//     return data;
//   }
// }
