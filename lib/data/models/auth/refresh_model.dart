class RefreshModel {
  final String token;
  final String refreshToken;

  RefreshModel({
    required this.token,
    required this.refreshToken,
  });

  factory RefreshModel.fromJson(Map<String, dynamic> json) {
    return RefreshModel(
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}