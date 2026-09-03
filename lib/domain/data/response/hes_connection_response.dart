class HesConnectionResponse {
  final String meterNo;
  final String connectionType;
  final String onlineTime;
  final String offlineTime;
  final String updatedAt;

  HesConnectionResponse({
    required this.meterNo,
    required this.connectionType,
    required this.onlineTime,
    required this.offlineTime,
    required this.updatedAt,
  });

  factory HesConnectionResponse.fromJson(Map<String, dynamic> json) {
    return HesConnectionResponse(
        meterNo: json['meterNo'],
        connectionType: json['connectionType'],
        onlineTime: json['onlineTime'],
        offlineTime: json['offlineTime'],
        updatedAt: json['updatedAt']
    );
  }

  Map<String, dynamic> toJson() => {
    'meterNo': meterNo,
    'connectionType': connectionType,
    'onlineTime': onlineTime,
    'offlineTime': offlineTime,
    'updatedAt': updatedAt
  };
}