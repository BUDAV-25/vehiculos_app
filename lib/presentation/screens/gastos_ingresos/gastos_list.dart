import 'package:flutter/material.dart';
import '../../../data/services/gastos_service.dart';

class GastosList extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const GastosList({super.key, required this.vehiculoId, required this.token});

  @override
  State<GastosList> createState() => _GastosListState();
}

class _GastosListState extends State<GastosList> {
  final service = GastosService();

  List gastos = [];
  int page = 1;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    setState(() => loading = true);

    final res =
        await service.obtenerGastos(widget.token, widget.vehiculoId, page);

    setState(() {
      gastos.addAll(res["data"]);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gastos")),
      body: ListView.builder(
        itemCount: gastos.length + 1,
        itemBuilder: (context, i) {
          if (i == gastos.length) {
            return ElevatedButton(
              onPressed: () {
                page++;
                cargar();
              },
              child: const Text("Cargar más"),
            );
          }

          final g = gastos[i];

          return ListTile(
            title: Text("RD\$ ${g["monto"]}"),
            subtitle: Text(g["categoria"]["nombre"]),
          );
        },
      ),
    );
  }
}