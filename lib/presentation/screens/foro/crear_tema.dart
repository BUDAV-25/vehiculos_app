import 'package:flutter/material.dart';
import '../../../data/services/foro_service.dart';

class CrearTema extends StatefulWidget {
  final int vehiculoId;
  final String token;

  const CrearTema({super.key, required this.vehiculoId, required this.token});

  @override
  State<CrearTema> createState() => _CrearTemaState();
}

class _CrearTemaState extends State<CrearTema> {
  final service = ForoService();
  final _formKey = GlobalKey<FormState>();

  String titulo = "";
  String descripcion = "";

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    await service.crearTema(
      token: widget.token,
      vehiculoId: widget.vehiculoId,
      titulo: titulo,
      descripcion: descripcion,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Tema")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Título"),
                validator: (v) => v!.isEmpty ? "Ingrese título" : null,
                onChanged: (v) => titulo = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Descripción"),
                validator: (v) => v!.isEmpty ? "Ingrese descripción" : null,
                onChanged: (v) => descripcion = v,
              ),
              ElevatedButton(onPressed: guardar, child: const Text("Crear"))
            ],
          ),
        ),
      ),
    );
  }
}