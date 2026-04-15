class PunctureModel {
  final int id;
  final int gomaId;
  final String descripcion;
  final String fecha;

  PunctureModel({
    required this.id,
    required this.gomaId,
    required this.descripcion,
    required this.fecha,
  });

  factory PunctureModel.fromJson(Map<String, dynamic> json) {
    return PunctureModel(
      id: json['id'],
      gomaId: json['gomaId'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
    );
  }
}