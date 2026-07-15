import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/locale/app_locale_controller.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final localeState = ref.watch(appLocaleControllerProvider);

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
            _LanguageSettingsCard(
              selectedLabel: localeState.isRestoring
                  ? l10n.commonLoading
                  : appLanguageLabel(
                      localeState.locale,
                      l10n.settingsLanguageSystem,
                    ),
              onTap: () => _showLanguagePicker(context, ref),
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final l10n = context.l10n;
        final selectedCode =
            ref.watch(appLocaleControllerProvider).locale?.languageCode ??
            'system';

        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              Text(
                l10n.settingsLanguagePickerTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              _LanguageOptionTile(
                key: const Key('language-option-system'),
                title: l10n.settingsLanguageSystem,
                selected: selectedCode == 'system',
                onTap: () {
                  ref
                      .read(appLocaleControllerProvider.notifier)
                      .selectLocale(null);
                  Navigator.of(context).pop();
                },
              ),
              for (final language in supportedAppLanguages)
                _LanguageOptionTile(
                  key: Key('language-option-${language.code}'),
                  title: language.nativeName,
                  subtitle: language.nativeName == language.englishName
                      ? null
                      : language.englishName,
                  selected: selectedCode == language.code,
                  onTap: () {
                    ref
                        .read(appLocaleControllerProvider.notifier)
                        .selectLocale(language.locale);
                    Navigator.of(context).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        selected ? Icons.check_circle : Icons.circle_outlined,
        color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
    );
  }
}

class _LanguageSettingsCard extends StatelessWidget {
  const _LanguageSettingsCard({
    required this.selectedLabel,
    required this.onTap,
  });

  final String selectedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return AppCard(
      key: const Key('settings-language-card'),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.language_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsLanguageTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.settingsLanguageDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
