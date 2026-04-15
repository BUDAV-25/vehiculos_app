class ActivarModel {
  final int id;
  final String nombre;
  final String apellido;
  final String correo;
  final String token;
  final String refreshToken;

  ActivarModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.token,
    required this.refreshToken,
  });

  factory ActivarModel.fromJson(Map<String, dynamic> json) {
    return ActivarModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      token: json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }
}