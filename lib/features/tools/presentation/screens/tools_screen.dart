import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../domain/catalog_models.dart';
import '../providers/catalog_providers.dart';
import '../view_models/catalog_ui_mappers.dart';

class ToolsScreen extends ConsumerStatefulWidget {
  const ToolsScreen({super.key});

  @override
  ConsumerState<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends ConsumerState<ToolsScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Инструменты')),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загружаем каталог...'),
          error: (error, stackTrace) => ErrorState(
            title: 'Не удалось загрузить каталог',
            description:
                'Проверьте подключение или попробуйте обновить данные позже.',
            onRetry: () => ref.invalidate(catalogStateProvider),
          ),
          data: (state) {
            final catalog = state.catalog;
            if (state.isEmpty) {
              return ErrorState(
                title: 'Каталог пока пуст',
                description:
                    'Инструменты и шаблоны появятся после обновления данных.',
                onRetry: () => ref.invalidate(catalogStateProvider),
              );
            }

            final query = _query.trim().toLowerCase();
            final models = _filterModels(catalog.models, query);
            final templates = _filterTemplates(catalog.templates, query);

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Каталог инструментов',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Выберите модель или готовый сценарий. Стоимость и доступность берутся из каталога.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (state.isFromCache || state.refreshError != null) ...[
                  const SizedBox(height: 12),
                  StatusChip(
                    label: state.refreshError == null
                        ? 'Показываем сохраненные данные'
                        : 'Показываем сохраненные данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                ],
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Поиск',
                  hintText: 'Инструменты, шаблоны, форматы',
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  suffixIcon: _query.isEmpty
                      ? const Icon(Icons.search)
                      : IconButton(
                          tooltip: 'Сбросить поиск',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(Icons.close),
                        ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final mode in catalog.modes)
                      StatusChip(
                        label: mode.isEnabled
                            ? mode.title
                            : '${mode.title} скоро',
                        icon: modelCategoryIcon(mode.category),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Модели и инструменты'),
                const SizedBox(height: 8),
                if (models.isEmpty)
                  const AppCard(
                    child: ErrorState(
                      title: 'Ничего не найдено',
                      description:
                          'Попробуйте другой запрос или сбросьте поиск.',
                    ),
                  )
                else
                  for (final model in models) ...[
                    ModelCard(
                      name: model.name,
                      category: modelCategoryLabel(model.category),
                      description: model.description,
                      costLabel: costLabel(model.cost),
                      icon: modelCategoryIcon(model.category),
                      accentColor: modelCategoryColor(model.category),
                      available: model.isAvailable,
                      availabilityLabel: modelAvailabilityLabel(model),
                      availabilityDescription: model.isAvailable
                          ? null
                          : modelAvailabilityDescription(model),
                      onTap: () => context.push(AppRoutes.toolDetail(model.id)),
                    ),
                    const SizedBox(height: 12),
                  ],
                const SizedBox(height: 10),
                const SectionHeader(title: 'Шаблоны'),
                const SizedBox(height: 8),
                if (templates.isEmpty)
                  const AppCard(
                    child: ErrorState(
                      title: 'Шаблоны не найдены',
                      description:
                          'Попробуйте другой запрос или откройте все инструменты.',
                    ),
                  )
                else
                  for (final template in templates) ...[
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
              ],
            );
          },
        ),
      ),
    );
  }

  List<AiModel> _filterModels(List<AiModel> models, String query) {
    if (query.isEmpty) return models;
    return models.where((model) {
      return model.name.toLowerCase().contains(query) ||
          model.description.toLowerCase().contains(query) ||
          modelCategoryLabel(model.category).toLowerCase().contains(query);
    }).toList();
  }

  List<Template> _filterTemplates(List<Template> templates, String query) {
    if (query.isEmpty) return templates;
    return templates.where((template) {
      return template.title.toLowerCase().contains(query) ||
          template.description.toLowerCase().contains(query) ||
          templateBadge(template).toLowerCase().contains(query);
    }).toList();
  }
}
