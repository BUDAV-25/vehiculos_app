class IncomeModel {
  final int id;
  final int vehiculoId;
  final double monto;
  final String concepto;
  final String fecha;

  IncomeModel({
    required this.id,
    required this.vehiculoId,
    required this.monto,
    required this.concepto,
    required this.fecha,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      id: json['id'],
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'],
      monto: (json['monto'] ?? 0).toDouble(),
      concepto: json['concepto'] ?? '',
      fecha: json['fecha'],
    );
  }
}