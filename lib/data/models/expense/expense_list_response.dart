import 'expense_model.dart';

class ExpenseListResponse {
  final List<ExpenseModel> items;
  final int page;
  final int limit;
  final int total;

  ExpenseListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory ExpenseListResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseListResponse(
      items: (json['data'] as List)
          .map((e) => ExpenseModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}