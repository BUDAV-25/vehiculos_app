import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const List<Map<String, String>> _equipo = [
  {
    'nombre': 'Pablo Canario',
    'matricula': '2024-0046',
    'telefono': '8493762011',
    'telegram': 'Pablo Canario',
    'correo': '20240046@itla.edu.do',
    'foto': 'assets/images/pablo.jpg',
  },
  {
    'nombre': 'Benny Del Amparo',
    'matricula': '2023-1525',
    'telefono': '8495242245',
    'telegram': 'Benny Amparo',
    'correo': '20231525@itla.edu.do',
    'foto': 'assets/images/benny.jpg',
  },
  {
    'nombre': 'Joel Sebastian',
    'matricula': '2024-0162',
    'telefono': '8298506122',
    'telegram': 'Joel Sebastian',
    'correo': '20240162@itla.edu.do',
    'foto': 'assets/images/sebastian.jpg',
  },
  {
    'nombre': 'Eduardo Junior',
    'matricula': '2024-0028',
    'telefono': '8098190082',
    'telegram': 'Eduardo Junior',
    'correo': '20240028@itla.edu.do',
    'foto': 'assets/images/eduardo.jpg',
  },
  {
    'nombre': 'Randy Acevedo',
    'matricula': '2023-1414',
    'telefono': '2013647094',
    'telegram': 'Randy Acevedo',
    'correo': '202301414@itla.edu.do',
    'foto': 'assets/images/randy.jpg',
  },
];

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  Future<void> _abrirTelefono(String telefono) async {
    final uri = Uri(scheme: 'tel', path: telefono);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _abrirEmail(String correo) async {
    final uri = Uri(scheme: 'mailto', path: correo);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _abrirTelegram(String usuario) async {
    final uri = Uri.parse('https://t.me/$usuario');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        title: const Text('Acerca De', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Encabezado del equipo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: const Color(0xFF161B22),
            child: const Column(
              children: [
                Text(
                  'Equipo de Desarrollo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Apps Móviles · ITLA · 2026',
                  style: TextStyle(color: Color(0xFF58A6FF), fontSize: 12),
                ),
              ],
            ),
          ),
          // Lista de integrantes
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _equipo.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildIntegranteCard(_equipo[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntegranteCard(Map<String, String> persona) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto circular
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              persona['foto']!,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFF1C2128),
                child: const Icon(
                  Icons.person,
                  color: Colors.white38,
                  size: 36,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info del integrante
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  persona['nombre']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  persona['matricula']!,
                  style: const TextStyle(
                    color: Color(0xFF58A6FF),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 10),
                // Botones de contacto
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _botonContacto(
                      Icons.phone,
                      () => _abrirTelefono(persona['telefono']!),
                      const Color(0xFF3FB950),
                    ),
                    _botonContacto(
                      Icons.send,
                      () => _abrirTelegram(persona['telegram']!),
                      const Color(0xFF58A6FF),
                    ),
                    _botonContacto(
                      Icons.email,
                      () => _abrirEmail(persona['correo']!),
                      const Color(0xFFF78166),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonContacto(IconData icono, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icono, color: color, size: 18),
      ),
    );
  }
}
