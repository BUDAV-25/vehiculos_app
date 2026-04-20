import 'dart:convert';
import 'package:dio/dio.dart';

class ForoService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  // 📥 VEHÍCULOS
  Future<List<dynamic>> obtenerVehiculos(String token) async {
    try {
      final res = await dio.get(
        "vehiculos",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (res.data is Map && res.data["data"] != null) return res.data["data"];
      return (res.data is List) ? res.data : [];
    } catch (e) {
      return [];
    }
  }

  // ➕ CREAR TEMA - CORREGIDO
  Future<void> crearTema({
    required String token,
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    try {
      // 1. Convertimos los datos a un String JSON
      final String jsonPayload = jsonEncode({
        "vehiculo_id": vehiculoId,
        "titulo": titulo,
        "descripcion": descripcion,
      });

      // 2. Enviamos como x-www-form-urlencoded usando la llave 'datax'
      await dio.post(
        "foro/crear",
        data: {
          "datax": jsonPayload, // El servidor busca esta llave
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: Headers.formUrlEncodedContentType, // Importante: Formulario, no JSON
        ),
      );
    } on DioException catch (e) {
      print("❌ Error API Crear: ${e.response?.data}");
      // El servidor lanza 400 si el vehículo no tiene foto
      throw Exception(e.response?.data["message"] ?? "Error al crear el tema");
    }
  }

  // 💬 RESPONDER - CORREGIDO
  Future<void> responder({
    required String token,
    required int temaId,
    required String contenido,
  }) async {
    try {
      final String jsonPayload = jsonEncode({
        "tema_id": temaId,
        "contenido": contenido,
      });

      await dio.post(
        "foro/responder",
        data: {
          "datax": jsonPayload,
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } on DioException catch (e) {
      print("❌ Error API Responder: ${e.response?.data}");
      throw Exception(e.response?.data["message"] ?? "Error al responder");
    }
  }

  // 📥 LISTAR TEMAS
  Future<List<dynamic>> obtenerTemas(String token) async {
    try {
      final res = await dio.get(
        "foro/temas",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (res.data is Map && res.data["data"] != null) return res.data["data"];
      return [];
    } catch (e) {
      return [];
    }
  }

  // 📥 DETALLE
  Future<Map<String, dynamic>> obtenerDetalle(String token, int temaId) async {
    try {
      final res = await dio.get(
        "foro/detalle",
        queryParameters: {"id": temaId},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      if (res.data is Map && res.data["data"] != null) {
        return res.data["data"];
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }
}