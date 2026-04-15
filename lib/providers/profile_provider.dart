import 'package:flutter/material.dart';
import '../data/models/profile/profile_model.dart';
import '../data/services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  ProfileModel? profile;
  bool isLoading = false;
  String? error;

  Future<void> loadProfile() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      profile = await _service.getProfile();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePhoto(String path) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.uploadPhoto(path);

      if (profile != null) {
        profile = ProfileModel(
          id: profile!.id,
          matricula: profile!.matricula,
          nombre: profile!.nombre,
          apellido: profile!.apellido,
          correo: profile!.correo,
          rol: profile!.rol,
          grupo: profile!.grupo,
          fotoUrl: response.fotoUrl,
          fechaRegistro: profile!.fechaRegistro,
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}