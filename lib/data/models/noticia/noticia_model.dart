class NoticiaModel {
  final int id;
  final String titulo;
  final String resumen;
  final String imagenUrl;
  final String fecha;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.imagenUrl,
    required this.fecha,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    return NoticiaModel(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'] ?? '',
      imagenUrl: json['imagenUrl'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}
