class ResetRequest {
  String? meterNo;
  String? email;
  String? action;

  ResetRequest({this.meterNo, this.email, this.action});

  ResetRequest.fromJson(Map<String, dynamic> json) {
    meterNo = json['meterNo'];
    email = json['email'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meterNo'] = meterNo;
    data['email'] = email;
    data['action'] = action;
    return data;
  }
}
