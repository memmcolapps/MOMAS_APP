import 'package:momaspayplus/domain/data/response/feature.dart';
import 'package:momaspayplus/domain/data/response/tariff.dart';

class UserModel {
  bool? status;
  User? user;
  Feature? features;
  String? message;
  UserModel({this.status, this.user, this.features});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    features =
        json['features'] != null ? Feature.fromJson(json['features']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (features != null) {
      data['features'] = features!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? image;
  String? deviceId;
  int? mainWallet;
  int? role;
  int? code;
  String? pin;
  String? gender;
  String? city;
  String? state;
  String? lga;
  // String? meterNo;
  // String? meterType;
  // int? meterStatus;
  int? status;
  String? token;
  Meter? meter;
  String? estateId;
  String? estateName;
  String? hno;
  String? address;
  bool? monthlyAdminFee;
  bool? isDefaultPassword;
  // FlutterWaveKeys? flutterWaveKeys;
  // PayStackKeys? payStackKeys;
  UserRole? userRole;
  Purchase? purchase;
  List<Tariff>? tariffs;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.image,
    this.deviceId,
    this.mainWallet,
    this.role,
    this.code,
    this.pin,
    this.gender,
    this.city,
    this.state,
    this.lga,
    // this.meterNo,
    // this.meterType,
    this.status,
    this.token,
    this.meter,
    this.hno,
    this.address,
    this.monthlyAdminFee,
    this.isDefaultPassword,
    this.estateId,
    // this.flutterWaveKeys,
    // this.payStackKeys,
    this.userRole,
    this.purchase,
    this.tariffs,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    image = json['image'];
    deviceId = json['device_id'];
    mainWallet = json['main_wallet'];
    role = json['role'];
    code = json['code'];
    pin = json['pin'];
    gender = json['gender'];
    city = json['city'];
    state = json['state'];
    lga = json['lga'];
    // meterNo = json['meterNo'];
    // meterType = json['meterType'];
    // meterStatus =  json['meter_status'];
    meter = json['meter'] != null ? Meter.fromJson(json['meter']) : null;
    status = json['status'];
    token = json['token'];
    estateId = json['estate_id'];
    hno = json['hno'];
    monthlyAdminFee =
        (json['monthly_admin_fee']).toString() == "1" ? true : false;
    isDefaultPassword = (json['password_update_count']) == 0 ? true : false;
    address = json['address'];
    estateName = json['estate_name'];
    tariffs = json['tariff'] != null
        ? (json['tariff'] as List).map((v) => Tariff.fromJson(v)).toList()
        : [];
    purchase =
        json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
    userRole =
        json["role"] != null ? UserRole.getById(json["role"]) : UserRole.none;
    // flutterWaveKeys = json['flutterwave_keys'] != null
    //     ? new FlutterWaveKeys.fromJson(json['flutterwave_keys'])
    //     : null;
    // payStackKeys = json['paystack_keys'] != null
    //     ? new PayStackKeys.fromJson(json['paystack_keys'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['monthly_admin_fee'] = monthlyAdminFee;
    data['password_update_count'] = isDefaultPassword;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['phone'] = phone;
    data['email'] = email;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['main_wallet'] = mainWallet;
    data['role'] = role;
    data['code'] = code;
    data['pin'] = pin;
    data['gender'] = gender;
    data['city'] = city;
    data['state'] = state;
    data['lga'] = lga;
    // data['meterNo'] = meterNo;
    // data['meterType'] = meterType;
    // data['meter_status'] = meterStatus;
    data['meter'] = meter;
    data['status'] = status;
    data['token'] = token;
    data['estate_id'] = estateId;
    data['estate_name'] = estateName;
    data['tariff'] = tariffs?.map((value) {
      return value.toJson();
    }).toList();
    if (purchase != null) {
      data['purchase'] = purchase!.toJson();
    }

    // if (flutterWaveKeys != null) {
    //   data['flutterwave_keys'] = flutterWaveKeys!.toJson();
    // }
    // if (payStackKeys != null) {
    //   data['paystack_keys'] = payStackKeys!.toJson();
    // }
    return data;
  }
}

class Meter {
  String? meterNo;
  String? meterType;
  int? status;

  Meter({this.meterNo, this.meterType, this.status});

  Meter.fromJson(Map<String, dynamic> json) {
    meterNo = json['meterNo'];
    meterType = json['meterType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['meterNo'] = meterNo;
    data['meterType'] = meterType;
    data['status'] = status;
    return data;
  }
}

// class Features {
//   int? buyToken;
//   int? buyTokenOthers;
//   int? printToken;
//   int? accessToken;
//   int? services;
//   int? billPayment;
//   int? support;
//   int? topUp;
//   int? analysis;
//
//   Features(
//       {this.buyToken,
//       this.buyTokenOthers,
//       this.printToken,
//       this.accessToken,
//       this.services,
//       this.billPayment,
//       this.support,
//       this.topUp,
//       this.analysis});
//
//   Features.fromJson(Map<String, dynamic> json) {
//     buyToken = json['momas_meter'];
//     buyTokenOthers = json['other_meter'];
//     printToken = json['print_token'];
//     accessToken = json['access_token'];
//     services = json['services'];
//     billPayment = json['bill_payment'];
//     support = json['support'];
//     topUp = json['top_up'];
//     analysis = json['analysis'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['momas_meter'] = buyToken;
//     data['other_meter'] = buyTokenOthers;
//     data['print_token'] = printToken;
//     data['access_token'] = accessToken;
//     data['services'] = services;
//     data['bill_payment'] = billPayment;
//     data['support'] = support;
//     data['top_up'] = topUp;
//     data['analysis'] = analysis;
//
//     return data;
//   }
// }

// class PayStackKeys {
//   String? paystackSecret;
//   String? paystackPublic;
//
//   PayStackKeys({this.paystackSecret, this.paystackPublic});
//
//   PayStackKeys.fromJson(Map<String, dynamic> json) {
//     paystackSecret = json['paystack_secret'];
//     paystackPublic = json['paystack_public'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['paystack_secret'] = paystackSecret;
//     data['paystack_public'] = paystackPublic;
//     return data;
//   }
// }

// class FlutterWaveKeys {
//   String? flutterWaveSecret;
//   String? flutterWavePublic;
//
//   FlutterWaveKeys({this.flutterWaveSecret, this.flutterWavePublic});
//
//   FlutterWaveKeys.fromJson(Map<String, dynamic> json) {
//     flutterWaveSecret = json['flutterwave_secret'];
//     flutterWavePublic = json['flutterwave_public'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['flutterwave_secret'] = flutterWaveSecret;
//     data['flutterwave_public'] = flutterWavePublic;
//     return data;
//   }
// }

enum UserRole {
  none(0),
  admin(1),
  customer(2),
  estateManager(3),
  estateStaff(4);

  final int id;
  const UserRole(this.id);

  static UserRole getById(int id) {
    return UserRole.values.firstWhere(
      (role) => role.id == id,
      orElse: () => UserRole.none,
    );
  }
}

class Purchase {
  num? minPurchase;
  num? maxPurchase;
  num? minVending;

  Purchase({this.minPurchase, this.maxPurchase, this.minVending});

  Purchase.fromJson(Map<String, dynamic> json) {
    minPurchase = json['min_purchase'];
    maxPurchase = json['max_purchase'];
    minVending = json['min_vending'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_purchase'] = minPurchase;
    data['max_purchase'] = maxPurchase;
    data['min_vending'] = minVending;
    return data;
  }
}
