import 'vehicle_summary_model.dart';

class VehicleDetailModel {
  final int id;
  final String placa;
  final String chasis;
  final String marca;
  final String modelo;
  final int anio;
  final int cantidadRuedas;
  final String fotoUrl;
  final String fechaRegistro;
  final VehicleSummaryModel resumen;

  VehicleDetailModel({
    required this.id,
    required this.placa,
    required this.chasis,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.cantidadRuedas,
    required this.fotoUrl,
    required this.fechaRegistro,
    required this.resumen,
  });

  factory VehicleDetailModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailModel(
      id: json['id'],
      placa: json['placa'],
      chasis: json['chasis'],
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio'],
      cantidadRuedas: json['cantidadRuedas'],
      fotoUrl: json['fotoUrl'] ?? '',
      fechaRegistro: json['fechaRegistro'],
      resumen: VehicleSummaryModel.fromJson(json['resumen']),
    );
  }
}