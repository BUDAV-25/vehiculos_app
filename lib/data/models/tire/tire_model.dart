class TireModel {
  final int id;
  final int vehiculoId;
  final String posicion;
  final int eje;
  final String estado;
  final int totalPinchazos;

  TireModel({
    required this.id,
    required this.vehiculoId,
    required this.posicion,
    required this.eje,
    required this.estado,
    required this.totalPinchazos,
  });

  factory TireModel.fromJson(Map<String, dynamic> json) {
    return TireModel(
      id: json['id'],
      vehiculoId: json['vehiculo_id'],
      posicion: json['posicion'],
      eje: json['eje'],
      estado: json['estado'],
      totalPinchazos: json['totalPinchazos'] ?? 0,
    );
  }
}