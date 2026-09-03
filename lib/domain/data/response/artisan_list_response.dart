class ArtisanListResponse {
  bool? status;
  String? message;
  ArtisanData? data;

  ArtisanListResponse({this.status, this.message, this.data});

  ArtisanListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ArtisanData.fromJson(json['data']) : null;
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

class ArtisanData {
  List<Artisan>? artisans;

  ArtisanData({this.artisans});

  ArtisanData.fromJson(Map<String, dynamic> json) {
    if (json['artisans'] != null) {
      artisans = <Artisan>[];
      json['artisans'].forEach((v) {
        artisans!.add(Artisan.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (artisans != null) {
      data['artisans'] = artisans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Artisan {
  int? id;
  String? userId;
  String? estateId;
  String? serviceId;
  String? serviceTitle;
  int? status;
  String? professionalId;
  String? professionalName;
  String? professionalPhone;
  String? professionalEmail;
  String? rating;
  String? commentId;

  Artisan({
    this.id,
    this.userId,
    this.estateId,
    this.serviceId,
    this.serviceTitle,
    this.status,
    this.professionalId,
    this.professionalName,
    this.professionalPhone,
    this.professionalEmail,
    this.rating,
    this.commentId,
  });

  Artisan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    estateId = json['estate_id'];
    serviceId = json['service_id'];
    serviceTitle = json['service_title'];
    status = json['status'];
    professionalId = json['professional_id'];
    professionalName = json['professional_name'];
    professionalPhone = json['professional_phone'];
    professionalEmail = json['professional_email'];
    rating = json['rating'];
    commentId = json['comment_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['estate_id'] = estateId;
    data['service_id'] = serviceId;
    data['service_title'] = serviceTitle;
    data['status'] = status;
    data['professional_id'] = professionalId;
    data['professional_name'] = professionalName;
    data['professional_phone'] = professionalPhone;
    data['professional_email'] = professionalEmail;
    data['rating'] = rating;
    data['comment_id'] = commentId;
    return data;
  }
}