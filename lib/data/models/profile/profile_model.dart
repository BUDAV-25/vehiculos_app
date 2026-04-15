class ProfileModel {
  final int id;
  final String matricula;
  final String nombre;
  final String apellido;
  final String correo;
  final String rol;
  final String grupo;
  final String fotoUrl;
  final String fechaRegistro;

  ProfileModel({
    required this.id,
    required this.matricula,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.rol,
    required this.grupo,
    required this.fotoUrl,
    required this.fechaRegistro,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      matricula: json['matricula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      rol: json['rol'],
      grupo: json['grupo'],
      fotoUrl: json['fotoUrl'] ?? '',
      fechaRegistro: json['fechaRegistro'],
    );
  }
}