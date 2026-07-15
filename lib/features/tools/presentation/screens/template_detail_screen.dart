import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/generated_asset_preview.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../billing/presentation/view_models/billing_copy.dart';
import '../../../favorites/presentation/providers/favorites_providers.dart';
import '../../domain/catalog_models.dart';
import '../providers/catalog_providers.dart';
import '../view_models/catalog_ui_mappers.dart';

class TemplateDetailScreen extends ConsumerWidget {
  const TemplateDetailScreen({required this.templateId, super.key});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogStateProvider);
    final favorites = ref.watch(favoritesControllerProvider);
    final isFavorite = favorites.hasTemplate(templateId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Шаблон'),
        actions: [
          IconButton(
            key: const Key('favorite-template-button'),
            tooltip: isFavorite
                ? context.l10n.favoritesRemove
                : context.l10n.favoritesAdd,
            onPressed: () => ref
                .read(favoritesControllerProvider.notifier)
                .toggleTemplate(templateId),
            icon: Icon(isFavorite ? Icons.bookmark : Icons.bookmark_border),
          ),
        ],
      ),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загружаем шаблон'),
          error: (error, stackTrace) => ErrorState(
            title: 'Шаблон недоступен',
            description: 'Не удалось загрузить данные каталога.',
            onRetry: () => ref.invalidate(catalogStateProvider),
          ),
          data: (state) {
            final catalog = state.catalog;
            final matches = catalog.templates.where(
              (template) => template.id == templateId,
            );
            if (matches.isEmpty) {
              return const ErrorState(
                title: 'Шаблон не найден',
                description: 'Такого шаблона нет в каталоге.',
              );
            }
            final template = matches.first;
            final modelMatches = catalog.models.where(
              (candidate) => candidate.id == template.defaultModelId,
            );
            if (modelMatches.isEmpty) {
              return const ErrorState(
                title: 'Шаблон временно недоступен',
                description: 'Для этого шаблона пока нет доступной модели.',
              );
            }
            final model = modelMatches.first;
            final canStart = template.isAvailable && model.isAvailable;
            final accentColor = templateColor(template.category);

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (state.isFromCache) ...[
                  const StatusChip(
                    label: 'Показываем сохранённые данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                  const SizedBox(height: 12),
                ],
                AspectRatio(
                  aspectRatio: 1.35,
                  child: AppCard(
                    padding: EdgeInsets.zero,
                    color: accentColor.withValues(alpha: 0.1),
                    borderColor: accentColor.withValues(alpha: 0.28),
                    child: GeneratedAssetPreview(
                      url: template.previewUrl,
                      isVideo: template.outputFormat.name == 'video',
                      fallbackIcon: templateIcon(template.category),
                      accentColor: accentColor,
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
                      label: templateAvailabilityLabel(template),
                      icon: Icons.auto_awesome_outlined,
                    ),
                    StatusChip(
                      label: model.name,
                      icon: modelCategoryIcon(model.category),
                    ),
                    StatusChip(
                      label: modelAvailabilityLabel(model),
                      icon: model.isAvailable
                          ? Icons.check_circle_outline
                          : Icons.schedule,
                    ),
                  ],
                ),
                if (!canStart) ...[
                  const SizedBox(height: 12),
                  AppCard(
                    borderColor: theme.colorScheme.error.withValues(alpha: 0.5),
                    child: Text(
                      template.isAvailable
                          ? modelAvailabilityDescription(model)
                          : 'Шаблон появится после обновления каталога.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                const SectionHeader(title: 'Что нужно от пользователя'),
                const SizedBox(height: 8),
                for (final input in template.requiredInputs) ...[
                  AppCard(
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            requiredInputLabel(input),
                            style: theme.textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                const SizedBox(height: 10),
                const SectionHeader(title: 'Стартовая идея'),
                const SizedBox(height: 8),
                AppCard(
                  child: Text(
                    template.defaultPrompt,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                CostPreviewCard(
                  costLabel: 'Стоимость: ${costLabel(model.cost)}',
                  reserveCopy: billingReserveCopy,
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: canStart ? 'Использовать шаблон' : 'Шаблон недоступен',
                  icon: Icons.auto_awesome,
                  fullWidth: true,
                  onPressed: canStart
                      ? () => context.go(
                          AppRoutes.createDraft(
                            format: model.category.wireValue,
                            modelId: model.id,
                            prompt: template.defaultPrompt,
                          ),
                        )
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
