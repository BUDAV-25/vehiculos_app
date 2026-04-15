import 'tire_model.dart';

class TireStatusModel {
  final int cantidadRuedas;
  final List<TireModel> gomas;

  TireStatusModel({
    required this.cantidadRuedas,
    required this.gomas,
  });

  factory TireStatusModel.fromJson(Map<String, dynamic> json) {
    return TireStatusModel(
      cantidadRuedas: json['cantidadRuedas'],
      gomas: (json['gomas'] as List)
          .map((e) => TireModel.fromJson(e))
          .toList(),
    );
  }
}