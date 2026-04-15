class VehicleSummaryModel {
  final double totalMantenimientos;
  final double totalCombustible;
  final double totalGastos;
  final double totalIngresos;
  final double totalInvertido;
  final double balance;

  VehicleSummaryModel({
    required this.totalMantenimientos,
    required this.totalCombustible,
    required this.totalGastos,
    required this.totalIngresos,
    required this.totalInvertido,
    required this.balance,
  });

  factory VehicleSummaryModel.fromJson(Map<String, dynamic> json) {
    return VehicleSummaryModel(
      totalMantenimientos: (json['totalMantenimientos'] ?? 0).toDouble(),
      totalCombustible: (json['totalCombustible'] ?? 0).toDouble(),
      totalGastos: (json['totalGastos'] ?? 0).toDouble(),
      totalIngresos: (json['totalIngresos'] ?? 0).toDouble(),
      totalInvertido: (json['totalInvertido'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}