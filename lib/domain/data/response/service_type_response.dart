class ServiceTypeResponse {
  bool? status;
  List<ServiceType>? data;
  String? message;

  ServiceTypeResponse({this.status, this.data, this.message});

  ServiceTypeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ServiceType>[];
      json['data'].forEach((v) {
        data!.add(ServiceType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceType {
  final int id;
  final String serviceTitle;

  ServiceType({required this.id, required this.serviceTitle});

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(id: json['id'], serviceTitle: json['service_title']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['serviceTitle'] = serviceTitle;
    return data;
  }
}
