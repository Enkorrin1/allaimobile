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
  AiModelCategory? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            final templates = _filterTemplates(catalog, query);
            final hasActiveFilters =
                query.isNotEmpty || _selectedCategory != null;
            final modelsById = {
              for (final model in catalog.models) model.id: model,
            };

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _CatalogHeader(
                  modelCount: catalog.models.length,
                  templateCount: catalog.templates.length,
                  fromCache: state.isFromCache || state.refreshError != null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Поиск',
                  hintText: 'Инструменты, шаблоны, форматы',
                  controller: _searchController,
                  prefixIcon: const Icon(Icons.search),
                  onChanged: (value) => setState(() => _query = value),
                  suffixIcon: _query.isEmpty
                      ? null
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('Все'),
                          selected: _selectedCategory == null,
                          onSelected: (_) =>
                              setState(() => _selectedCategory = null),
                        ),
                      ),
                      for (final mode in catalog.modes)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            avatar: Icon(
                              modelCategoryIcon(mode.category),
                              size: 18,
                            ),
                            label: Text(
                              mode.isEnabled
                                  ? mode.title
                                  : '${mode.title} скоро',
                            ),
                            selected: _selectedCategory == mode.category,
                            onSelected: mode.isEnabled
                                ? (_) => setState(
                                    () => _selectedCategory = mode.category,
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Модели и инструменты',
                  actionLabel: hasActiveFilters ? 'Сбросить' : null,
                  onActionPressed: hasActiveFilters
                      ? _resetSearchAndFilters
                      : null,
                ),
                const SizedBox(height: 8),
                if (models.isEmpty)
                  AppCard(
                    child: ErrorState(
                      title: 'Ничего не найдено',
                      description:
                          'Попробуйте другой запрос или сбросьте поиск.',
                      onRetry: hasActiveFilters ? _resetSearchAndFilters : null,
                      actionLabel: 'Сбросить фильтры',
                      actionIcon: Icons.filter_alt_off_outlined,
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
                  AppCard(
                    child: ErrorState(
                      title: 'Шаблоны не найдены',
                      description:
                          'Попробуйте другой запрос или откройте все инструменты.',
                      onRetry: hasActiveFilters ? _resetSearchAndFilters : null,
                      actionLabel: 'Сбросить фильтры',
                      actionIcon: Icons.filter_alt_off_outlined,
                    ),
                  )
                else
                  for (final template in templates) ...[
                    TemplateCard(
                      title: template.title,
                      badge: templateAvailabilityLabel(template),
                      description: template.description,
                      costLabel: costLabel(
                        modelsById[template.defaultModelId]?.cost ??
                            const CoinCost(minCoins: 0),
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
    return models.where((model) {
      if (_selectedCategory != null && model.category != _selectedCategory) {
        return false;
      }
      if (query.isEmpty) return true;
      return model.name.toLowerCase().contains(query) ||
          model.description.toLowerCase().contains(query) ||
          modelCategoryLabel(model.category).toLowerCase().contains(query);
    }).toList();
  }

  List<Template> _filterTemplates(CatalogResponse catalog, String query) {
    final modelsById = {for (final model in catalog.models) model.id: model};
    return catalog.templates.where((template) {
      final model = modelsById[template.defaultModelId];
      if (_selectedCategory != null && model?.category != _selectedCategory) {
        return false;
      }
      if (query.isEmpty) return true;
      return template.title.toLowerCase().contains(query) ||
          template.description.toLowerCase().contains(query) ||
          templateBadge(template).toLowerCase().contains(query);
    }).toList();
  }

  void _resetSearchAndFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategory = null;
    });
  }
}

class _CatalogHeader extends StatelessWidget {
  const _CatalogHeader({
    required this.modelCount,
    required this.templateCount,
    required this.fromCache,
  });

  final int modelCount;
  final int templateCount;
  final bool fromCache;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      borderColor: colorScheme.primary.withValues(alpha: 0.24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(label: '$modelCount моделей', icon: Icons.widgets),
              StatusChip(
                label: '$templateCount шаблонов',
                icon: Icons.auto_awesome_outlined,
              ),
              if (fromCache)
                const StatusChip(
                  label: 'Сохранённые данные',
                  icon: Icons.offline_pin_outlined,
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text('Каталог инструментов', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Выберите модель или готовый сценарий. Стоимость и доступность берутся из каталога.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
