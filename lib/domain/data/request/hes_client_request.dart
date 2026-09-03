class HesClientRequest {
  String? clientId;
  String? clientSecret;

  HesClientRequest({this.clientId, this.clientSecret});

  HesClientRequest.fromJson(Map<String, dynamic> json) {
    clientId = json['clientId'];
    clientSecret = json['clientSecret'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clientSecret'] = clientSecret;
    return data;
  }
}
