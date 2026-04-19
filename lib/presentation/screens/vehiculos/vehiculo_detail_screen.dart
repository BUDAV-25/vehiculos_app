import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/vehicle_provider.dart';
import '../../../core/utils/image_helper.dart';

class VehiculoDetailScreen extends StatefulWidget {
  final int id;

  const VehiculoDetailScreen({super.key, required this.id});

  @override
  State<VehiculoDetailScreen> createState() =>
      _VehiculoDetailScreenState();
}

class _VehiculoDetailScreenState extends State<VehiculoDetailScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().loadVehicleDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();
    final vehicle = provider.selectedVehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Vehículo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final provider = context.read<VehicleProvider>();

              final result = await context.push(
                '/vehiculo/editar',
                extra: provider.selectedVehicle,
              );

              // 🔥 SI EDITÓ → RECARGA
              if (result == true) {
                provider.loadVehicleDetail(widget.id);
              }
            },
          ),
        ],
      ),
      body: _buildBody(provider, vehicle),
    );
  }

  Widget _buildBody(
    VehicleProvider provider,
    dynamic vehicle,
  ) {
    if (provider.isLoading || vehicle == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return _ErrorView(error: provider.error!);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 IMAGEN
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.grey.shade200,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _buildImage(vehicle.fotoUrl),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 INFO GENERAL
          Text(
            '${vehicle.marca} ${vehicle.modelo}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 10),

          _infoRow('Placa', vehicle.placa),
          _infoRow('Chasis', vehicle.chasis),
          _infoRow('Año', vehicle.anio.toString()),
          _infoRow('Ruedas', vehicle.cantidadRuedas.toString()),

          const SizedBox(height: 20),

          Text(
            'Resumen financiero',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 10),

          _summaryCard('Mantenimientos', vehicle.resumen.totalMantenimientos),
          _summaryCard('Combustible', vehicle.resumen.totalCombustible),
          _summaryCard('Gastos', vehicle.resumen.totalGastos),
          _summaryCard('Ingresos', vehicle.resumen.totalIngresos),
          _summaryCard('Invertido', vehicle.resumen.totalInvertido),
          _summaryCard('Balance', vehicle.resumen.balance, isBalance: true),
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    final provider = ImageHelper.getImageProvider(url);

    if (provider != null) {
      return Image(
        image: provider,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.directions_car, size: 50, color: Colors.grey);
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, num value, {bool isBalance = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isBalance
            ? (value >= 0 ? Colors.green.shade50 : Colors.red.shade50)
            : Colors.blue.shade50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isBalance
                  ? (value >= 0 ? Colors.green : Colors.red)
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
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