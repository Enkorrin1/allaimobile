import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/placeholder_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../../tools/presentation/providers/catalog_providers.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';

class StudioScreen extends ConsumerWidget {
  const StudioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Студия')),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загрузка студии'),
          error: (error, stackTrace) => const ErrorState(
            title: 'Студия недоступна',
            description: 'Не удалось загрузить шаблоны студии.',
          ),
          data: (catalog) {
            final socialTemplates = catalog.templates
                .where(
                  (template) =>
                      template.id == 'product-ugc-hook' ||
                      template.id == 'social-hook-cut' ||
                      template.id == 'ugc',
                )
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Студия соцконтента',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Готовьте ассеты для соцсетей, подписи и пакеты экспорта до появления прямой публикации.',
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
                          '3 стартовых сценария готовы для TikTok, Reels и Shorts.',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const SectionHeader(title: 'Шаблоны для соцсетей'),
                const SizedBox(height: 8),
                for (final template in socialTemplates) ...[
                  TemplateCard(
                    title: template.title,
                    badge: templateAvailabilityLabel(template),
                    description: template.description,
                    costLabel: costLabel(
                      catalog.models
                          .firstWhere(
                            (model) => model.id == template.defaultModelId,
                          )
                          .cost,
                    ),
                    icon: templateIcon(template.category),
                    accentColor: templateColor(template.category),
                    onTap: template.isAvailable
                        ? () => context.push(
                            AppRoutes.templateDetail(template.id),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 10),
                const PlaceholderCard(
                  icon: Icons.dashboard_customize_outlined,
                  title: 'Черновики',
                  description:
                      'Сценарии для TikTok, YouTube Shorts, Pinterest и Reels появятся после MVP-генерации.',
                ),
                const SizedBox(height: 12),
                const PlaceholderCard(
                  icon: Icons.inventory_2_outlined,
                  title: 'Пакет экспорта',
                  description:
                      'Сохраняйте подписи, промпты и готовые ассеты вместе для публикации.',
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: 'Создать ассет',
                  icon: Icons.auto_awesome,
                  onPressed: () => context.go(AppRoutes.create),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
