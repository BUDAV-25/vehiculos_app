import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/providers/auth_provider.dart';
import '/core/utils/image_helper.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // FOTO + INFO
              _ProfileHeader(
                nombre: auth.nombre ?? '',
                apellido: auth.apellido ?? '',
                correo: auth.correo ?? '',
                fotoUrl: auth.fotoUrl,
              ),

              const SizedBox(height: 30),

              // OPCIONES
              const _ProfileOptions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nombre;
  final String apellido;
  final String correo;
  final String? fotoUrl;

  const _ProfileHeader({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.fotoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // FOTO
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: ImageHelper.getImageProvider(fotoUrl),
              child: fotoUrl == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  context.go('/perfil/editar');
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),

        const SizedBox(height: 15),

        Text(
          '$nombre $apellido',
          style: Theme.of(context).textTheme.titleLarge,
        ),

        const SizedBox(height: 5),

        Text(
          correo,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _ProfileOptions extends StatelessWidget {
  const _ProfileOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        _OptionTile(
          icon: Icons.edit,
          title: 'Editar perfil',
          onTap: () => context.go('/perfil/editar'),
        ),

        _OptionTile(
          icon: Icons.lock,
          title: 'Cambiar contraseña',
          onTap: () => context.go('/change-password'),
        ),

        _OptionTile(
          icon: Icons.directions_car,
          title: 'Mis vehículos',
          onTap: () => context.go('/vehiculos'),
        ),

        const Divider(height: 30),

        _OptionTile(
          icon: Icons.logout,
          title: 'Cerrar sesión',
          color: Colors.red,
          onTap: () async {
            await context.read<AuthProvider>().logout();
            if (context.mounted) {
              context.go('/login');
            }
          },
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Colors.black;

    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(
        title,
        style: TextStyle(color: textColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}

