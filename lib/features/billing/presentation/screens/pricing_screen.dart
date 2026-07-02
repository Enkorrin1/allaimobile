import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../fixtures/billing_fixtures.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Pricing')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Coins', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              demoPackagesNotice,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            CostPreviewCard(
              costLabel: demoBalanceLabel,
              reserveCopy: demoReserveCopy,
              warning: demoInsufficientCoinsCopy,
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Demo packages'),
            const SizedBox(height: 8),
            for (final package in demoCoinPackages) ...[
              AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      package.highlighted
                          ? Icons.workspace_premium_outlined
                          : Icons.toll,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  package.name,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                              if (package.highlighted)
                                const StatusChip(
                                  label: 'Popular',
                                  icon: Icons.star_border,
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            package.amountLabel,
                            style: theme.textTheme.labelLarge,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            package.description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            AppButton(
              label: demoTopUpCopy,
              icon: Icons.lock_outline,
              onPressed: null,
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Transactions'),
            const SizedBox(height: 8),
            for (final transaction in demoTransactions) ...[
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.title,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.dateLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      transaction.amountLabel,
                      style: theme.textTheme.labelLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
