import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/vehicle_provider.dart';
import '../../../data/models/vehicle/vehicle_model.dart';
import '../../../core/utils/image_helper.dart';

class MisVehiculosScreen extends StatefulWidget {
  const MisVehiculosScreen({super.key});

  @override
  State<MisVehiculosScreen> createState() => _MisVehiculosScreenState();
}

class _MisVehiculosScreenState extends State<MisVehiculosScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().loadVehicles();
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<VehicleProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMoreVehicles();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<VehicleProvider>().loadVehicles(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Vehículos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/vehiculo/create'); // asegúrate que exista
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(VehicleProvider provider) {
    if (provider.isLoading && provider.vehicles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return _ErrorView(error: provider.error!);
    }

    if (provider.vehicles.isEmpty) {
      return const _EmptyView();
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount:
          provider.vehicles.length + (provider.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < provider.vehicles.length) {
          final VehicleModel vehicle = provider.vehicles[index];
          return _VehicleCard(vehicle: vehicle);
        } else {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await context.push('/vehiculo/detalle/${vehicle.id}');

        if (result == true) {
          if (context.mounted) {
            context.read<VehicleProvider>().loadVehicles(refresh: true);
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildImage(),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${vehicle.marca} ${vehicle.modelo}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Placa: ${vehicle.placa}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Año: ${vehicle.anio}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final provider = ImageHelper.getImageProvider(vehicle.fotoUrl);

    if (provider != null) {
      return Image(
        image: provider,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.directions_car, color: Colors.grey);
  }
}

class _ErrorView extends StatelessWidget {
  final String error;

  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        error,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No tienes vehículos aún',
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}