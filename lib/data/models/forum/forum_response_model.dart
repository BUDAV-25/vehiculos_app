class ForumResponseModel {
  final int id;
  final String contenido;
  final String fecha;
  final String autor;

  ForumResponseModel({
    required this.id,
    required this.contenido,
    required this.fecha,
    required this.autor,
  });

  factory ForumResponseModel.fromJson(Map<String, dynamic> json) {
    return ForumResponseModel(
      id: json['id'],
      contenido: json['contenido'],
      fecha: json['fecha'],
      autor: json['autor'],
    );
  }
}