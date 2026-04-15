class OlvidarModel {
  final String matricula;
  final String nombre;
  final String correo;

  OlvidarModel({
    required this.matricula,
    required this.nombre,
    required this.correo,
  });

  factory OlvidarModel.fromJson(Map<String, dynamic> json) {
    return OlvidarModel(
      matricula: json['matricula'] ?? '',
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
    );
  }
}