import 'package:dio/dio.dart';

class CombustibleService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  Future<void> crearRegistro({
    required String token,
    required int vehiculoId,
    required String tipo,
    required double cantidad,
    required String unidad,
    required double monto,
  }) async {
    try {
      final response = await dio.post(
        "combustible",
        data: {
          "vehiculo_id": vehiculoId,
          "tipo": tipo,
          "cantidad": cantidad,
          "unidad": unidad,
          "monto": monto,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      print("Respuesta: ${response.data}");
    } catch (e) {
      print("Error combustible: $e");
      rethrow;
    }
  }
}