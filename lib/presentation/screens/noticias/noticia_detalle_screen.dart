import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../data/services/noticias_service.dart';

class NoticiaDetalleScreen extends StatefulWidget {
  final int id;
  const NoticiaDetalleScreen({super.key, required this.id});

  @override
  State<NoticiaDetalleScreen> createState() => _NoticiaDetalleScreenState();
}

class _NoticiaDetalleScreenState extends State<NoticiaDetalleScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _detalle = {};

  final _service = NoticiasService();

  @override
  void initState() {
    super.initState();
    _cargarDetalle();
  }

  Future<void> _cargarDetalle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final resultado = await _service.getNoticiaDetalle(widget.id);
      setState(() {
        _detalle = resultado;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Detalle', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF58A6FF)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white38, size: 48),
            const SizedBox(height: 12),
            Text(
              'Error al cargar',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarDetalle,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58A6FF),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _detalle['titulo'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _detalle['fecha'] ?? '',
            style: const TextStyle(color: Color(0xFF58A6FF), fontSize: 12),
          ),
          const SizedBox(height: 16),
          Html(
            data: _detalle['contenido'] ?? '',
            style: {
              "body": Style(
                color: Colors.white70,
                fontSize: FontSize(13),
                lineHeight: LineHeight(1.6),
              ),
              "h1": Style(color: Colors.white),
              "h2": Style(color: Colors.white),
              "p": Style(color: Colors.white70),
              "a": Style(color: const Color(0xFF58A6FF)),
            },
          ),
        ],
      ),
    );
  }
}
