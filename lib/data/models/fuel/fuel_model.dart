class FuelModel {
  final int id;
  final int vehiculoId;
  final String tipo; // combustible | aceite
  final double cantidad;
  final String unidad;
  final double monto;
  final String fecha;

  FuelModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.cantidad,
    required this.unidad,
    required this.monto,
    required this.fecha,
  });

  factory FuelModel.fromJson(Map<String, dynamic> json) {
    return FuelModel(
      id: json['id'],
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'],
      tipo: json['tipo'],
      cantidad: (json['cantidad'] ?? 0).toDouble(),
      unidad: json['unidad'],
      monto: (json['monto'] ?? 0).toDouble(),
      fecha: json['fecha'],
    );
  }
}