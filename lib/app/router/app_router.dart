import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/billing/presentation/screens/pricing_screen.dart';
import '../../features/auth/presentation/screens/auth_welcome_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/password_reset_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/generator/presentation/screens/generator_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/result_viewer/presentation/screens/result_viewer_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/studio/presentation/screens/studio_screen.dart';
import '../../features/tools/domain/catalog_models.dart';
import '../../features/tools/presentation/screens/template_detail_screen.dart';
import '../../features/tools/presentation/screens/tool_detail_screen.dart';
import '../../features/tools/presentation/screens/tools_screen.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

final initialLocationProvider = Provider<String>((ref) => AppRoutes.welcome);

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final authRefresh = ValueNotifier<int>(0);
  final initialLocation = ref.watch(initialLocationProvider);

  ref
    ..listen<AuthState>(authControllerProvider, (previous, next) {
      authRefresh.value += 1;
    })
    ..onDispose(authRefresh.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    refreshListenable: authRefresh,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final path = state.uri.path;
      final authRoute = _isAuthRoute(path);

      if (auth.isRestoring) return null;
      if (!auth.isSignedIn && !authRoute) return AppRoutes.welcome;
      if (auth.isSignedIn && authRoute) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const AuthWelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.passwordReset,
        name: 'password-reset',
        builder: (context, state) => const PasswordResetScreen(),
      ),
      GoRoute(
        path: AppRoutes.tools,
        name: 'tools',
        builder: (context, state) => const ToolsScreen(),
      ),
      GoRoute(
        path: AppRoutes.toolDetailPath,
        name: 'tool-detail',
        builder: (context, state) {
          final toolId = state.pathParameters['toolId'] ?? '';
          return ToolDetailScreen(toolId: toolId);
        },
      ),
      GoRoute(
        path: AppRoutes.templateDetailPath,
        name: 'template-detail',
        builder: (context, state) {
          final templateId = state.pathParameters['templateId'] ?? '';
          return TemplateDetailScreen(templateId: templateId);
        },
      ),
      GoRoute(
        path: AppRoutes.resultPath,
        name: 'result',
        builder: (context, state) {
          final assetId = state.pathParameters['assetId'] ?? '';
          return ResultViewerScreen(assetId: assetId);
        },
      ),
      GoRoute(
        path: AppRoutes.pricing,
        name: 'pricing',
        builder: (context, state) => const PricingScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.create,
                name: 'create',
                builder: (context, state) => GeneratorScreen(
                  initialCategory: _categoryFromQuery(
                    state.uri.queryParameters['format'],
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                name: 'library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.studio,
                name: 'studio',
                builder: (context, state) => const StudioScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

bool _isAuthRoute(String path) {
  return path == AppRoutes.welcome ||
      path == AppRoutes.login ||
      path == AppRoutes.register ||
      path == AppRoutes.passwordReset;
}

AiModelCategory _categoryFromQuery(String? value) => switch (value) {
  'image' => AiModelCategory.image,
  'video' => AiModelCategory.video,
  'upscale' => AiModelCategory.upscale,
  'avatar' => AiModelCategory.avatar,
  'motion' => AiModelCategory.motion,
  _ => AiModelCategory.video,
};
