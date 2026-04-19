import 'package:dio/dio.dart';

class ForoService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {"Accept": "application/json"},
    ),
  );

  // 📝 Crear tema
  Future<void> crearTema({
    required String token,
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    await dio.post(
      "foro/crear",
      data: {
        "vehiculo_id": vehiculoId,
        "titulo": titulo,
        "descripcion": descripcion,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // 📋 Listar temas
  Future<dynamic> obtenerTemas(String token) async {
    final res = await dio.get(
      "foro/temas",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }

  // 🔍 Detalle tema
  Future<dynamic> detalleTema(String token, int id) async {
    final res = await dio.get(
      "foro/detalle",
      queryParameters: {"id": id},
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }

  // 💬 Responder
  Future<void> responder({
    required String token,
    required int temaId,
    required String contenido,
  }) async {
    await dio.post(
      "foro/responder",
      data: {
        "tema_id": temaId,
        "contenido": contenido,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // 👤 Mis temas
  Future<dynamic> misTemas(String token) async {
    final res = await dio.get(
      "foro/mis-temas",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }
}