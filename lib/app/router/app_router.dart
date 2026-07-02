import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/billing/presentation/screens/pricing_screen.dart';
import '../../features/auth/presentation/screens/auth_welcome_screen.dart';
import '../../features/auth/presentation/screens/login_placeholder_screen.dart';
import '../../features/generator/presentation/screens/generator_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/result_viewer/presentation/screens/result_viewer_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/studio/presentation/screens/studio_screen.dart';
import '../../features/tools/presentation/screens/template_detail_screen.dart';
import '../../features/tools/presentation/screens/tool_detail_screen.dart';
import '../../features/tools/presentation/screens/tools_screen.dart';
import '../../shared/widgets/app_shell.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const AuthWelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPlaceholderScreen(),
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
                builder: (context, state) => const GeneratorScreen(),
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
