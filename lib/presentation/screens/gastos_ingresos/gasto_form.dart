import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class GastoForm extends StatefulWidget {
  final int vehiculoId;
  final String token;
  final Map? gasto; // 🔥 NUEVO (para editar)

  const GastoForm({
    super.key,
    required this.vehiculoId,
    required this.token,
    this.gasto,
  });

  @override
  State<GastoForm> createState() => _GastoFormState();
}

class _GastoFormState extends State<GastoForm> {
  final service = GastosService();
  final _formKey = GlobalKey<FormState>();

  List categorias = [];
  int? categoriaId;
  double monto = 0;

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    cargarCategorias();

    // 🔥 SI VIENE GASTO → EDITAR
    if (widget.gasto != null) {
      categoriaId = widget.gasto!["categoria"]["id"];
      monto = double.parse(widget.gasto!["monto"].toString());
    }
  }

  Future<void> cargarCategorias() async {
    try {
      final dynamic data = await service.obtenerCategorias(widget.token);

      List lista = [];

      if (data is List) {
        lista = data;
      } else if (data is Map<String, dynamic>) {
        lista = data["data"] ?? [];
      }

      setState(() {
        categorias = lista;
        loading = false;
      });
    } catch (e) {
      print("Error cargando categorias: $e");
      setState(() => loading = false);
    }
  }

  // 💾 GUARDAR (CREATE / UPDATE)
  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    if (categoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione categoría")),
      );
      return;
    }

    setState(() => saving = true);

    try {
      if (widget.gasto == null) {
        // ➕ CREAR
        await service.crearGasto(
          token: widget.token,
          vehiculoId: widget.vehiculoId,
          categoriaId: categoriaId!,
          monto: monto,
        );
      } else {
        // ✏️ EDITAR
        await service.actualizarGasto(
          token: widget.token,
          id: widget.gasto!["id"],
          categoriaId: categoriaId!,
          monto: monto,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.gasto == null
              ? "✅ Gasto creado"
              : "✏️ Gasto actualizado"),
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
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gasto == null
            ? "Registrar Gasto"
            : "Editar Gasto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔽 CATEGORÍA
              DropdownButtonFormField<int>(
                value: categoriaId,
                decoration: const InputDecoration(
                  labelText: "Categoría",
                  border: OutlineInputBorder(),
                ),
                items: categorias.map<DropdownMenuItem<int>>((cat) {
                  return DropdownMenuItem<int>(
                    value: int.parse(cat["id"].toString()),
                    child: Text(cat["nombre"].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    categoriaId = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Seleccione categoría" : null,
              ),

              const SizedBox(height: 15),

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
                      : Text(widget.gasto == null
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