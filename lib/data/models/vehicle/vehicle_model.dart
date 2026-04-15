class VehicleModel {
  final int id;
  final int usuarioId;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String fotoUrl;
  final String fechaRegistro;

  VehicleModel({
    required this.id,
    required this.usuarioId,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    required this.fotoUrl,
    required this.fechaRegistro,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      usuarioId: json['usuario_id'],
      placa: json['placa'],
      chasis: json['chasis'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      cantidadRuedas: json['cantidad_ruedas'],
      fotoUrl: json['foto_url'] ?? '',
      fechaRegistro: json['fecha_registro'],
    );
  }
}