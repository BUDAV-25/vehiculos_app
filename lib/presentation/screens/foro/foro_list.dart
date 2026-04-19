import 'package:flutter/material.dart';
import '../../../data/services/foro_service.dart';
import 'detalle_tema.dart';

class ForoList extends StatefulWidget {
  final String token;

  const ForoList({super.key, required this.token});

  @override
  State<ForoList> createState() => _ForoListState();
}

class _ForoListState extends State<ForoList> {
  final service = ForoService();
  List temas = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await service.obtenerTemas(widget.token);

    setState(() {
      temas = data is List ? data : data["data"] ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foro")),
      body: ListView.builder(
        itemCount: temas.length,
        itemBuilder: (_, i) {
          final t = temas[i];

          return ListTile(
            title: Text(t["titulo"]),
            subtitle: Text(t["descripcion"]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalleTema(
                    token: widget.token,
                    temaId: t["id"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}