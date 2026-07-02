import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../fixtures/tool_fixtures.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tools')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Creative tools', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Static catalog preview. Real availability, costs and capabilities will be backend-driven.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const AppTextField(
              label: 'Search',
              hintText: 'Search tools, templates, formats',
            ),
            const SizedBox(height: 14),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(label: 'Photo', icon: Icons.image_outlined),
                StatusChip(
                  label: 'Video',
                  icon: Icons.video_camera_back_outlined,
                ),
                StatusChip(label: 'Upscale', icon: Icons.hd_outlined),
                StatusChip(
                  label: 'Avatars',
                  icon: Icons.person_search_outlined,
                ),
                StatusChip(
                  label: 'Motion',
                  icon: Icons.motion_photos_on_outlined,
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Models and tools'),
            const SizedBox(height: 8),
            for (final tool in demoTools) ...[
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
            const SectionHeader(title: 'Templates'),
            const SizedBox(height: 8),
            for (final template in demoTemplates) ...[
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
          ],
        ),
      ),
    );
  }
}
