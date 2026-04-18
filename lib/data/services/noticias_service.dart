import 'package:vehiculos_app/core/utils/dio_client.dart';
import '../models/noticia/noticia_model.dart';
import '../../core/constants/api_constants.dart';

class NoticiasService {
  final _dio = DioClient.instance.client;

  Future<List<NoticiaModel>> getNoticias() async {
    try {
      final response = await _dio.get(ApiConstants.noticias);
      final List data = response.data['data'] ?? [];

      return data.map((e) => NoticiaModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al cargar noticias: $e');
    }
  }

  Future<Map<String, dynamic>> getNoticiaDetalle(int id) async {
    try {
      final response = await _dio.get(
        ApiConstants.noticiaDetalle,
        queryParameters: {'id': id},
      );
      return response.data['data'] ?? {};
    } catch (e) {
      throw Exception('Error al cargar detalle: $e');
    }
  }
}
