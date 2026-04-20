import 'dart:convert';
import 'package:dio/dio.dart';

class GastosService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://taller-itla.ia3x.com/api/",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  // =========================
  // 📥 CATEGORÍAS
  // =========================
  Future<dynamic> obtenerCategorias(String token) async {
    final res = await dio.get(
      "gastos/categorias",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    return res.data;
  }

  // =========================
  // 💸 GASTOS
  // =========================
  Future<void> crearGasto({
    required String token,
    required int vehiculoId,
    required int categoriaId,
    required double monto,
  }) async {
    await dio.post(
      "gastos",
      data: {
        "datax": jsonEncode({
          "vehiculo_id": vehiculoId,
          "categoria_id": categoriaId,
          "monto": monto,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }

  Future<void> actualizarGasto({
    required String token,
    required int id,
    required int categoriaId,
    required double monto,
  }) async {
    await dio.post(
      "gastos/$id",
      data: {
        "_method": "PUT",
        "datax": jsonEncode({
          "categoria_id": categoriaId,
          "monto": monto,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }

  Future<Map<String, dynamic>> obtenerGastos(
      String token, int vehiculoId, int page) async {
    final res = await dio.get(
      "gastos",
      queryParameters: {
        "vehiculo_id": vehiculoId,
        "page": page,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  // =========================
  // 💰 INGRESOS
  // =========================
  Future<void> crearIngreso({
    required String token,
    required int vehiculoId,
    required double monto,
  }) async {
    await dio.post(
      "ingresos",
      data: {
        "datax": jsonEncode({
          "vehiculo_id": vehiculoId,
          "monto": monto,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }

  Future<void> actualizarIngreso({
    required String token,
    required int id,
    required double monto,
  }) async {
    await dio.post(
      "ingresos/$id",
      data: {
        "_method": "PUT",
        "datax": jsonEncode({
          "monto": monto,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }

  Future<Map<String, dynamic>> obtenerIngresos(
      String token, int vehiculoId, int page) async {
    final res = await dio.get(
      "ingresos",
      queryParameters: {
        "vehiculo_id": vehiculoId,
        "page": page,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  // =========================
  // ⛽ COMBUSTIBLE
  // =========================
  Future<Map<String, dynamic>> obtenerCombustibles(
      String token, int vehiculoId) async {
    final res = await dio.get(
      "combustibles",
      queryParameters: {
        "vehiculo_id": vehiculoId,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  Future<void> crearCombustible({
    required String token,
    required int vehiculoId,
    required double cantidad,
    required String unidad,
    required double monto,
  }) async {
    await dio.post(
      "combustibles",
      data: {
        "datax": jsonEncode({
          "vehiculo_id": vehiculoId,
          "tipo": "combustible",
          "cantidad": cantidad,
          "unidad": unidad,
          "monto": monto,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }

  // =========================
  // 🔧 MANTENIMIENTOS
  // =========================
  Future<Map<String, dynamic>> obtenerMantenimientos(
      String token, int vehiculoId) async {
    final res = await dio.get(
      "mantenimientos",
      queryParameters: {
        "vehiculo_id": vehiculoId,
      },
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );

    return res.data;
  }

  Future<void> crearMantenimiento({
    required String token,
    required int vehiculoId,
    required String tipo,
    required double costo,
    required String piezas,
  }) async {
    await dio.post(
      "mantenimientos",
      data: {
        "datax": jsonEncode({
          "vehiculo_id": vehiculoId,
          "tipo": tipo,
          "costo": costo,
          "piezas": piezas,
        }),
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }
}