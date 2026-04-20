import 'package:flutter/material.dart';
import '../data/models/catalog/catalog_detail_model.dart';
import '../data/models/catalog/catalog_item_model.dart';
import '../data/models/catalog/catalog_list_response.dart';
import '../data/services/catalogo_service.dart';

class CatalogProvider extends ChangeNotifier {
  final CatalogService service;

  CatalogProvider(this.service);

  final marcaController = TextEditingController();
  final modeloController = TextEditingController();
  final anioController = TextEditingController();
  final precioMinController = TextEditingController();
  final precioMaxController = TextEditingController();

  List<CatalogItemModel> catalogItems = [];
  CatalogDetailModel? catalogDetail;

  bool isLoading = false;
  bool isLoadingDetail = false;
  String? errorMessage;

  int currentPage = 1;
  int limit = 20;
  int total = 0;

  bool get hasNoResults =>
      !isLoading && errorMessage == null && catalogItems.isEmpty;

  int get totalPages {
    if (limit == 0) return 1;
    final pages = (total / limit).ceil();
    return pages == 0 ? 1 : pages;
  }

  Future<void> loadCatalog({bool resetPage = true}) async {
    try {
      isLoading = true;
      errorMessage = null;

      if (resetPage) currentPage = 1;

      notifyListeners();

      final response = await service.getCatalog(
        marca: marcaController.text,
        modelo: modeloController.text,
        anio: anioController.text.trim().isEmpty
            ? null
            : int.tryParse(anioController.text.trim()),
        precioMin: precioMinController.text.trim().isEmpty
            ? null
            : double.tryParse(precioMinController.text.trim()),
        precioMax: precioMaxController.text.trim().isEmpty
            ? null
            : double.tryParse(precioMaxController.text.trim()),
        page: currentPage,
        limit: limit,
      );

      catalogItems = response.items;
      currentPage = response.page;
      limit = response.limit;
      total = response.total;
    } catch (e) {
      errorMessage = 'No se pudo cargar el catálogo.';
      catalogItems = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadDetail(int id) async {
    try {
      isLoadingDetail = true;
      errorMessage = null;
      catalogDetail = null;
      notifyListeners();

      catalogDetail = await service.getCatalogDetail(id);
    } catch (e) {
      errorMessage = 'No se pudo cargar el detalle del vehículo.';
    } finally {
      isLoadingDetail = false;
      notifyListeners();
    }
  }

  Future<void> nextPage() async {
    if (currentPage < totalPages) {
      currentPage++;
      await loadCatalog(resetPage: false);
    }
  }

  Future<void> previousPage() async {
    if (currentPage > 1) {
      currentPage--;
      await loadCatalog(resetPage: false);
    }
  }

  void clearFilters() {
    marcaController.clear();
    modeloController.clear();
    anioController.clear();
    precioMinController.clear();
    precioMaxController.clear();
    loadCatalog();
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    anioController.dispose();
    precioMinController.dispose();
    precioMaxController.dispose();
    super.dispose();
  }
}