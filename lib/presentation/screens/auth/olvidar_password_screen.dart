import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '/providers/auth_provider.dart';

class OlvidarPasswordScreen extends StatefulWidget {
  const OlvidarPasswordScreen({super.key});

  @override
  State<OlvidarPasswordScreen> createState() =>
      _OlvidarPasswordScreenState();
}

class _OlvidarPasswordScreenState extends State<OlvidarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _matriculaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();

    final result = await authProvider.forgotPassword(
      _matriculaController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Clave temporal enviada. Revisa tu correo.",
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Redirigir al login
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Error inesperado"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _matriculaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recuperar contraseña"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Text(
                "¿Olvidaste tu contraseña?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Ingresa tu matrícula y te enviaremos una clave temporal a tu correo.",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: _matriculaController,
                decoration: const InputDecoration(
                  labelText: "Matrícula",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "La matrícula es obligatoria";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Enviar clave temporal"),
              ),

              const SizedBox(height: 15),

              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text("Volver al login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}