
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vehiculos_app/providers/catalog_provider.dart';
import 'catalog_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<CatalogProvider>().loadCatalog();
  });
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CatalogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Vehículos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilters(provider),
          Expanded(child: _buildBody(provider)),
          _buildPagination(provider),
        ],
      ),
    );
  }

  Widget _buildFilters(CatalogProvider provider) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TextField(
                controller: provider.marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  prefixIcon: Icon(Icons.directions_car),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: provider.modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  prefixIcon: Icon(Icons.local_offer),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: provider.anioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Año',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: provider.precioMinController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Precio mín.',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: provider.precioMaxController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Precio máx.',
                        prefixIcon: Icon(Icons.attach_money),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => provider.loadCatalog(),
                      icon: const Icon(Icons.search),
                      label: const Text('Buscar'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: provider.clearFilters,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Limpiar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CatalogProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (provider.hasNoResults) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No encontramos vehículos con esos filtros.\nPrueba con otros valores.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: provider.catalogItems.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = provider.catalogItems[index];

        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CatalogDetailScreen(id: item.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: item.imagenUrl.isNotEmpty
                        ? Image.network(
                            item.imagenUrl,
                            width: 120,
                            height: 95,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Container(
                                width: 120,
                                height: 95,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              );
                            },
                          )
                        : Container(
                            width: 120,
                            height: 95,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.directions_car),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.marca} ${item.modelo}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Año: ${item.anio}'),
                        const SizedBox(height: 6),
                        Text(
                          '\$${item.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.descripcionCorta,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination(CatalogProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed:
                provider.currentPage > 1 ? provider.previousPage : null,
            child: const Text('Anterior'),
          ),
          Text(
            'Página ${provider.currentPage} de ${provider.totalPages}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          OutlinedButton(
            onPressed: provider.currentPage < provider.totalPages
                ? provider.nextPage
                : null,
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}