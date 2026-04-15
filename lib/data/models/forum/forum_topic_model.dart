class ForumTopicModel {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String vehiculo;
  final String vehiculoFoto;
  final String autor;
  final int totalRespuestas;

  ForumTopicModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.vehiculo,
    required this.vehiculoFoto,
    required this.autor,
    required this.totalRespuestas,
  });

  factory ForumTopicModel.fromJson(Map<String, dynamic> json) {
    return ForumTopicModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'],
      vehiculo: json['vehiculo'],
      vehiculoFoto: json['vehiculoFoto'] ?? '',
      autor: json['autor'] ?? '',
      totalRespuestas: json['totalRespuestas'] ?? 0,
    );
  }
}