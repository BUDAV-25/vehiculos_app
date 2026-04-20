import 'package:dio/dio.dart';

class GomasService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  // 🔍 Obtener gomas
  Future<List> obtenerGomas(String token, int vehiculoId) async {
    final response = await dio.get(
      "gomas",
      queryParameters: {
        "vehiculo_id": vehiculoId,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  }

  // 🔄 Actualizar estado
  Future<void> actualizarEstado({
    required String token,
    required int gomaId,
    required String estado,
  }) async {
    await dio.post(
      "gomas/actualizar",
      data: {
        "goma_id": gomaId,
        "estado": estado,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }

  // 🛠 Registrar pinchazo
  Future<void> registrarPinchazo({
    required String token,
    required int gomaId,
    required String descripcion,
    required String fecha,
  }) async {
    await dio.post(
      "gomas/pinchazos",
      data: {
        "goma_id": gomaId,
        "descripcion": descripcion,
        "fecha": fecha,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}