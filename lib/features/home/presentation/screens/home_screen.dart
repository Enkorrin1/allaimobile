import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/fixtures/billing_fixtures.dart';
import '../../../../features/library/presentation/fixtures/library_fixtures.dart';
import '../../../../features/tools/presentation/fixtures/tool_fixtures.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coin_balance_chip.dart';
import '../../../../shared/widgets/media_asset_tile.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quickTemplates = demoTemplates.take(3).toList();
    final recentAssets = demoLibraryAssets.take(2).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AllAI Studio'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CoinBalanceChip(
              label: demoBalanceLabel,
              onPressed: () => context.go(AppRoutes.pricing),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Mobile creative desk', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Генерируйте изображения, видео и social-ready материалы из одного мобильного рабочего пространства.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Create new asset',
                    icon: Icons.auto_awesome,
                    onPressed: () => context.go(AppRoutes.create),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: 'Browse tools',
                    icon: Icons.widgets_outlined,
                    secondary: true,
                    onPressed: () => context.go(AppRoutes.tools),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const StatusChip(
                        label: 'Active job',
                        icon: Icons.hourglass_top,
                      ),
                      const Spacer(),
                      Text(
                        '${(demoActiveJob.progress * 100).round()}%',
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(demoActiveJob.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 6),
                  Text(
                    demoActiveJob.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  LinearProgressIndicator(value: demoActiveJob.progress),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: 'Quick templates',
              actionLabel: 'All tools',
              onActionPressed: () => context.go(AppRoutes.tools),
            ),
            const SizedBox(height: 8),
            for (final template in quickTemplates) ...[
              TemplateCard(
                title: template.title,
                badge: template.badge,
                description: template.description,
                costLabel: 'от ${template.estimatedCost} койнов',
                icon: template.icon,
                accentColor: template.accentColor,
                onTap: () => context.go(AppRoutes.templateDetail(template.id)),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            const SectionHeader(title: 'Recommended tools'),
            const SizedBox(height: 8),
            for (final tool in demoTools.take(2)) ...[
              ModelCard(
                name: tool.name,
                category: tool.category,
                description: tool.description,
                costLabel: 'от ${tool.estimatedCost} койнов',
                icon: tool.icon,
                accentColor: tool.accentColor,
                available: tool.available,
                onTap: () => context.go(AppRoutes.toolDetail(tool.id)),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 10),
            SectionHeader(
              title: 'Recent results',
              actionLabel: 'Library',
              onActionPressed: () => context.go(AppRoutes.library),
            ),
            const SizedBox(height: 8),
            for (final asset in recentAssets) ...[
              MediaAssetTile(
                title: asset.title,
                kind: asset.kind,
                status: asset.status,
                subtitle: asset.createdAtLabel,
                icon: asset.icon,
                accentColor: asset.accentColor,
                onTap: () => context.go(AppRoutes.result(asset.id)),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}
