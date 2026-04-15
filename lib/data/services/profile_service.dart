import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/profile/profile_model.dart';
import '../models/profile/profile_photo_response.dart';
import '../../core/utils/dio_client.dart';

class ProfileService {
  final Dio _dio = DioClient.instance.client;

  // Obtener perfil
  Future<ProfileModel> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);

      if (response.data['success']) {
        return ProfileModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // Subir foto
  Future<ProfilePhotoResponse> uploadPhoto(String filePath) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        ApiConstants.profilePhoto,
        data: formData,
      );

      if (response.data['success']) {
        return ProfilePhotoResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Error al subir foto: $e');
    }
  }
}