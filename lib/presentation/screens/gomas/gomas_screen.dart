import 'package:flutter/material.dart';
import '../../../data/services/gomas_service.dart';

class GomasScreen extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const GomasScreen({
    super.key,
    required this.vehiculoId,
    required this.token,
  });

  @override
  State<GomasScreen> createState() => _GomasScreenState();
}

class _GomasScreenState extends State<GomasScreen> {
  final service = GomasService();

  List gomas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarGomas();
  }

  Future<void> cargarGomas() async {
    try {
      final data =
          await service.obtenerGomas(widget.token, widget.vehiculoId);

      setState(() {
        gomas = data;
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Color getColor(String estado) {
    switch (estado) {
      case "buena":
        return Colors.green;
      case "regular":
        return Colors.orange;
      case "mala":
        return Colors.red;
      case "reemplazada":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget gomaWidget(Map goma) {
    return Column(
      children: [
        Text(goma["posicion"] ?? "Goma"),
        const SizedBox(height: 5),

        // 🔽 ESTADO
        DropdownButton<String>(
          value: goma["estado"],
          items: ["buena", "regular", "mala", "reemplazada"]
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
              .toList(),
          onChanged: (value) async {
            await service.actualizarEstado(
              token: widget.token,
              gomaId: goma["id"],
              estado: value!,
            );

            cargarGomas();
          },
        ),

        const SizedBox(height: 5),

        // 🔴 COLOR VISUAL
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: getColor(goma["estado"]),
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(height: 5),

        // 🛠 PINCHAZO
        ElevatedButton(
          onPressed: () => registrarPinchazo(goma["id"]),
          child: const Text("Pinchazo"),
        ),
      ],
    );
  }

  Future<void> registrarPinchazo(int gomaId) async {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Registrar pinchazo"),
        content: TextField(
          controller: controller,
          decoration:
              const InputDecoration(labelText: "Descripción"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await service.registrarPinchazo(
                token: widget.token,
                gomaId: gomaId,
                descripcion: controller.text,
                fecha: DateTime.now().toString().split(" ")[0],
              );

              Navigator.pop(context);
            },
            child: const Text("Guardar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Estado de Gomas")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FILA DELANTERA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              gomaWidget(gomas[0]),
              gomaWidget(gomas[1]),
            ],
          ),

          const SizedBox(height: 50),

          // FILA TRASERA
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              gomaWidget(gomas[2]),
              gomaWidget(gomas[3]),
            ],
          ),
        ],
      ),
    );
  }
}