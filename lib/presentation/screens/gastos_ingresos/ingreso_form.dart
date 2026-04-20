import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class IngresoForm extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const IngresoForm({super.key, required this.vehiculoId, required this.token});

  @override
  State<IngresoForm> createState() => _IngresoFormState();
}

class _IngresoFormState extends State<IngresoForm> {
  final service = GastosService();
  final _formKey = GlobalKey<FormState>();

  double monto = 0;

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    await service.crearIngreso(
      token: widget.token,
      vehiculoId: widget.vehiculoId,
      monto: monto,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Ingreso")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Monto",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v!.isEmpty ? "Ingrese monto" : null,
                onChanged: (v) =>
                    monto = double.tryParse(v) ?? 0,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: guardar,
                child: const Text("Guardar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}