import 'vehicle_model.dart';

class VehicleListResponse {
  final List<VehicleModel> vehicles;
  final int page;
  final int limit;
  final int total;

  VehicleListResponse({
    required this.vehicles,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory VehicleListResponse.fromJson(Map<String, dynamic> json) {
    return VehicleListResponse(
      vehicles: (json['data'] as List)
          .map((e) => VehicleModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}