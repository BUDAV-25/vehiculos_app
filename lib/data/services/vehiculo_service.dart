import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/utils/dio_client.dart';

import '../models/vehicle/vehicle_list_response.dart';
import '../models/vehicle/vehicle_detail_model.dart';
import '../models/vehicle/vehicle_photo_response.dart';

class VehicleService {
  final Dio _dio = DioClient.instance.dio;

  /// ===============================
  // 🔹 GET VEHICULOS
  // ===============================
  Future<VehicleListResponse> getVehicles({
    int page = 1,
    int limit = 20,
    String? marca,
    String? modelo,
  }) async {
    try {
      final response = await _dio.get(
        '/vehiculos',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (marca != null && marca.isNotEmpty) 'marca': marca,
          if (modelo != null && modelo.isNotEmpty) 'modelo': modelo,
        },
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error obteniendo vehículos');
      }

      return VehicleListResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Error en getVehicles: $e');
    }
  }

  // ===============================
  // 🔹 DETALLE
  // ===============================
  Future<VehicleDetailModel> getVehicleDetail(int id) async {
    try {
      final response = await _dio.get(
        '/vehiculos/detalle',
        queryParameters: {'id': id},
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error obteniendo detalle');
      }

      return VehicleDetailModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error en getVehicleDetail: $e');
    }
  }

  // ===============================
  // 🔹 CREAR VEHICULO
  // ===============================
  Future<void> createVehicle({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "datax": jsonEncode(data),
      });

      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            "foto",
            await MultipartFile.fromFile(imagePath),
          ),
        );
      }

      final response = await _dio.post(
        '/vehiculos',
        data: formData,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error creando vehículo');
      }
    } catch (e) {
      throw Exception('Error en createVehicle: $e');
    }
  }

  // ===============================
  // 🔹 EDITAR VEHICULO
  // ===============================
  Future<void> updateVehicle(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '/vehiculos/editar',
        data: {
          "datax": jsonEncode(data),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error actualizando vehículo');
      }
    } catch (e) {
      throw Exception('Error en updateVehicle: $e');
    }
  }

  // ===============================
  // 🔹 SUBIR FOTO
  // ===============================
  Future<VehiclePhotoResponse> uploadPhoto({
    required int id,
    required String imagePath,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "datax": jsonEncode({"id": id}),
        "foto": await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '/vehiculos/foto',
        data: formData,
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Error subiendo foto');
      }

      return VehiclePhotoResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Error en uploadPhoto: $e');
    }
  }
}