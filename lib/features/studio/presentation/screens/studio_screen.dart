import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/tools/presentation/fixtures/tool_fixtures.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/template_card.dart';

class StudioScreen extends StatelessWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final socialTemplates = demoTemplates
        .where(
          (template) =>
              template.id == 'product-ugc-hook' ||
              template.id == 'social-hook-cut' ||
              template.id == 'ugc',
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Studio')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Social studio', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Draft social assets, collect captions and prepare exports before direct publishing exists.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            AppCard(
              child: Row(
                children: [
                  Icon(
                    Icons.dashboard_customize_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '3 draft slots ready for TikTok, Reels and Shorts mock flows.',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SectionHeader(title: 'Social-ready templates'),
            const SizedBox(height: 8),
            for (final template in socialTemplates) ...[
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
            const PlaceholderCard(
              icon: Icons.dashboard_customize_outlined,
              title: 'Social drafts',
              description:
                  'TikTok, YouTube Shorts, Pinterest and Reels workflows land after MVP generation.',
            ),
            const SizedBox(height: 12),
            const PlaceholderCard(
              icon: Icons.inventory_2_outlined,
              title: 'Export package',
              description:
                  'Save captions, prompts and generated assets together for publishing.',
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Create social asset',
              icon: Icons.auto_awesome,
              onPressed: () => context.go(AppRoutes.create),
            ),
          ],
        ),
      ),
    );
  }
}
