class VerifyOtpRequest {
  String? meterNo;
  String? email;
  String? code;

  VerifyOtpRequest({this.meterNo, this.email, this.code});

  VerifyOtpRequest.fromJson(Map<String, dynamic> json) {
    meterNo = json['meterNo'];
    email = json['email'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meterNo'] = meterNo;
    data['email'] = email;
    data['code'] = code;
    return data;
  }
}
