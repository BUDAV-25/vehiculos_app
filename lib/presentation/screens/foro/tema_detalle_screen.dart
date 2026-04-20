import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/services/foro_service.dart';
import '../../../providers/auth_provider.dart';

class TemaDetalleScreen extends StatefulWidget {
  final int temaId;

  const TemaDetalleScreen({super.key, required this.temaId});

  @override
  State<TemaDetalleScreen> createState() => _TemaDetalleScreenState();
}

class _TemaDetalleScreenState extends State<TemaDetalleScreen> {
  final service = ForoService();
  Map<String, dynamic>? tema;
  List<dynamic> respuestas = [];
  bool loading = true;
  final ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    try {
      if (!mounted) return;
      setState(() => loading = true);

      final token = context.read<AuthProvider>().token ?? "";
      final res = await service.obtenerDetalle(token, widget.temaId);

      setState(() {
        // Buscamos el objeto del tema donde sea que venga
        tema = res["tema"] ?? res["data"] ?? res;
        respuestas = res["respuestas"] ?? [];
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> responder() async {
    final texto = ctrl.text.trim();
    if (texto.isEmpty) return;

    final token = context.read<AuthProvider>().token ?? "";

    try {
      await service.responder(
        token: token,
        temaId: widget.temaId,
        contenido: texto, // 🔥 Cambiado a contenido
      );

      ctrl.clear();
      FocusScope.of(context).unfocus();
      cargar(); // Recargar lista
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Respuesta publicada"), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(tema?["titulo"]?.toString() ?? "Detalle")),
      body: Column(
        children: [
          // CABECERA
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tema?["titulo"]?.toString() ?? "Sin título",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(tema?["descripcion"]?.toString() ?? 
                     tema?["contenido"]?.toString() ?? "Sin descripción"),
              ],
            ),
          ),
          // LISTA
          Expanded(
            child: ListView.builder(
              itemCount: respuestas.length,
              itemBuilder: (_, i) {
                final r = respuestas[i];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(r["contenido"]?.toString() ?? r["descripcion"]?.toString() ?? ""),
                  subtitle: const Text("Respuesta"),
                );
              },
            ),
          ),
          // INPUT
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: "Escribe una respuesta...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: responder,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}