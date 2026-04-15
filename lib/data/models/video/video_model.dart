class VideoModel {
  final int id;
  final String youtubeId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String url;
  final String thumbnail;

  VideoModel({
    required this.id,
    required this.youtubeId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.url,
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      youtubeId: json['youtubeId'],
      titulo: json['titulo'],
      descripcion: json['descripcion'] ?? '',
      categoria: json['categoria'] ?? '',
      url: json['url'],
      thumbnail: json['thumbnail'],
    );
  }
}