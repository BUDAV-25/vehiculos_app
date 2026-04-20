import 'package:flutter/material.dart';
import '../../../data/services/foro_service.dart';

class ForoForm extends StatefulWidget {
  final String token;

  const ForoForm({super.key, required this.token});

  @override
  State<ForoForm> createState() => _ForoFormState();
}

class _ForoFormState extends State<ForoForm> {
  final service = ForoService();

  String titulo = "";
  String descripcion = "";

  int? vehiculoId;
  bool loading = false;

  final vehiculos = [
    {"id": 1, "nombre": "Vehículo 1"},
    {"id": 2, "nombre": "Vehículo 2"},
  ];

  Future<void> guardar() async {
    if (vehiculoId == null ||
        titulo.isEmpty ||
        descripcion.isEmpty) return;

    setState(() => loading = true);

    try {
      await service.crearTema(
        token: widget.token,
        vehiculoId: vehiculoId!,
        titulo: titulo,
        descripcion: descripcion,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("❌ ERROR CREAR: $e");
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Tema")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<int>(
              value: vehiculoId,
              hint: const Text("Selecciona vehículo"),
              isExpanded: true,
              items: vehiculos.map((v) {
                return DropdownMenuItem(
                  value: v["id"] as int,
                  child: Text(v["nombre"].toString()),
                );
              }).toList(),
              onChanged: (v) => setState(() => vehiculoId = v),
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Título"),
              onChanged: (v) => titulo = v,
            ),

            TextField(
              decoration: const InputDecoration(labelText: "Descripción"),
              onChanged: (v) => descripcion = v,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : guardar,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Crear"),
            )
          ],
        ),
      ),
    );
  }
}