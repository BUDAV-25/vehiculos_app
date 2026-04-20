import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class CombustibleForm extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const CombustibleForm({
    super.key,
    required this.vehiculoId,
    required this.token,
  });

  @override
  State<CombustibleForm> createState() => _CombustibleFormState();
}

class _CombustibleFormState extends State<CombustibleForm> {
  final service = GastosService();
  final _formKey = GlobalKey<FormState>();

  double cantidad = 0;
  String unidad = "galones";
  double monto = 0;

  bool saving = false;

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      await service.crearCombustible(
        token: widget.token,
        vehiculoId: widget.vehiculoId,
        cantidad: cantidad,
        unidad: unidad,
        monto: monto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Combustible registrado")),
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
      appBar: AppBar(title: const Text("Combustible")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                decoration: const InputDecoration(labelText: "Cantidad"),
                keyboardType: TextInputType.number,
                onChanged: (v) => cantidad = double.tryParse(v) ?? 0,
                validator: (v) => v!.isEmpty ? "Ingrese cantidad" : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                initialValue: "galones",
                decoration: const InputDecoration(labelText: "Unidad"),
                onChanged: (v) => unidad = v,
              ),

              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(labelText: "Monto"),
                keyboardType: TextInputType.number,
                onChanged: (v) => monto = double.tryParse(v) ?? 0,
                validator: (v) => v!.isEmpty ? "Ingrese monto" : null,
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