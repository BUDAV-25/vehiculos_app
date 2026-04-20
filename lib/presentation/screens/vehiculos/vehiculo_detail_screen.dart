import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/vehicle_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/utils/image_helper.dart';

// ✅ IMPORTS
import 'package:vehiculos_app/presentation/screens/gastos_ingresos/gastos_list.dart';
import 'package:vehiculos_app/presentation/screens/gastos_ingresos/ingreso_form.dart';

// OPCIONALES (si existen en tu proyecto)
import 'package:vehiculos_app/presentation/screens/combustible/form.dart';
import 'package:vehiculos_app/presentation/screens/mantenimientos/form.dart';

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
    final token = context.read<AuthProvider>().token ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Vehículo'),
      ),
      body: _buildBody(provider, vehicle, token),
    );
  }

  Widget _buildBody(
    VehicleProvider provider,
    dynamic vehicle,
    String token,
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

          // 🚗 IMAGEN
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

          Text(
            '${vehicle.marca} ${vehicle.modelo}',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 10),

          _infoRow('Placa', vehicle.placa ?? ''),
          _infoRow('Chasis', vehicle.chasis ?? ''),
          _infoRow('Año', vehicle.anio.toString()),
          _infoRow('Ruedas', vehicle.cantidadRuedas.toString()),

          const SizedBox(height: 20),

          Text(
            'Resumen financiero',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 10),

          // 🔧 MANTENIMIENTOS
          _actionCard(
            'Mantenimientos',
            vehicle.resumen?.totalMantenimientos ?? 0,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MantenimientoForm(
                    vehiculoId: vehicle.id,
                    token: token,
                  ),
                ),
              );
            },
          ),

          // ⛽ COMBUSTIBLE
          _actionCard(
            'Combustible',
            vehicle.resumen?.totalCombustible ?? 0,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CombustibleForm(
                    vehiculoId: vehicle.id,
                    token: token,
                  ),
                ),
              );
            },
          ),

          // 💸 GASTOS
          _actionCard(
            'Gastos',
            vehicle.resumen?.totalGastos ?? 0,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GastosList(
                    vehiculoId: vehicle.id,
                    token: token,
                  ),
                ),
              );
            },
          ),

          // 💰 INGRESOS
          _actionCard(
            'Ingresos',
            vehicle.resumen?.totalIngresos ?? 0,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => IngresoForm(
                    vehiculoId: vehicle.id,
                    token: token,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          _summaryCard(
            'Invertido',
            vehicle.resumen?.totalInvertido ?? 0,
          ),

          _summaryCard(
            'Balance',
            vehicle.resumen?.balance ?? 0,
            isBalance: true,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String? url) {
    final provider = ImageHelper.getImageProvider(url);

    if (provider != null) {
      return Image(image: provider, fit: BoxFit.cover);
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

  Widget _actionCard(
    String title,
    num value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.blue.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Row(
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
    String title,
    num value, {
    bool isBalance = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isBalance
            ? (value >= 0
                ? Colors.green.shade50
                : Colors.red.shade50)
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
      ),
    );
  }
}