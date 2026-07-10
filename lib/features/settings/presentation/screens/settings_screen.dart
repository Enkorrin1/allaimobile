import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            AppCard(
              borderColor: theme.colorScheme.primary.withValues(alpha: 0.24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusChip(
                        label: l10n.settingsLocalBuild,
                        icon: Icons.settings_outlined,
                      ),
                      StatusChip(
                        label: l10n.settingsDemoBilling,
                        icon: Icons.lock_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.settingsAppTitle,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsAppDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.language_outlined,
              title: l10n.settingsLanguageTitle,
              description: l10n.settingsLanguageDescription,
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.notifications_outlined,
              title: l10n.settingsNotificationsTitle,
              description: l10n.settingsNotificationsDescription,
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.policy_outlined,
              title: l10n.settingsLegalTitle,
              description: l10n.settingsLegalDescription,
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.support_agent_outlined,
              title: l10n.settingsSupportTitle,
              description: l10n.settingsSupportDescription,
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.delete_outline,
              title: l10n.settingsDeleteAccountTitle,
              description: l10n.settingsDeleteAccountDescription,
            ),
          ],
        ),
      ),
    );
  }
}
