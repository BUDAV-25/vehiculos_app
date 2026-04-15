class MaintenanceModel {
  final int id;
  final int vehiculoId;
  final String tipo;
  final double costo;
  final String piezas;
  final String fecha;
  final List<String> fotos;

  MaintenanceModel({
    required this.id,
    required this.vehiculoId,
    required this.tipo,
    required this.costo,
    required this.piezas,
    required this.fecha,
    required this.fotos,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      vehiculoId: json['vehiculo_id'],
      tipo: json['tipo'],
      costo: (json['costo'] ?? 0).toDouble(),
      piezas: json['piezas'] ?? '',
      fecha: json['fecha'],
      fotos: List<String>.from(json['fotos'] ?? []),
    );
  }
}