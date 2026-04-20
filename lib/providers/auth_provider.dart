import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/utils/token_manager.dart';
import '../data/services/auth_service.dart';

import '../data/services/profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  final ProfileService _profileService = ProfileService();

  // =========================
  // ESTADO
  // =========================
  bool isAuthenticated = false;
  bool isLoading = false;

  String? nombre;
  String? apellido;
  String? correo;
  String? fotoUrl;

  String? token;
  String? refreshToken;

  Future<void> initAuth() async {
    try {
      isLoading = true;
      notifyListeners();

      final tokens = await TokenManager.getTokens();

      if (tokens == null) {
        isAuthenticated = false;
        return;
      }

      token = tokens['token'];
      refreshToken = tokens['refreshToken'];

      // 🔥 AQUÍ ESTÁ LA CLAVE
      final user = await _profileService.getProfile();

      nombre = user.nombre;
      apellido = user.apellido;
      correo = user.correo;
      fotoUrl = user.fotoUrl;

      isAuthenticated = true;

    } catch (e) {
      await logout();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  // =========================
  // LOGIN INTERNO
  // =========================
  Future<void> login({
    required String nombre,
    required String apellido,
    required String correo,
    required String fotoUrl,
    required String token,
    required String refreshToken,
  }) async {
    this.nombre = nombre;
    this.apellido = apellido;
    this.correo = correo;
    this.fotoUrl = fotoUrl;
    this.token = token;
    this.refreshToken = refreshToken;

    isAuthenticated = true;

    // Guardar tokens
    await TokenManager.saveTokens(
      token: token,
      refreshToken: refreshToken,
    );

    notifyListeners();
  }

  // =========================
  // LOGIN DESDE API
  // =========================
  Future<String?> loginUser({
    required String matricula,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.login(
        matricula: matricula,
        password: password,
      );

      await login(
        nombre: data['nombre'] ?? '',
        apellido: data['apellido'] ?? '',
        correo: data['correo'] ?? '',
        fotoUrl: data['fotoUrl'] ?? '',
        token: data['token'],
        refreshToken: data['refreshToken'],
      );

      return null; // éxito
    } catch (e) {
      return e.toString(); // error para UI
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // REGISTRO
  // =========================
  Future<String> register(String matricula) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.register(matricula);

      // Retornamos el token temporal
      return data['token'];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // ACTIVAR CUENTA
  // =========================
  Future<void> activarCuenta({
    required String token,
    required String password,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.activate(
        token: token,
        password: password,
      );

      await login(
        nombre: data['nombre'] ?? '',
        apellido: data['apellido'] ?? '',
        correo: data['correo'] ?? '',
        fotoUrl: data['fotoUrl'] ?? '',
        token: data['token'],
        refreshToken: data['refreshToken'],
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // REFRESH TOKEN
  // =========================
  Future<void> refreshSession() async {
  if (refreshToken == null) {
    await logout();
    return;
  }

  try {
    final data = await _service.refresh(refreshToken!);

    token = data['token'];
    refreshToken = data['refreshToken'];

    await TokenManager.saveTokens(
      token: token!,
      refreshToken: refreshToken!,
    );

    notifyListeners();
  } catch (_) {
    await logout();
  }
}

  Future<String?> updatePhoto(String filePath) async {
    try {
      isLoading = true;
      notifyListeners();

      // 1. Subir foto
      final response = await _profileService.uploadPhoto(filePath);

      // 2. Actualizar solo la foto en memoria
      fotoUrl = response.fotoUrl;

      notifyListeners();
      return null;

    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // CAMBIAR CONTRASEÑA
  // =========================
  Future<void> changePassword({
    required String actual,
    required String nueva,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.changePassword(
        actual: actual,
        nueva: nueva,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // OLVIDAR CONTRASEÑA
  // =========================
  Future<void> forgotPassword(String matricula) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.forgot(matricula);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================
  // LOGOUT
  // =========================
  Future<void> logout() async {
    nombre = null;
    apellido = null;
    correo = null;
    fotoUrl = null;
    token = null;
    refreshToken = null;

    isAuthenticated = false;

    await TokenManager.clearTokens();

    isAuthenticated = false;
    
    notifyListeners();
  }
}