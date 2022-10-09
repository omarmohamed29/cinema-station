class Auth {
  late final String token;
  late final String userId;
  late final String expiryDate;
  late final String refreshToken;

  String? errorMessage;

  Auth.fromJson(Map<String, dynamic> json) {
    token = json['idToken'];
    userId = json['localId'];
    expiryDate = json['expiresIn'];
    refreshToken = json['refreshToken'];
  }

  Auth.toMap(Map<String, dynamic> json) {
    token = json['token'];
    userId = json['userId'];
    expiryDate = json['expiresIn'];
    refreshToken = json['refresh_token'];
  }

  Auth.refreshToMap(Map<String, dynamic> json) {
    token = json['id_token'];
    userId = json['user_id'];
    expiryDate = json['expires_in'];
    refreshToken = json['refresh_token'];
  }
  Auth(
      {required this.token,
      required this.userId,
      required this.expiryDate,
      required this.refreshToken,
      this.errorMessage});
}
