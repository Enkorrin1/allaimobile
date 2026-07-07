import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coin_balance_chip.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../billing/presentation/providers/billing_providers.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final balance = ref.watch(balanceProvider).value;
    final auth = ref.watch(authControllerProvider);

    if (auth.isRestoring) {
      return const Scaffold(
        body: SafeArea(child: LoadingState(label: 'Восстанавливаем сессию')),
      );
    }

    final session = auth.session;

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppCard(
              borderColor: colorScheme.primary.withValues(alpha: 0.24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    session?.user.displayName ?? 'Аккаунт AllAI',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session == null
                        ? 'Войдите, чтобы открыть профиль.'
                        : session.user.email,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const StatusChip(
                        label: 'Сессия активна',
                        icon: Icons.verified_user_outlined,
                      ),
                      CoinBalanceChip(
                        label: balance == null
                            ? 'Баланс загружается'
                            : 'Баланс: ${formatCoins(balance.coinBalance)} койнов',
                        onPressed: () => context.push(AppRoutes.pricing),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const PlaceholderCard(
              icon: Icons.account_circle_outlined,
              title: 'Аккаунт',
              description:
                  'Email, имя, подтверждение 18+ и локальная сессия. Редактирование профиля появится позже.',
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.payments_outlined,
              title: 'Койны и баланс',
              description:
                  'Демо-баланс и пакеты видны сейчас. Реальные покупки намеренно отключены в этой сборке.',
              trailing: IconButton(
                tooltip: 'Открыть баланс',
                onPressed: () => context.push(AppRoutes.pricing),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.settings_outlined,
              title: 'Настройки',
              description: 'Язык, уведомления, юридические ссылки и поддержка.',
              trailing: IconButton(
                tooltip: 'Открыть настройки',
                onPressed: () => context.push(AppRoutes.settings),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            const PlaceholderCard(
              icon: Icons.delete_outline,
              title: 'Удалить аккаунт',
              description:
                  'Удаление аккаунта появится после готового backend-контракта. Сейчас действие недоступно.',
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Выйти',
              icon: Icons.logout,
              secondary: true,
              fullWidth: true,
              onPressed: () => _confirmLogout(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Локальная история останется на устройстве.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) context.go(AppRoutes.welcome);
  }
}
