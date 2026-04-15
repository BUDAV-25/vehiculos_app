import 'maintenance_model.dart';

class MaintenanceListResponse {
  final List<MaintenanceModel> items;
  final int page;
  final int limit;
  final int total;

  MaintenanceListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory MaintenanceListResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceListResponse(
      items: (json['data'] as List)
          .map((e) => MaintenanceModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}