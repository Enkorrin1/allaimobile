import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/view_models/billing_copy.dart';
import '../../../../features/generation_jobs/presentation/providers/generation_job_providers.dart';
import '../../../../features/tools/domain/catalog_models.dart';
import '../../../../features/tools/presentation/providers/catalog_providers.dart';
import '../../../../features/tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/generation_mode_selector.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';
import '../../../../shared/widgets/upload_placeholder.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({super.key});

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  String? _selectedModeId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogStateProvider);
    final jobState = ref.watch(generationJobControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать'),
        actions: [
          IconButton(
            tooltip: 'Открыть инструменты',
            onPressed: () => context.push(AppRoutes.tools),
            icon: const Icon(Icons.widgets_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загружаем форму'),
          error: (error, stackTrace) => ErrorState(
            title: 'Форма недоступна',
            description: 'Не удалось загрузить каталог для создания.',
            onRetry: () => ref.invalidate(catalogStateProvider),
          ),
          data: (state) {
            final catalog = state.catalog;
            final enabledModes = catalog.modes
                .where((mode) => mode.isEnabled)
                .toList();
            final availableModels = catalog.models
                .where((model) => model.isAvailable)
                .toList();
            if (enabledModes.isEmpty || availableModels.isEmpty) {
              return ErrorState(
                title: 'Нет доступных моделей',
                description:
                    'Модели появятся после обновления каталога. Попробуйте позже.',
                onRetry: () => ref.invalidate(catalogStateProvider),
              );
            }

            final selectedModeId = _selectedModeId ?? enabledModes.first.id;
            final selectedMode = catalog.modes.firstWhere(
              (mode) => mode.id == selectedModeId,
              orElse: () => enabledModes.first,
            );
            final selectedModel = _selectModelForMode(catalog, selectedMode);
            final selectedTemplate = catalog.templates.firstWhere(
              (template) =>
                  template.defaultModelId == selectedModel.id &&
                  template.isAvailable,
              orElse: () => catalog.templates.first,
            );
            final modeOptions = catalog.modes
                .map(
                  (mode) => GenerationModeOption(
                    id: mode.id,
                    label: mode.title,
                    icon: modelCategoryIcon(mode.category),
                    description: mode.isEnabled ? 'Доступно' : 'Скоро',
                  ),
                )
                .toList();

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              children: [
                if (state.isFromCache) ...[
                  const StatusChip(
                    label: 'Показываем сохраненные данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                  const SizedBox(height: 12),
                ],
                Text('Новая генерация', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Выберите режим, опишите задачу и проверьте стоимость перед запуском.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                GenerationModeSelector(
                  options: modeOptions,
                  selectedId: selectedModeId,
                  onSelected: (id) {
                    final mode = catalog.modes.firstWhere(
                      (candidate) => candidate.id == id,
                    );
                    if (mode.isEnabled) setState(() => _selectedModeId = id);
                  },
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: Row(
                    children: [
                      Icon(
                        modelCategoryIcon(selectedMode.category),
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${selectedMode.title}: ${costLabel(selectedModel.cost)}',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const AppTextField(
                  label: 'Промпт',
                  hintText:
                      'Опишите продукт, аудиторию, сцену, стиль, камеру или движение.',
                  minLines: 4,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 16),
                const UploadPlaceholder(
                  title: 'Загрузить источник',
                  description:
                      'Слот для медиа. Загрузка файлов будет подключена после серверного решения.',
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Модель',
                  actionLabel: 'Инструменты',
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 8),
                for (final model in catalog.models.take(2)) ...[
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
                const SizedBox(height: 8),
                const SectionHeader(title: 'Стартовый шаблон'),
                const SizedBox(height: 8),
                for (final template in catalog.templates.take(2)) ...[
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
                const SizedBox(height: 8),
                const SectionHeader(title: 'Настройки'),
                const SizedBox(height: 8),
                const Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusChip(label: 'Формат 9:16', icon: Icons.tune),
                    StatusChip(label: 'Высокое качество', icon: Icons.tune),
                    StatusChip(label: 'Коммерческий стиль', icon: Icons.tune),
                    StatusChip(
                      label: 'Уведомить о готовности',
                      icon: Icons.tune,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                CostPreviewCard(
                  costLabel: 'Стоимость: ${costLabel(selectedModel.cost)}',
                  reserveCopy: billingReserveCopy,
                  warning: jobState.hasError ? insufficientCoinsCopy : null,
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: jobState.isLoading
                      ? 'Запускаем задачу'
                      : 'Запустить демо-результат',
                  icon: Icons.auto_awesome,
                  onPressed: jobState.isLoading
                      ? null
                      : () async {
                          final response = await ref
                              .read(generationJobControllerProvider.notifier)
                              .createMockJob(
                                modelId: selectedModel.id,
                                templateId: selectedTemplate.id,
                                prompt: selectedTemplate.defaultPrompt,
                              );
                          if (!context.mounted || response == null) return;
                          final targetId = response.assets.isNotEmpty
                              ? response.assets.first.id
                              : response.job.id;
                          context.push(AppRoutes.result(targetId));
                        },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  AiModel _selectModelForMode(CatalogResponse catalog, GenerationMode mode) {
    final matches = catalog.models.where(
      (model) => model.category == mode.category && model.isAvailable,
    );
    if (matches.isNotEmpty) return matches.first;
    return catalog.models.firstWhere((model) => model.isAvailable);
  }
}
