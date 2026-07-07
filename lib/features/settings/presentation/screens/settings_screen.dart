import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppCard(
              borderColor: theme.colorScheme.primary.withValues(alpha: 0.24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusChip(
                        label: 'Локальная сборка',
                        icon: Icons.settings_outlined,
                      ),
                      StatusChip(
                        label: 'Без живых платежей',
                        icon: Icons.lock_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Настройки приложения',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Здесь собраны параметры, которые не влияют на генерацию и платежи в демо-сборке.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const PlaceholderCard(
              icon: Icons.language_outlined,
              title: 'Язык',
              description:
                  'Интерфейс сейчас подготовлен для русского языка. Переключение языков появится позже.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.notifications_outlined,
              title: 'Уведомления',
              description:
                  'Уведомления о готовности генерации появятся после отдельного разрешения и настройки устройства.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.policy_outlined,
              title: 'Юридические документы',
              description:
                  'Условия использования, политика конфиденциальности и правила AI-контента будут подключены перед релизом.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.support_agent_outlined,
              title: 'Поддержка',
              description:
                  'Помощь по генерациям, балансу и аккаунту появится после подготовки канала поддержки.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.delete_outline,
              title: 'Удалить аккаунт',
              description:
                  'Удаление аккаунта появится после готового безопасного процесса подтверждения.',
            ),
          ],
        ),
      ),
    );
  }
}
