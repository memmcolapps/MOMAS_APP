class TrxHistoryResponse {
  bool? status;
  Data? data;
  String? message;

  TrxHistoryResponse({this.status, this.data});

  TrxHistoryResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? Data.fromJson(json['data'])
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

class Data {
  List<MeterData>? transactions;
  Data({this.transactions});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <MeterData>[];
      json['transactions'].forEach((v) {
        transactions!.add(MeterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> transactions = new Map<String, dynamic>();
    if (this.transactions != null) {
      transactions['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return transactions;
  }
}

class MeterData {
  String? meterNo;
  String? payType;
  String? trxId;
  String? userId;
  String? unitkwh;
  String? token;
  String? amount;
  String? status;
  String? vatAmount;
  String? service;
  String? serviceType;
  String? address;
  String? estateId;
  String? estateName;
  String? createdAt;
  String? updatedAt;

  MeterData(
      {this.trxId,
        this.userId,
        this.payType,
        this.token,
        this.amount,
        this.status,
        this.vatAmount,
        this.updatedAt,
        this.address,
        this.meterNo,
        this.estateId,
        this.estateName,
        this.createdAt,
        this.service,
        this.serviceType,
        this.unitkwh
      });

  MeterData.fromJson(Map<String, dynamic> json) {
    trxId = json['trx_id'];
    userId = json['user_id'];
    payType = json['pay_type'];
    token = json['token'];
    amount = json['amount'];
    status = json['status'];
    vatAmount = json['vatAmount'];
    updatedAt = json['updated_at'];
    address = json['address'];
    meterNo = json['meterNo'];
    estateName = json['estate_name'];
    estateId = json['estate_id'];
    createdAt = json['created_at'];

    serviceType = json['service_type'];
    service = json['service'];
    unitkwh = json['unitkwh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['trx_id'] = trxId;
    data['user_id'] = userId;
    data['pay_type'] = payType;
    data['token'] = token;
    data['amount'] = amount;
    data['status'] = status;
    data['vatAmount'] = vatAmount;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['address'] = address;
    data['meterNo'] = meterNo;
    data['estate_name'] = estateName;
    data['estate_id'] = estateId;
    data['service_type'] = serviceType;
    data['service'] = service;
    data['unitkwh'] = unitkwh;
    return data;
  }
}