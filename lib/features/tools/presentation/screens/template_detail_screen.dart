import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../billing/presentation/fixtures/billing_fixtures.dart';
import '../fixtures/tool_fixtures.dart';

class TemplateDetailScreen extends StatelessWidget {
  const TemplateDetailScreen({required this.templateId, super.key});

  final String templateId;

  @override
  Widget build(BuildContext context) {
    final template = demoTemplateById(templateId);
    if (template == null) {
      return const Scaffold(
        body: ErrorState(
          title: 'Template not found',
          description: 'This static template is not available in fixtures.',
        ),
      );
    }

    final theme = Theme.of(context);
    final tool = demoToolById(template.defaultToolId);

    return Scaffold(
      appBar: AppBar(title: Text(template.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AspectRatio(
              aspectRatio: 1.35,
              child: AppCard(
                color: template.accentColor.withValues(alpha: 0.12),
                child: Center(
                  child: Icon(
                    template.icon,
                    size: 68,
                    color: template.accentColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(template.title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              template.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(
                  label: template.badge,
                  icon: Icons.auto_awesome_outlined,
                ),
                if (tool != null) StatusChip(label: tool.name, icon: tool.icon),
              ],
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Required inputs'),
            const SizedBox(height: 8),
            for (final input in template.requiredInputs) ...[
              AppCard(
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(input, style: theme.textTheme.bodyLarge),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 10),
            CostPreviewCard(
              costLabel: 'Стоимость: от ${template.estimatedCost} койнов',
              reserveCopy: demoReserveCopy,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Use template',
              icon: Icons.auto_awesome,
              onPressed: () => context.go(AppRoutes.create),
            ),
          ],
        ),
      ),
    );
  }
}
