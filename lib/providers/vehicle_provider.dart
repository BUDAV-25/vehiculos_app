import 'package:flutter/material.dart';

import '../data/models/vehicle/vehicle_model.dart';
import '../data/models/vehicle/vehicle_detail_model.dart';
import '../data/services/vehiculo_service.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleService _service = VehicleService();

  // ===============================
  // 🔹 ESTADO
  // ===============================
  List<VehicleModel> vehicles = [];
  VehicleDetailModel? selectedVehicle;

  bool isLoading = false;
  bool isLoadingMore = false;

  String? error;

  int page = 1;
  int limit = 20;
  int total = 0;

  bool hasMore = true;

  String? marcaFilter;
  String? modeloFilter;

  // ===============================
  // 🔹 GET VEHICULOS (RESET)
  // ===============================
  Future<void> loadVehicles({bool refresh = false}) async {
    try {
      if (refresh) {
        page = 1;
        vehicles.clear();
        hasMore = true;
      }

      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _service.getVehicles(
        page: page,
        limit: limit,
        marca: marcaFilter,
        modelo: modeloFilter,
      );

      vehicles = response.vehicles;
      total = response.total;

      hasMore = vehicles.length < total;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 PAGINACION
  // ===============================
  Future<void> loadMoreVehicles() async {
    if (!hasMore || isLoadingMore) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      page++;

      final response = await _service.getVehicles(
        page: page,
        limit: limit,
        marca: marcaFilter,
        modelo: modeloFilter,
      );

      vehicles.addAll(response.vehicles);

      hasMore = vehicles.length < response.total;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 DETALLE
  // ===============================
  Future<void> loadVehicleDetail(int id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      selectedVehicle = await _service.getVehicleDetail(id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 CREAR
  // ===============================
  Future<bool> createVehicle({
    required Map<String, dynamic> data,
    String? imagePath,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.createVehicle(
        data: data,
        imagePath: imagePath,
      );

      await loadVehicles(refresh: true);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 EDITAR
  // ===============================
  Future<bool> updateVehicle(Map<String, dynamic> data) async {
    try {
      isLoading = true;
      notifyListeners();

      await _service.updateVehicle(data);

      await loadVehicles(refresh: true);

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 SUBIR FOTO
  // ===============================
  Future<void> uploadPhoto(int id, String path) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _service.uploadPhoto(
        id: id,
        imagePath: path,
      );

      // actualizar en lista
      final index = vehicles.indexWhere((v) => v.id == id);
      if (index != -1) {
        final v = vehicles[index];

        vehicles[index] = VehicleModel(
          id: v.id,
          usuarioId: v.usuarioId,
          placa: v.placa,
          chasis: v.chasis,
          marca: v.marca,
          modelo: v.modelo,
          anio: v.anio,
          cantidadRuedas: v.cantidadRuedas,
          fotoUrl: response.fotoUrl,
          fechaRegistro: v.fechaRegistro,
        );
      }

      // actualizar detalle si está abierto
      if (selectedVehicle != null && selectedVehicle!.id == id) {
        selectedVehicle = VehicleDetailModel(
          id: selectedVehicle!.id,
          placa: selectedVehicle!.placa,
          chasis: selectedVehicle!.chasis,
          marca: selectedVehicle!.marca,
          modelo: selectedVehicle!.modelo,
          anio: selectedVehicle!.anio,
          cantidadRuedas: selectedVehicle!.cantidadRuedas,
          fotoUrl: response.fotoUrl,
          fechaRegistro: selectedVehicle!.fechaRegistro,
          resumen: selectedVehicle!.resumen,
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  // ===============================
  // 🔹 ACTUALIZAR FOTO DE UN VEHÍCULO EN EDICIÓN
  // ===============================
  Future<bool> uploadVehiclePhoto({
  required int id,
  required String imagePath,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _service.uploadPhoto(
        id: id,
        imagePath: imagePath,
      );

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ===============================
  // 🔹 FILTROS
  // ===============================
  void setFilters({String? marca, String? modelo}) {
    marcaFilter = marca;
    modeloFilter = modelo;
    loadVehicles(refresh: true);
  }

  void clearFilters() {
    marcaFilter = null;
    modeloFilter = null;
    loadVehicles(refresh: true);
  }
}