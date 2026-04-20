import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';
import 'ingreso_form.dart';

class IngresosList extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const IngresosList({
    super.key,
    required this.vehiculoId,
    required this.token,
  });

  @override
  State<IngresosList> createState() => _IngresosListState();
}

class _IngresosListState extends State<IngresosList> {
  final service = GastosService();

  List ingresos = [];
  int page = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar({bool reset = false}) async {
    if (reset) {
      page = 1;
      ingresos.clear();
    }

    setState(() => loading = true);

    final res = await service.obtenerIngresos(
      widget.token,
      widget.vehiculoId,
      page,
    );

    setState(() {
      ingresos.addAll(res["data"]);
      loading = false;
    });
  }

  // 🔥 IR A FORM (CREAR / EDITAR)
  Future<void> irFormulario({Map? ingreso}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IngresoForm(
          vehiculoId: widget.vehiculoId,
          token: widget.token,
          ingreso: ingreso,
        ),
      ),
    );

    cargar(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ingresos")),

      // ➕ CREAR
      floatingActionButton: FloatingActionButton(
        onPressed: () => irFormulario(),
        child: const Icon(Icons.add),
      ),

      body: ListView.builder(
        itemCount: ingresos.length + 1,
        itemBuilder: (context, i) {
          if (i == ingresos.length) {
            return ElevatedButton(
              onPressed: () {
                page++;
                cargar();
              },
              child: const Text("Cargar más"),
            );
          }

          final ing = ingresos[i];

          return ListTile(
            title: Text("RD\$ ${ing["monto"]}"),
            subtitle: Text(ing["concepto"] ?? "Ingreso"),

            // ✏️ EDITAR
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => irFormulario(ingreso: ing),
            ),
          );
        },
      ),
    );
  }
}