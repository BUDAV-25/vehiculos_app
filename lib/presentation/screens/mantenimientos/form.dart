import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

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
  final service = GastosService();
  final _formKey = GlobalKey<FormState>();

  String tipo = "";
  double costo = 0;
  String piezas = "";

  bool saving = false;

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      await service.crearMantenimiento(
        token: widget.token,
        vehiculoId: widget.vehiculoId,
        tipo: tipo,
        costo: costo,
        piezas: piezas,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Mantenimiento registrado")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mantenimiento")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                decoration: const InputDecoration(labelText: "Tipo"),
                onChanged: (v) => tipo = v,
                validator: (v) => v!.isEmpty ? "Ingrese tipo" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: "Costo"),
                keyboardType: TextInputType.number,
                onChanged: (v) => costo = double.tryParse(v) ?? 0,
                validator: (v) => v!.isEmpty ? "Ingrese costo" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: "Piezas"),
                onChanged: (v) => piezas = v,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saving ? null : guardar,
                child: saving
                    ? const CircularProgressIndicator()
                    : const Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}