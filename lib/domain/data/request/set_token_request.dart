class SetTokenRequest {

  final String serial;
  final String token;

  SetTokenRequest({
    required this.serial,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
      'token': token,
    };
  }
}

class HesConnectionRequest {

  final String serial;

  HesConnectionRequest({
    required this.serial,
  });

  Map<String, dynamic> toJson() {
    return {
      'serial': serial,
    };
  }
}