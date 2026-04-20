import 'package:flutter/material.dart';
import '../../../data/services/combustible_service.dart';

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
  final _formKey = GlobalKey<FormState>();
  final service = CombustibleService();

  String tipo = "combustible";
  String unidad = "galones";
  double cantidad = 0;
  double monto = 0;

  bool loading = false;

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      await service.crearRegistro(
        token: widget.token,
        vehiculoId: widget.vehiculoId,
        tipo: tipo,
        cantidad: cantidad,
        unidad: unidad,
        monto: monto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Guardado")),
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
      appBar: AppBar(title: const Text("Combustible / Aceite")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔽 TIPO
              DropdownButtonFormField<String>(
                value: tipo,
                decoration: const InputDecoration(
                  labelText: "Tipo",
                  border: OutlineInputBorder(),
                ),
                items: ["combustible", "aceite"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => tipo = value!),
              ),

              const SizedBox(height: 15),

              // 🔽 UNIDAD
              DropdownButtonFormField<String>(
                value: unidad,
                decoration: const InputDecoration(
                  labelText: "Unidad",
                  border: OutlineInputBorder(),
                ),
                items: ["galones", "litros", "qt"]
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => unidad = value!),
              ),

              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Cantidad",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese cantidad" : null,
                onChanged: (value) =>
                    cantidad = double.tryParse(value) ?? 0,
              ),

              const SizedBox(height: 15),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Monto (RD\$)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? "Ingrese monto" : null,
                onChanged: (value) =>
                    monto = double.tryParse(value) ?? 0,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : guardar,
                  child: loading
                      ? const CircularProgressIndicator()
                      : const Text("Guardar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}