import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
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
    final l10n = context.l10n;

    if (auth.isRestoring) {
      return Scaffold(
        body: SafeArea(child: LoadingState(label: l10n.profileRestoring)),
      );
    }

    final session = auth.session;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
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
                    session?.user.displayName ?? l10n.profileFallbackName,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    session == null
                        ? l10n.profileSignInPrompt
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
                      StatusChip(
                        label: l10n.profileSessionActive,
                        icon: Icons.verified_user_outlined,
                      ),
                      CoinBalanceChip(
                        label: balance == null
                            ? l10n.profileBalanceLoading
                            : l10n.profileBalanceCoins(
                                formatCoins(balance.coinBalance),
                              ),
                        onPressed: () => context.push(AppRoutes.pricing),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.account_circle_outlined,
              title: l10n.profileAccountTitle,
              description: l10n.profileAccountDescription,
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.payments_outlined,
              title: l10n.profileCoinsTitle,
              description: l10n.profileCoinsDescription,
              trailing: IconButton(
                tooltip: l10n.profileOpenBalance,
                onPressed: () => context.push(AppRoutes.pricing),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.settings_outlined,
              title: l10n.settingsTitle,
              description: l10n.profileSettingsDescription,
              trailing: IconButton(
                tooltip: l10n.profileOpenSettings,
                onPressed: () => context.push(AppRoutes.settings),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.delete_outline,
              title: l10n.settingsDeleteAccountTitle,
              description: l10n.profileDeleteDescription,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: l10n.commonLogout,
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
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonLogout),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(authControllerProvider.notifier).logout();
    if (context.mounted) context.go(AppRoutes.welcome);
  }
}
