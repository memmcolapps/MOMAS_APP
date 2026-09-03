class SetTokenResponse {
  final SetTokenData? data;
  final String? status;
  final String? timestamp;

  SetTokenResponse({
    this.data,
    this.status,
    this.timestamp,
  });

  factory SetTokenResponse.fromJson(Map<String, dynamic> json) {
    return SetTokenResponse(
      data: SetTokenData.fromJson(json['data']),
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }
}

class SetTokenData {
  final String meterSerial;
  final String token;
  final String status;
  final String dlmsStatus;
  final String message;
  // final String tokenStatus;
  // final num tokenResultCode;
  // final num meterCreditBalance;
  // final String logoutToken;

  final String? tokenStatus;
  final num? tokenResultCode;
  final num? meterCreditBalance;
  final String? logoutToken;

  SetTokenData({
    required this.meterSerial,
    required this.token,
    required this.status,
    required this.dlmsStatus,
    required this.message,
    required this.tokenStatus,
    required this.tokenResultCode,
    required this.meterCreditBalance,
    required this.logoutToken,
  });

  factory SetTokenData.fromJson(Map<String, dynamic> json) {
    return SetTokenData(
      // meterSerial: json['meterSerial'],
      // token: json['token'],
      // status: json['status'],
      // dlmsStatus: json['dlmsStatus'],
      // message: json['message'] ?? '',
      // tokenStatus: json['tokenStatus'],
      // tokenResultCode: json['tokenResultCode'],
      // meterCreditBalance: json['meterCreditBalance'],
      // logoutToken: json['logoutToken'],
      meterSerial: json['meterSerial']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      dlmsStatus: json['dlmsStatus']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      tokenStatus: json['tokenStatus']?.toString(),
      tokenResultCode: json['tokenResultCode'],
      meterCreditBalance: json['meterCreditBalance'],
      logoutToken: json['logoutToken']?.toString(),
    );
  }
}