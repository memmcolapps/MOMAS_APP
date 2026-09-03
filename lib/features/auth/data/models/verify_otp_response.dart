class VerifyOtpResponse {
  bool? status;
  String? message;
  String? resetToken;

  VerifyOtpResponse({this.status, this.message, this.resetToken});

  VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    resetToken = json['data'] != null ? json['data']['reset_token'] : null;
  }
}