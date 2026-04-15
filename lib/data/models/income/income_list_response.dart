import 'income_model.dart';

class IncomeListResponse {
  final List<IncomeModel> items;
  final int page;
  final int limit;
  final int total;

  IncomeListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory IncomeListResponse.fromJson(Map<String, dynamic> json) {
    return IncomeListResponse(
      items: (json['data'] as List)
          .map((e) => IncomeModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}