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

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    redirect: (context, state) async {
      final isLoggedIn = await TokenManager.hasToken();

      final goingToLogin = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return goingToLogin ? null : '/login';
      }

      if (isLoggedIn && goingToLogin) {
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
          final data = state.extra as Map<String, dynamic>?;

          final token = data?['token'];

          if (token == null) {
            return const LoginScreen(); // fallback seguro
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
        path: '/profile',
        builder: (context, state) => const PerfilScreen(),
      ),
    ],
  );
}