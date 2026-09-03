class MeterStreamEventModel {
  final String meterNo;
  final String status;

  MeterStreamEventModel({
    required this.meterNo,
    required this.status,
  });

  factory MeterStreamEventModel.fromJson(Map<String, dynamic> json) {
    return MeterStreamEventModel(
      meterNo: json['meterNo'],
      status: json['status'],
    );
  }
}