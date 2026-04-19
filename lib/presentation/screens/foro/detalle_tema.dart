import 'package:flutter/material.dart';
import '../../../data/services/foro_service.dart';

class DetalleTema extends StatefulWidget {
  final int temaId;
  final String token;

  const DetalleTema({super.key, required this.temaId, required this.token});

  @override
  State<DetalleTema> createState() => _DetalleTemaState();
}

class _DetalleTemaState extends State<DetalleTema> {
  final service = ForoService();

  Map tema = {};
  List respuestas = [];

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final data = await service.detalleTema(widget.token, widget.temaId);

    setState(() {
      tema = data["tema"];
      respuestas = data["respuestas"];
    });
  }

  Future<void> responder() async {
    await service.responder(
      token: widget.token,
      temaId: widget.temaId,
      contenido: controller.text,
    );

    controller.clear();
    cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tema["titulo"] ?? "")),
      body: Column(
        children: [
          Text(tema["descripcion"] ?? ""),

          Expanded(
            child: ListView.builder(
              itemCount: respuestas.length,
              itemBuilder: (_, i) {
                final r = respuestas[i];
                return ListTile(title: Text(r["contenido"]));
              },
            ),
          ),

          Row(
            children: [
              Expanded(
                child: TextField(controller: controller),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: responder,
              )
            ],
          )
        ],
      ),
    );
  }
}