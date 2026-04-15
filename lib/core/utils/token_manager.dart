// lib/core/utils/token_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Guardar tokens
  static Future<void> saveTokens({
    required String token,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_tokenKey, token);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }

  /// Obtener token principal
  static Future<Map<String, String?>> getTokens() async {
  final prefs = await SharedPreferences.getInstance();

  return {
    'token': prefs.getString(_tokenKey),
    'refreshToken': prefs.getString(_refreshTokenKey),
  };
}

  /// Obtener refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Verificar si hay sesión activa
  static Future<bool> hasToken() async {
    final token = await getTokens();
    return token['token'] != null && token['token']!.isNotEmpty;
  }

  /// Borrar tokens (logout)
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}