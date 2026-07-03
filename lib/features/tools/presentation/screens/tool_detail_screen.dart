import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../../billing/presentation/view_models/billing_copy.dart';
import '../providers/catalog_providers.dart';
import '../view_models/catalog_ui_mappers.dart';

class ToolDetailScreen extends ConsumerWidget {
  const ToolDetailScreen({required this.toolId, super.key});

  final String toolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Инструмент')),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загружаем инструмент'),
          error: (error, stackTrace) => ErrorState(
            title: 'Инструмент недоступен',
            description: 'Не удалось загрузить данные каталога.',
            onRetry: () => ref.invalidate(catalogStateProvider),
          ),
          data: (state) {
            final catalog = state.catalog;
            final matches = catalog.models.where((model) => model.id == toolId);
            if (matches.isEmpty) {
              return const ErrorState(
                title: 'Инструмент не найден',
                description: 'Такого инструмента нет в каталоге.',
              );
            }
            final model = matches.first;
            final templates = catalog.templates
                .where((template) => template.defaultModelId == model.id)
                .toList();

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.isFromCache) ...[
                  const StatusChip(
                    label: 'Показываем сохраненные данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                  const SizedBox(height: 12),
                ],
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: modelCategoryColor(
                          model.category,
                        ).withValues(alpha: 0.12),
                        foregroundColor: modelCategoryColor(model.category),
                        child: Icon(
                          modelCategoryIcon(model.category),
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(model.name, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text(
                        model.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          StatusChip(
                            label: modelCategoryLabel(model.category),
                            icon: modelCategoryIcon(model.category),
                          ),
                          StatusChip(
                            label: model.supportedOutputs
                                .map(supportedOutputLabel)
                                .join(', '),
                            icon: Icons.outbox_outlined,
                          ),
                          StatusChip(
                            label: modelAvailabilityLabel(model),
                            icon: model.isAvailable
                                ? Icons.check_circle_outline
                                : Icons.schedule,
                          ),
                        ],
                      ),
                      if (!model.isAvailable) ...[
                        const SizedBox(height: 12),
                        Text(
                          modelAvailabilityDescription(model),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SectionHeader(title: 'Входные данные'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final input in model.supportedInputs)
                      StatusChip(
                        label: supportedInputLabel(input),
                        icon: Icons.input_outlined,
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                CostPreviewCard(
                  costLabel: 'Стоимость: ${costLabel(model.cost)}',
                  reserveCopy: billingReserveCopy,
                ),
                const SizedBox(height: 18),
                AppButton(
                  label: model.isAvailable
                      ? 'Использовать при создании'
                      : 'Модель пока недоступна',
                  icon: Icons.auto_awesome,
                  onPressed: model.isAvailable
                      ? () => context.go(AppRoutes.create)
                      : null,
                ),
                if (templates.isNotEmpty) ...[
                  const SizedBox(height: 22),
                  const SectionHeader(title: 'Шаблоны для инструмента'),
                  const SizedBox(height: 8),
                  for (final template in templates) ...[
                    TemplateCard(
                      title: template.title,
                      badge: templateAvailabilityLabel(template),
                      description: template.description,
                      costLabel: costLabel(model.cost),
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
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
