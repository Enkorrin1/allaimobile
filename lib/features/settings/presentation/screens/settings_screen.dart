import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            StatusChip(
              label: 'Статический экран',
              icon: Icons.settings_outlined,
            ),
            SizedBox(height: 16),
            PlaceholderCard(
              icon: Icons.language_outlined,
              title: 'Язык',
              description:
                  'RU-first copy; EN-термины оставлены только там, где это продуктовые названия.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.notifications_outlined,
              title: 'Уведомления',
              description:
                  'Уведомления о готовности job появятся после backend events.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.policy_outlined,
              title: 'Юридические документы',
              description:
                  'Terms, privacy, AI content policy и store compliance links.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.support_agent_outlined,
              title: 'Поддержка',
              description:
                  'Вход в поддержку, жалобы по генерациям и заметки по возвратам.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.delete_outline,
              title: 'Удалить аккаунт',
              description:
                  'Account deletion будет реализован вместе с auth и backend contracts.',
            ),
          ],
        ),
      ),
    );
  }
}
