class RegistroModel {
  final int id;
  final String matricula;
  final String nombre;
  final String apellido;
  final String correo;
  final String token;

  RegistroModel({
    required this.id,
    required this.matricula,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.token,
  });

  factory RegistroModel.fromJson(Map<String, dynamic> json) {
    return RegistroModel(
      id: json['id'] ?? 0,
      matricula: json['matricula'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      correo: json['correo'] ?? '',
      token: json['token'] ?? '',
    );
  }
}