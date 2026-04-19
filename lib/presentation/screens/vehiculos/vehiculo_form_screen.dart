import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/vehicle_provider.dart';

class VehiculoFormScreen extends StatefulWidget {
  final dynamic vehicle;

  const VehiculoFormScreen({super.key, this.vehicle});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final placaCtrl = TextEditingController();
  final chasisCtrl = TextEditingController();
  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final anioCtrl = TextEditingController();
  final ruedasCtrl = TextEditingController();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool get isEditing => widget.vehicle != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final v = widget.vehicle;
      placaCtrl.text = v.placa;
      chasisCtrl.text = v.chasis;
      marcaCtrl.text = v.marca;
      modeloCtrl.text = v.modelo;
      anioCtrl.text = v.anio.toString();
      ruedasCtrl.text = v.cantidadRuedas.toString();
    }
  }

  @override
  void dispose() {
    placaCtrl.dispose();
    chasisCtrl.dispose();
    marcaCtrl.dispose();
    modeloCtrl.dispose();
    anioCtrl.dispose();
    ruedasCtrl.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<VehicleProvider>();

    final data = {
      "placa": placaCtrl.text.trim(),
      "chasis": chasisCtrl.text.trim(),
      "marca": marcaCtrl.text.trim(),
      "modelo": modeloCtrl.text.trim(),
      "anio": int.parse(anioCtrl.text.trim()),
      "cantidadRuedas": int.parse(ruedasCtrl.text.trim()),
    };

    bool success = false;

    if (isEditing) {
      final id = widget.vehicle.id;
      data["id"] = id;

      // 1. EDITAR DATOS
      final updated = await provider.updateVehicle(data);

      // 2. SI CAMBIÓ IMAGEN → SUBIR
      if (updated && selectedImage != null) {
        final uploaded = await provider.uploadVehiclePhoto(
          id: id,
          imagePath: selectedImage!.path,
        );

        success = uploaded;
      } else {
        success = updated;
      }
    } else {
      success = await provider.createVehicle(
        data: data,
        imagePath: selectedImage?.path,
      );
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEditing ? 'Vehículo actualizado' : 'Vehículo creado',
          ),
        ),
      );

      context.pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<VehicleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Vehículo' : 'Nuevo Vehículo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade200,
                  ),
                  child: selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : const Icon(Icons.add_a_photo, size: 40),
                ),
              ),

              const SizedBox(height: 20),

              _input(placaCtrl, 'Placa'),
              _input(chasisCtrl, 'Chasis'),
              _input(marcaCtrl, 'Marca'),
              _input(modeloCtrl, 'Modelo'),
              _input(anioCtrl, 'Año', isNumber: true),
              _input(ruedasCtrl, 'Cantidad de ruedas', isNumber: true),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : save,
                  child: provider.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Actualizar' : 'Guardar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController ctrl, String label,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ingrese $label';
          }
          if (isNumber && int.tryParse(value) == null) {
            return 'Debe ser un número válido';
          }
          return null;
        },
      ),
    );
  }
}