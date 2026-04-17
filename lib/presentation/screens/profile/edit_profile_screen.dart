import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/auth_provider.dart';
import '../../../core/utils/image_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? selectedImage;

  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;

    _isPicking = true;

    try {
      final picker = ImagePicker();

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        // manejar imagen
      }
    } catch (e) {
      print(e);
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _upload() async {
  if (selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Seleccione una imagen')),
    );
    return;
  }

  final auth = context.read<AuthProvider>();

  final error = await auth.updatePhoto(selectedImage!.path);

  if (!mounted) return;

  if (error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error), backgroundColor: Colors.red),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Foto actualizada'),
      backgroundColor: Colors.green,
    ),
  );

  // 🔥 FIX REAL
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/perfil');
  }
}
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar foto')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            // AVATAR
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: selectedImage != null
                    ? FileImage(selectedImage!)
                    : ImageHelper.getImageProvider(auth.fotoUrl),
                child: selectedImage == null &&
                        !ImageHelper.isValid(auth.fotoUrl)
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Toca la imagen para cambiarla',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // BOTÓN
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: auth.isLoading ? null : _upload,
                child: auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Subir foto'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}