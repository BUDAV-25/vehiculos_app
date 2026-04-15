class CatalogItemModel {
  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final double precio;
  final String descripcionCorta;
  final String imagenUrl;

  CatalogItemModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.descripcionCorta,
    required this.imagenUrl,
  });

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) {
    return CatalogItemModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      precio: (json['precio'] ?? 0).toDouble(),
      descripcionCorta: json['descripcionCorta'] ?? '',
      imagenUrl: json['imagenUrl'] ?? '',
    );
  }
}