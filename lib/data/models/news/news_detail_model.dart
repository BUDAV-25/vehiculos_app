class NewsDetailModel {
  final int id;
  final String titulo;
  final String resumen;
  final String contenido; // HTML
  final String imagenUrl;
  final String fecha;
  final String fuente;
  final String link;

  NewsDetailModel({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.contenido,
    required this.imagenUrl,
    required this.fecha,
    required this.fuente,
    required this.link,
  });

  factory NewsDetailModel.fromJson(Map<String, dynamic> json) {
    return NewsDetailModel(
      id: json['id'],
      titulo: json['titulo'],
      resumen: json['resumen'] ?? '',
      contenido: json['contenido'] ?? '',
      imagenUrl: json['imagenUrl'] ?? '',
      fecha: json['fecha'],
      fuente: json['fuente'] ?? '',
      link: json['link'] ?? '',
    );
  }
}