class NewsModel {
  final int id;
  final String titulo;
  final String resumen;
  final String imagenUrl;
  final String fecha;
  final String fuente;
  final String link;

  NewsModel({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.imagenUrl,
    required this.fecha,
    required this.fuente,
    required this.link,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'],
      titulo: json['titulo'],
      resumen: json['resumen'] ?? '',
      imagenUrl: json['imagenUrl'] ?? '',
      fecha: json['fecha'],
      fuente: json['fuente'] ?? '',
      link: json['link'] ?? '',
    );
  }
}