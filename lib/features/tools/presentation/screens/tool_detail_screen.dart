import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../../billing/presentation/fixtures/billing_fixtures.dart';
import '../fixtures/tool_fixtures.dart';

class ToolDetailScreen extends StatelessWidget {
  const ToolDetailScreen({required this.toolId, super.key});

  final String toolId;

  @override
  Widget build(BuildContext context) {
    final tool = demoToolById(toolId);
    if (tool == null) {
      return const Scaffold(
        body: ErrorState(
          title: 'Tool not found',
          description: 'This static catalog item is not available in fixtures.',
        ),
      );
    }

    final theme = Theme.of(context);
    final templates = demoTemplates
        .where((template) => template.defaultToolId == tool.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(tool.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: tool.accentColor.withValues(alpha: 0.12),
                    foregroundColor: tool.accentColor,
                    child: Icon(tool.icon, size: 30),
                  ),
                  const SizedBox(height: 14),
                  Text(tool.name, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    tool.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatusChip(label: tool.category, icon: tool.icon),
                      StatusChip(
                        label: tool.outputType,
                        icon: Icons.outbox_outlined,
                      ),
                      StatusChip(
                        label: tool.available ? 'Ready' : 'Soon',
                        icon: tool.available
                            ? Icons.check_circle_outline
                            : Icons.schedule,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Inputs'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final input in tool.supportedInputs)
                  StatusChip(label: input, icon: Icons.input_outlined),
              ],
            ),
            const SizedBox(height: 18),
            CostPreviewCard(
              costLabel: 'Стоимость: от ${tool.estimatedCost} койнов',
              reserveCopy: demoReserveCopy,
            ),
            const SizedBox(height: 18),
            AppButton(
              label: 'Use in Create',
              icon: Icons.auto_awesome,
              onPressed: () => context.go(AppRoutes.create),
            ),
            if (templates.isNotEmpty) ...[
              const SizedBox(height: 22),
              const SectionHeader(title: 'Templates for this tool'),
              const SizedBox(height: 8),
              for (final template in templates) ...[
                TemplateCard(
                  title: template.title,
                  badge: template.badge,
                  description: template.description,
                  costLabel: 'от ${template.estimatedCost} койнов',
                  icon: template.icon,
                  accentColor: template.accentColor,
                  onTap: () =>
                      context.go(AppRoutes.templateDetail(template.id)),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
