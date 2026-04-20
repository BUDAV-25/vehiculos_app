import 'package:go_router/go_router.dart';
import '../../core/utils/token_manager.dart';

// Screens
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/dashboard/dashboard_screen.dart';
import '../../presentation/screens/auth/registro_screen.dart';
import '../../presentation/screens/auth/activar_screen.dart';
import '../../presentation/screens/auth/olvidar_password_screen.dart';

//Profile
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/edit_profile_screen.dart';

// — tus imports nuevos (agregar después de los imports de perfil) —
import '../../presentation/screens/noticias/noticias_screen.dart';
import '../../presentation/screens/noticias/noticia_detalle_screen.dart';
import '../../presentation/screens/videos/videos_screen.dart';
import '../../presentation/screens/acerca_de/acerca_de_screen.dart';
import '../../presentation/screens/vehiculos/mis_vehiculos_screen.dart';
import '../../presentation/screens/vehiculos/vehiculo_form_screen.dart';
import '../../presentation/screens/vehiculos/vehiculo_detail_screen.dart';

// Foro
import '../../presentation/screens/foro/foro_screen.dart';
import '../../presentation/screens/foro/tema_detalle_screen.dart';
import '../../presentation/screens/foro/crear_post_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) async {
      final isLoggedIn = await TokenManager.hasToken();

      final publicRoutes = [
        '/login',
        '/registro',
        '/olvidar',
        '/activar',
        '/noticias',
        '/videos',
        '/acerca-de',
      ];

      final isPublic = publicRoutes.contains(state.matchedLocation);

      if (!isLoggedIn && !isPublic) {
        return '/login';
      }

      if (isLoggedIn && state.matchedLocation == '/login') {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      // SPLASH
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),

      // LOGIN
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

      // REGISTRO
      GoRoute(
        path: '/registro',
        builder: (context, state) => const RegisterScreen(),
      ),

      // ACTIVAR
      GoRoute(
        path: '/activar',
        builder: (context, state) {
          final token = state.extra as String?;

          if (token == null) {
            return const LoginScreen();
          }

          return ActivarScreen(token: token);
        },
      ),

      // OLVIDAR PASSWORD
      GoRoute(
        path: '/olvidar',
        builder: (context, state) => const ChangePasswordScreen(),
      ),

      // DASHBOARD
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),

      // PERFIL
      GoRoute(
        path: '/perfil',
        builder: (context, state) => const PerfilScreen(),
      ),

      // EDITAR PERFIL
      GoRoute(
        path: '/perfil/editar',
        builder: (context, state) => const EditProfileScreen(),
      ),

      GoRoute(
        path: '/noticias',
        builder: (context, state) => const NoticiasScreen(),
      ),

      GoRoute(
        path: '/noticias/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id'] ?? '0');
          return NoticiaDetalleScreen(id: id);
        },
      ),

      // VIDEOS
      GoRoute(
        path: '/videos',
        builder: (context, state) => const VideosScreen(),
      ),

      GoRoute(
        path: '/vehiculos',
        builder: (context, state) => const MisVehiculosScreen(),
      ),

      GoRoute(
        path: '/vehiculo/create',
        builder: (context, state) => const VehiculoFormScreen(),
      ),

      GoRoute(
        path: '/vehiculo/editar',
        builder: (context, state) {
          final vehicle = state.extra;
          return VehiculoFormScreen(vehicle: vehicle);
        },
      ),

      GoRoute(
        path: '/vehiculo/detalle/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return VehiculoDetailScreen(id: id);
        },
      ),

      // FORO
      GoRoute(path: '/foro', builder: (_, _) => const ForoScreen()),

      GoRoute(path: '/foro/crear', builder: (_, _) => const CrearPostScreen()),

      GoRoute(
        path: '/foro/detalle/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return TemaDetalleScreen(temaId: id);
        },
      ),

      // ACERCA DE
      GoRoute(
        path: '/acerca-de',
        builder: (context, state) => const AcercaDeScreen(),
      ),
    ],
  );
}