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
      ];

      final isPublic = publicRoutes.contains(state.matchedLocation);

      // 🔴 Si NO está logueado
      if (!isLoggedIn && !isPublic) {
        return '/login';
      }

      // 🟢 Si está logueado y quiere ir a login
      if (isLoggedIn && state.matchedLocation == '/login') {
        return '/dashboard';
      }

      return null;
    },

    routes: [
      // SPLASH
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // LOGIN
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

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
    ],
  );
}