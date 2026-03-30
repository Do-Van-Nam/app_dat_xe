class SignInModel {
  final dynamic auth;
  final String sessionId;
  final String username;
  final String token;
  final String accessToken;
  final int expiresIn;
  final dynamic refreshToken;

  SignInModel({
    required this.auth,
    required this.sessionId,
    required this.username,
    required this.token,
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  factory SignInModel.fromJson(Map<String, dynamic> json) {
    return SignInModel(
      auth: json['auth'],
      sessionId: json['sessionId'] ?? '',
      username: json['username'] ?? '',
      token: json['token'] ?? '',
      accessToken: json['access_token'] ?? '',
      expiresIn: json['expires_in'] ?? 0,
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth': auth,
      'sessionId': sessionId,
      'username': username,
      'token': token,
      'access_token': accessToken,
      'expires_in': expiresIn,
      'refresh_token': refreshToken,
    };
  }
}