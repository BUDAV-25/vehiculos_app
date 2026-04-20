import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../data/services/foro_service.dart';
import '../../../providers/auth_provider.dart';

class CrearPostScreen extends StatefulWidget {
  const CrearPostScreen({super.key});

  @override
  State<CrearPostScreen> createState() => _CrearPostScreenState();
}

class _CrearPostScreenState extends State<CrearPostScreen> {
  final service = ForoService();
  final tituloCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  List<dynamic> vehiculos = [];
  int? vehiculoId;
  bool cargandoVehiculos = true;
  bool guardando = false;

  @override
  void initState() {
    super.initState();
    // Usamos microtask para asegurarnos de que el contexto esté listo
    Future.microtask(() => cargarDatos());
  }

  Future<void> cargarDatos() async {
    try {
      final token = context.read<AuthProvider>().token ?? "";
      final listado = await service.obtenerVehiculos(token);
      
      if (mounted) {
        setState(() {
          // Guardamos la lista completa. Si viene vacía, el dropdown mostrará el hint.
          vehiculos = listado;
          cargandoVehiculos = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => cargandoVehiculos = false);
      print("❌ Error cargando vehículos: $e");
    }
  }

  Future<void> publicar() async {
    final titulo = tituloCtrl.text.trim();
    final descripcion = descCtrl.text.trim();

    if (vehiculoId == null || titulo.isEmpty || descripcion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes seleccionar un vehículo y llenar todos los campos")),
      );
      return;
    }

    setState(() => guardando = true);
    
    try {
      final token = context.read<AuthProvider>().token ?? "";
      
      await service.crearTema(
        token: token,
        vehiculoId: vehiculoId!,
        titulo: titulo,
        descripcion: descripcion,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("¡Tema publicado con éxito!"), backgroundColor: Colors.green),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll("Exception: ", "")), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      if (mounted) setState(() => guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Tema")),
      body: cargandoVehiculos 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Selecciona el vehículo relacionado:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<int>(
                  value: vehiculoId,
                  hint: const Text("Toca para elegir un vehículo"),
                  isExpanded: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  // Mapeamos los vehículos asegurando que el ID sea int
                  items: vehiculos.map((v) {
                    final id = int.tryParse(v["id"].toString()) ?? 0;
                    final nombre = v["marca"]?.toString() ?? v["modelo"]?.toString() ?? "Vehículo";
                    final placa = v["placa"]?.toString() ?? "";
                    
                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text("$nombre - $placa"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => vehiculoId = val),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: tituloCtrl,
                  decoration: const InputDecoration(
                    labelText: "Título del tema",
                    hintText: "Ej: Problema con los frenos",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: descCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Descripción",
                    hintText: "Explica detalladamente tu duda o reporte...",
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: guardando ? null : publicar,
                    child: guardando 
                      ? const SizedBox(
                          height: 20, 
                          width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        ) 
                      : const Text("PUBLICAR EN FORO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
    );
  }
}