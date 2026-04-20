import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class IngresoForm extends StatefulWidget {
  final int vehiculoId;
  final String token;
  final Map? ingreso;

  const IngresoForm({
    super.key,
    required this.vehiculoId,
    required this.token,
    this.ingreso,
  });

  @override
  State<IngresoForm> createState() => _IngresoFormState();
}

class _IngresoFormState extends State<IngresoForm> {
  final service = GastosService();
  final _formKey = GlobalKey<FormState>();

  double monto = 0;
  bool saving = false;

  @override
  void initState() {
    super.initState();

    // 🔥 EDITAR
    if (widget.ingreso != null) {
      monto = double.parse(widget.ingreso!["monto"].toString());
    }
  }

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      if (widget.ingreso == null) {
        // ➕ CREAR
        await service.crearIngreso(
          token: widget.token,
          vehiculoId: widget.vehiculoId,
          monto: monto,
        );
      } else {
        // ✏️ EDITAR
        await service.actualizarIngreso(
          token: widget.token,
          id: widget.ingreso!["id"],
          monto: monto,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.ingreso == null
              ? "✅ Ingreso creado"
              : "✏️ Ingreso actualizado"),
        ),
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
      appBar: AppBar(
        title: Text(widget.ingreso == null
            ? "Registrar Ingreso"
            : "Editar Ingreso"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 💰 MONTO
              TextFormField(
                initialValue: monto == 0 ? "" : monto.toString(),
                decoration: const InputDecoration(
                  labelText: "Monto",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese monto" : null,
                onChanged: (v) =>
                    monto = double.tryParse(v) ?? 0,
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : guardar,
                  child: saving
                      ? const CircularProgressIndicator()
                      : Text(widget.ingreso == null
                          ? "Guardar"
                          : "Actualizar"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}