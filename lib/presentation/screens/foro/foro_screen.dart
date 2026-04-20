import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/foro_service.dart';
import '../../../providers/auth_provider.dart';

class ForoScreen extends StatefulWidget {
  const ForoScreen({super.key});

  @override
  State<ForoScreen> createState() => _ForoScreenState();
}

class _ForoScreenState extends State<ForoScreen> {
  final service = ForoService();
  List<dynamic> temas = [];
  bool loading = true;

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
      final data = await service.obtenerTemas(token);

      if (!mounted) return;
      setState(() {
        temas = data;
        loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foro"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: cargar)
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : temas.isEmpty
              ? const Center(child: Text("No hay temas disponibles"))
              : RefreshIndicator(
                  onRefresh: cargar,
                  child: ListView.separated(
                    itemCount: temas.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final t = temas[i];
                      final id = t["id"];

                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.forum)),
                        title: Text(
                          t["titulo"]?.toString() ?? "Sin título",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          t["descripcion"]?.toString() ?? 
                          t["contenido"]?.toString() ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          if (id != null) {
                            context.push('/foro/detalle/$id');
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/foro/crear');
          cargar(); // Recarga la lista al volver de crear un tema
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}