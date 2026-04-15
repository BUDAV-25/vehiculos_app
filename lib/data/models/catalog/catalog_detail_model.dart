class CatalogDetailModel {
  final int id;
  final String marca;
  final String modelo;
  final int anio;
  final double precio;
  final List<String> imagenes;
  final String descripcion;
  final Map<String, dynamic> especificaciones;

  CatalogDetailModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.imagenes,
    required this.descripcion,
    required this.especificaciones,
  });

  factory CatalogDetailModel.fromJson(Map<String, dynamic> json) {
    return CatalogDetailModel(
      id: json['id'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      precio: (json['precio'] ?? 0).toDouble(),
      imagenes: List<String>.from(json['imagenes'] ?? []),
      descripcion: json['descripcion'] ?? '',
      especificaciones: json['especificaciones'] ?? {},
    );
  }
}