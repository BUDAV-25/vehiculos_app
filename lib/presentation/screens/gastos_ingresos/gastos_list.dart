import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';
import 'gastos_form.dart';

class GastosList extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const GastosList({
    super.key,
    required this.vehiculoId,
    required this.token,
  });

  @override
  State<GastosList> createState() => _GastosListState();
}

class _GastosListState extends State<GastosList> {
  final service = GastosService();

  List gastos = [];
  int page = 1;
  bool loading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar({bool reset = false}) async {
    if (reset) {
      page = 1;
      gastos.clear();
      hasMore = true;
    }

    if (loading || !hasMore) return;

    setState(() => loading = true);

    try {
      final res =
          await service.obtenerGastos(widget.token, widget.vehiculoId, page);

      print("API GASTOS: $res"); // DEBUG

      List lista = [];

      if (res["data"] is List) {
        lista = res["data"];
      } else if (res["data"] is Map &&
          res["data"]["data"] != null) {
        lista = res["data"]["data"];
      }

      setState(() {
        gastos.addAll(lista);
        hasMore = lista.isNotEmpty;
        loading = false;
      });
    } catch (e) {
      print("Error cargando gastos: $e");
      setState(() => loading = false);
    }
  }

  // 🔥 IR A FORM
  Future<void> irFormulario({Map? gasto}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GastoForm(
          vehiculoId: widget.vehiculoId,
          token: widget.token,
          gasto: gasto,
        ),
      ),
    );

    cargar(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos")),

      floatingActionButton: FloatingActionButton(
        onPressed: () => irFormulario(),
        child: const Icon(Icons.add),
      ),

      body: gastos.isEmpty && !loading
          ? const Center(child: Text("No hay gastos"))
          : ListView.builder(
              itemCount: gastos.length + 1,
              itemBuilder: (context, i) {
                if (i == gastos.length) {
                  if (!hasMore) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        page++;
                        cargar();
                      },
                      child: loading
                          ? const CircularProgressIndicator()
                          : const Text("Cargar más"),
                    ),
                  );
                }

                final g = gastos[i];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text("RD\$ ${g["monto"]}"),
                    subtitle: Text(
                      g["categoria"]?["nombre"] ??
                          "Sin categoría",
                    ),

                    // 🔥 EDITAR
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          irFormulario(gasto: g),
                    ),
                  ),
                );
              },
            ),
    );
  }
}