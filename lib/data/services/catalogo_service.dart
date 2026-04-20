import 'package:dio/dio.dart';
import 'package:vehiculos_app/data/models/catalog/catalog_detail_model.dart';
import 'package:vehiculos_app/data/models/catalog/catalog_list_response.dart';


class CatalogService {
  final Dio dio;

  CatalogService(this.dio);

  Future<CatalogListResponse> getCatalog({
    String? marca,
    String? modelo,
    int? anio,
    double? precioMin,
    double? precioMax,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await dio.get(
      '/catalogo',
      queryParameters: {
        if (marca != null && marca.trim().isNotEmpty) 'marca': marca.trim(),
        if (modelo != null && modelo.trim().isNotEmpty) 'modelo': modelo.trim(),
        if (anio != null) 'anio': anio,
        if (precioMin != null) 'precioMin': precioMin,
        if (precioMax != null) 'precioMax': precioMax,
        'page': page,
        'limit': limit,
      },
    );

    return CatalogListResponse.fromJson(response.data);
  }

  Future<CatalogDetailModel> getCatalogDetail(int id) async {
    final response = await dio.get(
      '/catalogo/detalle',
      queryParameters: {'id': id},
    );

    return CatalogDetailModel.fromJson(response.data['data']);
  }
}