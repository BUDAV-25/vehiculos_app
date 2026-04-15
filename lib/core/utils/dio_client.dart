// lib/data/services/dio_client.dart
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import 'token_manager.dart';

class DioClient {
  DioClient._internal();

  static final DioClient instance = DioClient._internal();

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      responseType: ResponseType.json,
      followRedirects: false,
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  Future<String?>? _refreshingTokenFuture;

  Dio get client {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getTokens();

          if (token['token'] != null && token['token']!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${token["token"]}';
          }

          handler.next(options);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final isUnauthorized = statusCode == 401 || statusCode == 403;
          final alreadyRetried = error.requestOptions.extra['retried'] == true;

          if (!isUnauthorized || alreadyRetried) {
            handler.next(error);
            return;
          }

          final newToken = await _refreshAccessToken();

          if (newToken == null || newToken.isEmpty) {
            await TokenManager.clearTokens();
            handler.next(error);
            return;
          }

          try {
            final requestOptions = error.requestOptions;
            requestOptions.extra['retried'] = true;
            requestOptions.headers['Authorization'] = 'Bearer $newToken';

            final response = await dio.fetch(requestOptions);
            handler.resolve(response);
          } catch (_) {
            handler.next(error);
          }
        },
      ),
    );

    return dio;
  }

  Future<String?> _refreshAccessToken() {
    _refreshingTokenFuture ??= _doRefreshToken().whenComplete(() {
      _refreshingTokenFuture = null;
    });

    return _refreshingTokenFuture!;
  }

  Future<String?> _doRefreshToken() async {
    final refreshToken = await TokenManager.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
      );

      // La API maneja POST con el JSON dentro de datax como form-encoded.
      final response = await refreshDio.post(
        ApiConstants.refresh,
        data: {
          'datax': jsonEncode({
            'refreshToken': refreshToken,
          }),
        },
      );

      final data = _normalizeResponse(response.data);

      final newToken = data['token']?.toString();
      final newRefreshToken = data['refreshToken']?.toString() ?? refreshToken;

      if (newToken == null || newToken.isEmpty) {
        return null;
      }

      await TokenManager.saveTokens(
        token: newToken,
        refreshToken: newRefreshToken,
      );

      return newToken;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> _normalizeResponse(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    if (responseData is Map) {
      return responseData.map((key, value) => MapEntry(key.toString(), value));
    }

    if (responseData is String && responseData.isNotEmpty) {
      final decoded = jsonDecode(responseData);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map((key, value) => MapEntry(key.toString(), value));
      }
    }

    return <String, dynamic>{};
  }
}