import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/fixtures/billing_fixtures.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coin_balance_chip.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/status_chip.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Open welcome',
            onPressed: () => context.go(AppRoutes.welcome),
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Demo creator',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Static profile shell. Auth, token restore and account data arrive in later phases.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      const StatusChip(
                        label: 'Development shell',
                        icon: Icons.construction,
                      ),
                      CoinBalanceChip(
                        label: demoBalanceLabel,
                        onPressed: () => context.go(AppRoutes.pricing),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.account_circle_outlined,
              title: 'Account',
              description:
                  'Legal consent, 18+ confirmation, logout and delete-account flows will connect in Phase 4.',
              trailing: IconButton(
                tooltip: 'Open auth',
                onPressed: () => context.go(AppRoutes.welcome),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.payments_outlined,
              title: 'Coins and billing',
              description:
                  'Demo balance and packages are visible now; real billing is intentionally disabled.',
              trailing: IconButton(
                tooltip: 'Open pricing',
                onPressed: () => context.go(AppRoutes.pricing),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 12),
            PlaceholderCard(
              icon: Icons.settings_outlined,
              title: 'Settings',
              description:
                  'Language, notifications, privacy, terms and support links.',
              trailing: IconButton(
                tooltip: 'Open settings',
                onPressed: () => context.go(AppRoutes.settings),
                icon: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
