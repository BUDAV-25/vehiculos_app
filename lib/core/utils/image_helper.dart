import 'package:flutter/material.dart';
import '../constants/api_constants.dart';

class ImageHelper {
  /// Construye la URL completa de una imagen usando el proxy /imagen
  static String getImageUrl(String? path) {
    if (path == null || path.trim().isEmpty) return '';

    path = path.trim();

    if (path.startsWith('http')) {
      return path;
    }

    // Evita doble "api/imagen"
    if (path.contains('api/imagen')) {
      return path;
    }

    return "${ApiConstants.baseUrl}${ApiConstants.imagen}?path=$path";
  }

  /// Valida si una imagen es válida
  static bool isValid(String? path) {
    return path != null && path.trim().isNotEmpty;
  }

  /// Retorna URL o null (útil para widgets opcionales)
  static String? getImageOrNull(String? path) {
    if (!isValid(path)) return null;
    return getImageUrl(path);
  }

  /// Construye múltiples URLs
  static List<String> buildImageList(List<dynamic>? paths) {
    if (paths == null || paths.isEmpty) return [];

    return paths
        .where((p) => p != null && p.toString().isNotEmpty)
        .map((p) => getImageUrl(p.toString()))
        .toList();
  }

  // =========================
  // 🔥 NUEVO (IMPORTANTE)
  // =========================
  static ImageProvider? getImageProvider(String? path) {
    if (!isValid(path)) return null;

    return NetworkImage(getImageUrl(path));
  }
}