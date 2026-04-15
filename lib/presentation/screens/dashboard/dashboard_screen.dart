import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
          )
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          // Aquí luego cargarás vehículos o stats reales
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // HEADER
              _DashboardHeader(
                nombre: auth.nombre ?? '',
                apellido: auth.apellido ?? '',
                correo: auth.correo ?? '',
              ),

              const SizedBox(height: 20),

              // STATS
              const _StatsSection(),

              const SizedBox(height: 20),

              // QUICK ACTIONS
              const _QuickActions(),

              const SizedBox(height: 20),

              // VEHICLES PREVIEW
              const _VehiclesPreview(),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String correo;

  const _DashboardHeader({
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const CircleAvatar(
          radius: 28,
          child: Icon(Icons.person),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$nombre $apellido',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                correo,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            context.go('/perfil');
          },
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
        )
      ],
    );
  }
}

class _StatsSection extends StatelessWidget {
  const _StatsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Resumen',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        Row(
          children: const [
            Expanded(child: _StatCard(title: 'Vehículos', value: '0')),
            SizedBox(width: 10),
            Expanded(child: _StatCard(title: 'Activos', value: '0')),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: const [
            Expanded(child: _StatCard(title: 'Mantenimiento', value: '0')),
            SizedBox(width: 10),
            Expanded(child: _StatCard(title: 'Alertas', value: '0')),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.blue.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(title),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          'Acciones rápidas',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            _ActionButton(
              icon: Icons.add,
              label: 'Agregar',
              onTap: () => context.go('/vehiculo/create'),
            ),

            _ActionButton(
              icon: Icons.directions_car,
              label: 'Vehículos',
              onTap: () => context.go('/vehiculos'),
            ),

            _ActionButton(
              icon: Icons.settings,
              label: 'Perfil',
              onTap: () => context.go('/perfil'),
            ),
          ],
        )
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 6),
        Text(label),
      ],
    );
  }
}

class _VehiclesPreview extends StatelessWidget {
  const _VehiclesPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tus vehículos',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () => context.go('/vehiculos'),
              child: const Text('Ver todos'),
            )
          ],
        ),

        const SizedBox(height: 10),

        Container(
          height: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade100,
          ),
          child: const Text('No hay vehículos aún'),
        )
      ],
    );
  }
}