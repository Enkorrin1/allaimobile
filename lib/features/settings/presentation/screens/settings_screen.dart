import 'package:flutter/material.dart';

import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            StatusChip(label: 'Static settings', icon: Icons.settings_outlined),
            SizedBox(height: 16),
            PlaceholderCard(
              icon: Icons.language_outlined,
              title: 'Language',
              description:
                  'RU-first copy with EN labels where product scope still uses them.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              description:
                  'Job-completion notifications will be configured after backend events.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.policy_outlined,
              title: 'Legal',
              description:
                  'Terms, privacy, AI content policy and store compliance links.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.support_agent_outlined,
              title: 'Support',
              description:
                  'Support entry, generation issue reporting and refund notes.',
            ),
            SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.delete_outline,
              title: 'Delete account',
              description:
                  'Account deletion flow will be implemented with auth and backend contracts.',
            ),
          ],
        ),
      ),
    );
  }
}
