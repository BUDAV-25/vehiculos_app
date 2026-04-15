class LoginModel {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String? fotoUrl;
  final String token;
  final String refreshToken;

  LoginModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.fotoUrl,
    required this.token,
    required this.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      fotoUrl: json['fotoUrl'],
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}