class ExpenseModel {
  final int id;
  final int vehiculoId;
  final int categoriaId;
  final String categoriaNombre;
  final double monto;
  final String descripcion;
  final String fecha;

  ExpenseModel({
    required this.id,
    required this.vehiculoId,
    required this.categoriaId,
    required this.categoriaNombre,
    required this.monto,
    required this.descripcion,
    required this.fecha,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      vehiculoId: json['vehiculo_id'] ?? json['vehiculoId'],
      categoriaId: json['categoria_id'] ?? json['categoriaId'],
      categoriaNombre: json['categoriaNombre'],
      monto: (json['monto'] ?? 0).toDouble(),
      descripcion: json['descripcion'] ?? '',
      fecha: json['fecha'],
    );
  }
}