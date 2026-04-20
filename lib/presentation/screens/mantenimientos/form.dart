import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/mantenimiento_service.dart';

class MantenimientoForm extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const MantenimientoForm({
    super.key,
    required this.vehiculoId,
    required this.token,
  });

  @override
  State<MantenimientoForm> createState() => _MantenimientoFormState();
}

class _MantenimientoFormState extends State<MantenimientoForm> {
  final _formKey = GlobalKey<FormState>();
  final service = MantenimientoService();

  String tipo = "Cambio de aceite";
  double costo = 0;
  String piezas = "";
  String fecha = "";
  List<XFile> fotos = [];

  bool loading = false;

  final picker = ImagePicker();

  // 📸 TOMAR FOTO
  Future<void> tomarFoto() async {
    if (fotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Máximo 5 fotos")),
      );
      return;
    }

    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        fotos.add(image);
      });
    }
  }

  // 📅 SELECCIONAR FECHA
  Future<void> seleccionarFecha() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        fecha = picked.toString().split(" ")[0];
      });
    }
  }

  // 💾 GUARDAR EN API
  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (fecha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione una fecha")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      await service.crearMantenimiento(
        token: widget.token,
        vehiculoId: widget.vehiculoId,
        tipo: tipo,
        costo: costo,
        piezas: piezas,
        fecha: fecha,
        fotos: fotos,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Mantenimiento guardado")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Mantenimiento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 🔽 TIPO
                DropdownButtonFormField<String>(
                  value: tipo,
                  decoration: const InputDecoration(
                    labelText: "Tipo de mantenimiento",
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    "Cambio de aceite",
                    "Frenos",
                    "Motor",
                    "Alineación",
                    "Otros"
                  ]
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => tipo = value!);
                  },
                ),

                const SizedBox(height: 15),

                // 💰 COSTO
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Costo",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? "Ingrese costo" : null,
                  onChanged: (value) =>
                      costo = double.tryParse(value) ?? 0,
                ),

                const SizedBox(height: 15),

                // 🔧 PIEZAS
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Piezas (opcional)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => piezas = value,
                ),

                const SizedBox(height: 15),

                // 📅 FECHA
                ElevatedButton(
                  onPressed: seleccionarFecha,
                  child: Text(
                    fecha.isEmpty ? "Seleccionar fecha" : fecha,
                  ),
                ),

                const SizedBox(height: 15),

                // 📸 FOTO
                ElevatedButton(
                  onPressed: tomarFoto,
                  child: const Text("Agregar Foto"),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  children: fotos
                      .map((f) => Stack(
                            children: [
                              Image.file(
                                File(f.path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      fotos.remove(f);
                                    });
                                  },
                                  child: const Icon(Icons.close,
                                      color: Colors.red),
                                ),
                              )
                            ],
                          ))
                      .toList(),
                ),

                const SizedBox(height: 20),

                // 💾 BOTÓN GUARDAR
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : guardar,
                    child: loading
                        ? const CircularProgressIndicator()
                        : const Text("Guardar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}