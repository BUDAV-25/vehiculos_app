import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../../core/utils/dio_client.dart';

class AuthService {
  final Dio _dio = DioClient.instance.client;

  // REGISTRO
  Future<Map<String, dynamic>> register(String matricula) async {
    final res = await _dio.post(
      ApiConstants.registro,
      data: {
        'datax': jsonEncode({'matricula': matricula}),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }

    return res.data['data'];
  }

  // ACTIVAR
  Future<Map<String, dynamic>> activate({
    required String token,
    required String password,
  }) async {
    final res = await _dio.post(
      ApiConstants.activar,
      data: {
        'datax': jsonEncode({
          'token': token,
          'contrasena': password,
        }),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }

    return res.data['data'];
  }

  // LOGIN
  Future<Map<String, dynamic>> login({
    required String matricula,
    required String password,
  }) async {
    final res = await _dio.post(
      ApiConstants.login,
      data: {
        'datax': jsonEncode({
          'matricula': matricula,
          'contrasena': password,
        }),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }

    return res.data['data'];
  }

  // OLVIDAR
  Future<Map<String, dynamic>> forgot(String matricula) async {
    final res = await _dio.post(
      ApiConstants.olvidar,
      data: {
        'datax': jsonEncode({'matricula': matricula}),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }

    return res.data; // 🔥 IMPORTANTE
  }

  // REFRESH TOKEN
  Future<Map<String, dynamic>> refresh(String refreshToken) async {
    final res = await _dio.post(
      ApiConstants.refresh,
      data: {
        'datax': jsonEncode({'refreshToken': refreshToken}),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }

    return res.data['data'];
  }

  // CAMBIAR CLAVE 🔥
  Future<void> changePassword({
    required String actual,
    required String nueva,
  }) async {
    final res = await _dio.post(
      ApiConstants.cambiarClave,
      data: {
        'datax': jsonEncode({
          'actual': actual,
          'nueva': nueva,
        }),
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );

    if (!res.data['success']) {
      throw Exception(res.data['message']);
    }
  }
}