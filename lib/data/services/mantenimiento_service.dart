import 'package:dio/dio.dart';

class MantenimientoService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  Future<void> crearMantenimiento({
    required String token,
    required int vehiculoId,
    required String tipo,
    required double costo,
    required String piezas,
    required String fecha,
    required List fotos, // 🔥 AHORA RECIBE FOTOS
  }) async {
    try {
      // 🔥 FORM DATA PARA IMÁGENES
      FormData formData = FormData.fromMap({
        "vehiculo_id": vehiculoId,
        "tipo": tipo,
        "costo": costo,
        "piezas": piezas,
        "fecha": fecha,
        "fotos[]": fotos
            .map((f) => MultipartFile.fromFileSync(f.path))
            .toList(),
      });

      final response = await dio.post(
        "mantenimientos",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      print("Respuesta API: ${response.data}");
    } catch (e) {
      print("❌ Error creando mantenimiento: $e");
      rethrow;
    }
  }
}