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
  List<dynamic> respuestas = []; // Usamos dynamic para evitar errores de Map estricto
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
        // La API puede devolver el tema directamente o en una propiedad "tema"
        tema = (res["tema"] is Map) ? res["tema"] : res;
        
        // Manejo seguro de la lista de respuestas
        respuestas = res["respuestas"] ?? [];
        
        loading = false;
      });
    } catch (e) {
      print("❌ ERROR DETALLE: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> responder() async {
    final texto = ctrl.text.trim();
    if (texto.isEmpty) return;

    try {
      final token = context.read<AuthProvider>().token ?? "";

      // 🔥 CORRECCIÓN: El parámetro en ForoService se llama 'contenido'
      await service.responder(
        token: token,
        temaId: widget.temaId,
        contenido: texto, 
      );

      ctrl.clear();
      FocusScope.of(context).unfocus(); // Cierra el teclado
      cargar(); // Recargar para ver la nueva respuesta
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Respuesta enviada correctamente")),
      );
    } catch (e) {
      print("❌ ERROR RESPONDER: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo enviar la respuesta: $e")),
      );
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
        title: Text(tema?["titulo"]?.toString() ?? "Detalle"),
      ),
      body: Column(
        children: [
          // Sección del tema principal
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue.withOpacity(0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tema?["titulo"]?.toString() ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  tema?["descripcion"]?.toString() ?? 
                  tema?["contenido"]?.toString() ?? "",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // Listado de respuestas
          Expanded(
            child: ListView.builder(
              itemCount: respuestas.length,
              itemBuilder: (_, i) {
                final r = respuestas[i];
                // Buscamos el texto en 'descripcion' o 'contenido' según lo que devuelva la API
                final textoRespuesta = r["contenido"]?.toString() ?? 
                                     r["descripcion"]?.toString() ?? "";

                return Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(textoRespuesta),
                      subtitle: const Text("Usuario del foro"),
                    ),
                    const Divider(indent: 70),
                  ],
                );
              },
            ),
          ),

          // Input para responder
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ctrl,
                      decoration: InputDecoration(
                        hintText: "Escribe una respuesta...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: responder,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}