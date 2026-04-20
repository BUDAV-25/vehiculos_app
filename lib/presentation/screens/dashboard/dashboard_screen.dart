import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:vehiculos_app/core/utils/token_manager.dart';
import '/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/vehiculos/mazda.jpg",
      "text": "La seguridad comienza con un buen mantenimiento 🚗"
    },
    {
      "image": "assets/images/vehiculos/ford-ranger-raptor.png",
      "text": "Potencia y control en cada camino 💪"
    },
    {
      "image": "assets/images/vehiculos/Honda_CR-V.jpg",
      "text": "Viaja cómodo, viaja seguro 🛣️"
    },
    {
      "image": "assets/images/vehiculos/jetour.png",
      "text": "Tecnología que impulsa tu experiencia ⚡"
    },
    {
      "image": "assets/images/vehiculos/mazda_demio.jpg",
      "text": "Pequeño en tamaño, grande en eficiencia ⛽"
    },
    {
      "image": "assets/images/vehiculos/jetour-dashing.jpg",
      "text": "Diseño moderno para conductores modernos 🔥"
    },
    {
      "image": "assets/images/vehiculos/mercedes-benz.jpg",
      "text": "Elegancia y rendimiento en cada detalle ✨"
    },
  ];

  @override
  void initState() {
    super.initState();
    TokenManager.clearTokens(); // LIMPIA TOKENS AL INICIAR (PRUEBAS)

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % slides.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLogged = auth.isAuthenticated; // 🔥 CLAVE

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text('Inicio'),
        centerTitle: true,
        actions: [
          if (isLogged)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
              },
            )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlider(),
            const SizedBox(height: 16),
            _buildMotivation(),
            const SizedBox(height: 24),

            /// 🔥 CONTENIDO DINÁMICO
            isLogged
                ? _buildLoggedContent(context, auth)
                : _buildGuestContent(context),
          ],
        ),
      ),
    );
  }

  /// ================= SLIDER =================
  Widget _buildSlider() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (_, index) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(slides[index]["image"]!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    slides[index]["text"]!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 16 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    _currentPage == index ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  /// ================= MENSAJE =================
  Widget _buildMotivation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.blueAccent],
        ),
      ),
      child: const Text(
        'Conduce seguro, mantén tu vehículo y evita problemas futuros.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  /// ================= GUEST =================
  Widget _buildGuestContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Inicia sesión para acceder a todas las funciones',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.push('/login'),
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }

  /// ================= LOGGED =================
  Widget _buildLoggedContent(BuildContext context, AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hola, ${auth.nombre ?? ''} 👋',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        _buildQuickMenu(context),

        const SizedBox(height: 24),

        _buildCTA(context),
      ],
    );
  }

  /// ================= MENU =================
  Widget _buildQuickMenu(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _menuItem(Icons.directions_car, 'Vehículos',
            () => context.push('/vehiculos')),
        _menuItem(Icons.newspaper, 'Noticias',
            () => context.push('/noticias')),
        _menuItem(Icons.play_circle_outline, 'Videos',
            () => context.push('/videos')),
        _menuItem(Icons.forum, 'Foro',
            () => context.push('/foro')),
        _menuItem(Icons.info, 'Acerca',
            () => context.push('/acerca-de')),
        _menuItem(Icons.person, 'Perfil',
            () => context.push('/perfil')),
      ],
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  /// ================= CTA =================
  Widget _buildCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Descubre vehículos increíbles',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => context.push('/catalogo'),
            child: const Text('Ir al catálogo'),
          )
        ],
      ),
    );
  }
}