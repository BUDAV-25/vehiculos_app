import 'forum_response_model.dart';

class ForumTopicDetailModel {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String vehiculo;
  final String vehiculoFoto;
  final String autor;
  final List<ForumResponseModel> respuestas;
  final int totalRespuestas;

  ForumTopicDetailModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.vehiculo,
    required this.vehiculoFoto,
    required this.autor,
    required this.respuestas,
    required this.totalRespuestas,
  });

  factory ForumTopicDetailModel.fromJson(Map<String, dynamic> json) {
    return ForumTopicDetailModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      vehiculo: json['vehiculo'],
      vehiculoFoto: json['vehiculoFoto'] ?? '',
      autor: json['autor'],
      respuestas: (json['respuestas'] as List)
          .map((e) => ForumResponseModel.fromJson(e))
          .toList(),
      totalRespuestas: json['totalRespuestas'] ?? 0,
    );
  }
}