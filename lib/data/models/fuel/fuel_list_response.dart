import 'fuel_model.dart';

class FuelListResponse {
  final List<FuelModel> items;
  final int page;
  final int limit;
  final int total;

  FuelListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory FuelListResponse.fromJson(Map<String, dynamic> json) {
    return FuelListResponse(
      items: (json['data'] as List)
          .map((e) => FuelModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}