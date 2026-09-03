class PaymentVerificationResponse {
  bool? status;
  String? message;
  PaymentVerificationData? data;

  PaymentVerificationResponse({this.status, this.message, data});

  PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? PaymentVerificationData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = data;
    return data;
  }

}

class PaymentVerificationData {
  String? paymentStatus;
  String? ref;

  PaymentVerificationData({this.paymentStatus, this.ref});
  PaymentVerificationData.fromJson(Map<String, dynamic> json) {
    paymentStatus = json['payment_status'];
    ref = json['ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['payment_status'] = paymentStatus;
    return data;
  }
}
