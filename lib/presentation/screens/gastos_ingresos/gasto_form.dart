import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class GastoForm extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const GastoForm({
    super.key,
    required this.vehiculoId,
    required this.token,
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
  }

  Future<void> cargarCategorias() async {
  try {
    final dynamic data = await service.obtenerCategorias(widget.token);

    print("API CATEGORIAS: $data");

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
  // 💾 GUARDAR
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
      await service.crearGasto(
        token: widget.token,
        vehiculoId: widget.vehiculoId,
        categoriaId: categoriaId!,
        monto: monto,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Gasto guardado")),
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
    // 🔄 LOADING
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Gasto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔽 DROPDOWN CATEGORÍAS (100% CORREGIDO)
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Categoría",
                  border: OutlineInputBorder(),
                ),
                items: categorias.map<DropdownMenuItem<int>>((cat) {
                  return DropdownMenuItem<int>(
                    value: int.parse(cat["id"].toString()), // 🔥 FIX
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

              // 💾 BOTÓN
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saving ? null : guardar,
                  child: saving
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