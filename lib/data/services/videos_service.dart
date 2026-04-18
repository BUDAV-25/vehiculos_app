import 'package:vehiculos_app/core/utils/dio_client.dart';
import '../models/video/video_model.dart';
import '../../core/constants/api_constants.dart';

class VideosService {
  final _dio = DioClient.instance.client;

  Future<List<VideoModel>> getVideos() async {
    try {
      final response = await _dio.get(ApiConstants.videos);
      final List data = response.data['data'] ?? [];
      return data.map((e) => VideoModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al cargar videos: $e');
    }
  }
}
