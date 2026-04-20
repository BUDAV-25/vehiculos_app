import 'package:dio/dio.dart';

class GastosService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {"Accept": "application/json"},
    ),
  );

  // 📥 Categorías
  Future<List> obtenerCategorias(String token) async {
    final res = await dio.get(
      "gastos/categorias",
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }

  // 💸 Crear gasto
  Future<void> crearGasto({
    required String token,
    required int vehiculoId,
    required int categoriaId,
    required double monto,
  }) async {
    await dio.post(
      "gastos",
      data: {
        "vehiculo_id": vehiculoId,
        "categoria_id": categoriaId,
        "monto": monto,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // 📊 Listar gastos (paginado)
  Future<Map> obtenerGastos(
      String token, int vehiculoId, int page) async {
    final res = await dio.get(
      "gastos",
      queryParameters: {
        "vehiculo_id": vehiculoId,
        "page": page,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }

  // 💰 Crear ingreso
  Future<void> crearIngreso({
    required String token,
    required int vehiculoId,
    required double monto,
  }) async {
    await dio.post(
      "ingresos",
      data: {
        "vehiculo_id": vehiculoId,
        "monto": monto,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  // 📊 Listar ingresos
  Future<Map> obtenerIngresos(
      String token, int vehiculoId, int page) async {
    final res = await dio.get(
      "ingresos",
      queryParameters: {
        "vehiculo_id": vehiculoId,
        "page": page,
      },
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );

    return res.data;
  }
}