import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/fixtures/billing_fixtures.dart';
import '../../../../features/generator/presentation/fixtures/generator_fixtures.dart';
import '../../../../features/library/presentation/fixtures/library_fixtures.dart';
import '../../../../features/tools/presentation/fixtures/tool_fixtures.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/generation_mode_selector.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../../../shared/widgets/upload_placeholder.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  String _selectedModeId = demoGenerationModes.first.id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedMode = demoGenerationModes.firstWhere(
      (mode) => mode.id == _selectedModeId,
    );
    final modeOptions = demoGenerationModes
        .map(
          (mode) => GenerationModeOption(
            id: mode.id,
            label: mode.label,
            icon: mode.icon,
            description: mode.description,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
        actions: [
          IconButton(
            tooltip: 'Open tools',
            onPressed: () => context.go(AppRoutes.tools),
            icon: const Icon(Icons.widgets_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Start a generation', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Phase 2 uses static inputs and mock pricing. Backend quotes and jobs arrive later.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 18),
            GenerationModeSelector(
              options: modeOptions,
              selectedId: _selectedModeId,
              onSelected: (id) => setState(() => _selectedModeId = id),
            ),
            const SizedBox(height: 10),
            AppCard(
              child: Row(
                children: [
                  Icon(selectedMode.icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${selectedMode.label}: от ${selectedMode.estimatedCost} койнов',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Prompt',
              hintText:
                  'Describe product, audience, scene, style, camera or movement.',
              minLines: 4,
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            const UploadPlaceholder(
              title: 'Upload source',
              description:
                  'Mock upload slot. Signed upload URLs will be added with backend integration.',
            ),
            const SizedBox(height: 20),
            SectionHeader(
              title: 'Model',
              actionLabel: 'Tools',
              onActionPressed: () => context.go(AppRoutes.tools),
            ),
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
            const SizedBox(height: 8),
            const SectionHeader(title: 'Template starter'),
            const SizedBox(height: 8),
            for (final template in demoTemplates.take(2)) ...[
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
            const SizedBox(height: 8),
            const SectionHeader(title: 'Advanced settings'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final setting in demoAdvancedSettings)
                  StatusChip(label: setting, icon: Icons.tune),
              ],
            ),
            const SizedBox(height: 18),
            CostPreviewCard(
              costLabel: demoCostLabel,
              reserveCopy: demoReserveCopy,
            ),
            const SizedBox(height: 20),
            AppButton(
              label: 'Open mock result',
              icon: Icons.auto_awesome,
              onPressed: () =>
                  context.go(AppRoutes.result(demoLibraryAssets.first.id)),
            ),
          ],
        ),
      ),
    );
  }
}
