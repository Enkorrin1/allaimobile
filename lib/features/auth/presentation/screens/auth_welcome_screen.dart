import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';

class AuthWelcomeScreen extends StatelessWidget {
  const AuthWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('AllAI')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          'Создавайте AI-фото и видео',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Начните с промпта, фото продукта или готового шаблона.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        AppButton(
                          label: 'Войти',
                          icon: Icons.login,
                          onPressed: () => context.go(AppRoutes.login),
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Создать аккаунт',
                          icon: Icons.person_add_alt_1,
                          secondary: true,
                          onPressed: () => context.go(AppRoutes.register),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Регистрация требует подтверждения 18+ и согласия с условиями AllAI.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
