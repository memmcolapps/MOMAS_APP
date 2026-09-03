class HesTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String desc;
  final int expiresIn;

  HesTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.desc,
    required this.expiresIn,
  });

  factory HesTokenResponse.fromJson(Map<String, dynamic> json) {
    return HesTokenResponse(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      desc: json['desc'],
      expiresIn: json['expiresIn']
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'desc': desc,
    'expiresIn': expiresIn
  };
}