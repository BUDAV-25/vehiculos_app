import 'catalog_item_model.dart';

class CatalogListResponse {
  final List<CatalogItemModel> items;
  final int page;
  final int limit;
  final int total;

  CatalogListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory CatalogListResponse.fromJson(Map<String, dynamic> json) {
    return CatalogListResponse(
      items: (json['data'] as List)
          .map((e) => CatalogItemModel.fromJson(e))
          .toList(),
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
    );
  }
}