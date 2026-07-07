import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/providers/billing_providers.dart';
import '../../../../features/billing/presentation/view_models/billing_copy.dart';
import '../../../../features/generation_jobs/domain/generation_job_models.dart';
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
  final _promptController = TextEditingController();
  String? _selectedModeId;
  String _prompt = '';
  String? _promptError;
  bool _restoreRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _restoreRequested) return;
      _restoreRequested = true;
      ref
          .read(generationJobControllerProvider.notifier)
          .restoreLatestActiveJob();
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final catalogAsync = ref.watch(catalogStateProvider);
    final balanceAsync = ref.watch(balanceStateProvider);
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
            final imageModes = catalog.modes
                .where(
                  (mode) =>
                      mode.isEnabled && mode.category == AiModelCategory.image,
                )
                .toList();
            final imageModels = catalog.models.where(_isImageCapable).toList();
            final availableImageModels = imageModels
                .where((model) => model.isAvailable)
                .toList();

            if (imageModes.isEmpty || availableImageModels.isEmpty) {
              return ErrorState(
                title: 'Нет доступных моделей для фото',
                description:
                    'Модели появятся после обновления каталога. Попробуйте позже.',
                onRetry: () => ref.invalidate(catalogStateProvider),
              );
            }

            final selectedModeId =
                imageModes.any((mode) => mode.id == _selectedModeId)
                ? _selectedModeId!
                : imageModes.first.id;
            final selectedMode = imageModes.firstWhere(
              (mode) => mode.id == selectedModeId,
            );
            final selectedModel = _selectModelForMode(catalog, selectedMode);
            final selectedTemplates = selectedModel == null
                ? <Template>[]
                : _templatesForModel(catalog, selectedModel);
            final selectedTemplate = selectedTemplates.isEmpty
                ? null
                : selectedTemplates.first;
            final balance = balanceAsync.asData?.value.data;
            final availableCoins = balance?.availableCoins;
            final generationCost = selectedModel?.cost.minCoins ?? 0;
            final disabledReason = _disabledReason(
              model: selectedModel,
              template: selectedTemplate,
              generationCost: generationCost,
              availableCoins: availableCoins,
              balanceIsLoading: balanceAsync.isLoading,
              prompt: _prompt,
            );
            final canSubmit = !jobState.isLoading && disabledReason == null;
            final aspectRatio =
                selectedTemplate?.targetAspectRatio ??
                selectedModel?.capabilities.aspectRatios?.first ??
                '9:16';
            final modeOptions = imageModes
                .map(
                  (mode) => GenerationModeOption(
                    id: mode.id,
                    label: mode.title,
                    icon: modelCategoryIcon(mode.category),
                    description: 'Только описание',
                  ),
                )
                .toList();

            return ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                16,
                12,
                16,
                24 + MediaQuery.viewInsetsOf(context).bottom,
              ),
              children: [
                if (state.isFromCache) ...[
                  const StatusChip(
                    label: 'Показываем сохранённые данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                  const SizedBox(height: 12),
                ],
                _CreateHeader(
                  availableCoins: availableCoins,
                  selectedModelName: selectedModel?.name ?? 'модель недоступна',
                  selectedTemplateTitle: selectedTemplate?.title,
                ),
                const SizedBox(height: 18),
                const SectionHeader(title: 'Формат'),
                const SizedBox(height: 8),
                GenerationModeSelector(
                  options: modeOptions,
                  selectedId: selectedModeId,
                  onSelected: (id) => setState(() => _selectedModeId = id),
                ),
                const SizedBox(height: 18),
                const SectionHeader(title: 'Описание'),
                const SizedBox(height: 8),
                AppTextField(
                  label: 'Промпт',
                  hintText:
                      'Например: чистый рекламный кадр продукта на светлом фоне, мягкий свет, формат 4:5.',
                  controller: _promptController,
                  minLines: 4,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  errorText: _promptError,
                  prefixIcon: const Icon(Icons.edit_outlined),
                  onChanged: (value) {
                    setState(() {
                      _prompt = value;
                      if (_promptError != null) _promptError = null;
                    });
                  },
                ),
                const SizedBox(height: 12),
                const UploadPlaceholder(
                  title: 'Референс-изображение',
                  description:
                      'Загрузка изображения появится в следующем обновлении. Сейчас доступна генерация по описанию.',
                ),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Модель',
                  actionLabel: 'Инструменты',
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 8),
                if (selectedModel != null)
                  ModelCard(
                    name: selectedModel.name,
                    category: modelCategoryLabel(selectedModel.category),
                    description: selectedModel.description,
                    costLabel: costLabel(selectedModel.cost),
                    icon: modelCategoryIcon(selectedModel.category),
                    accentColor: modelCategoryColor(selectedModel.category),
                    available: selectedModel.isAvailable,
                    availabilityLabel: modelAvailabilityLabel(selectedModel),
                    availabilityDescription: selectedModel.isAvailable
                        ? null
                        : modelAvailabilityDescription(selectedModel),
                    onTap: () =>
                        context.push(AppRoutes.toolDetail(selectedModel.id)),
                  ),
                const SizedBox(height: 16),
                const SectionHeader(title: 'Стартовый шаблон'),
                const SizedBox(height: 8),
                if (selectedTemplates.isEmpty)
                  const AppCard(
                    child: Text(
                      'Для выбранной модели пока нет доступного фото-шаблона.',
                    ),
                  )
                else
                  for (final template in selectedTemplates.take(2)) ...[
                    TemplateCard(
                      title: template.title,
                      badge: templateAvailabilityLabel(template),
                      description: template.description,
                      costLabel: costLabel(selectedModel!.cost),
                      icon: templateIcon(template.category),
                      accentColor: templateColor(template.category),
                      onTap: () =>
                          context.push(AppRoutes.templateDetail(template.id)),
                    ),
                    const SizedBox(height: 12),
                  ],
                const SizedBox(height: 8),
                const SectionHeader(title: 'Настройки'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    StatusChip(label: 'Формат $aspectRatio', icon: Icons.tune),
                    const StatusChip(
                      label: 'По описанию',
                      icon: Icons.edit_outlined,
                    ),
                    const StatusChip(
                      label: 'Референс скоро',
                      icon: Icons.lock_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                CostPreviewCard(
                  costLabel: 'Стоимость: ${formatCoins(generationCost)} койнов',
                  reserveCopy:
                      'Доступно: ${availableCoins == null ? 'загружаем баланс' : formatCoins(availableCoins)}. $billingReserveCopy',
                  warning: disabledReason,
                ),
                if (_promptError != null) ...[
                  const SizedBox(height: 12),
                  AppCard(
                    child: Text(
                      _promptError!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _JobStateCard(
                  state: jobState,
                  onOpenResult: (response) => _openResult(context, response),
                  onRetry: (job) async {
                    final response = await ref
                        .read(generationJobControllerProvider.notifier)
                        .retryJob(job);
                    if (!context.mounted || response == null) return;
                    _openResult(context, response);
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  label: jobState.isLoading
                      ? 'Создаём задачу'
                      : 'Запустить генерацию',
                  icon: Icons.auto_awesome,
                  fullWidth: true,
                  onPressed: canSubmit
                      ? () async {
                          final prompt = _promptController.text.trim();
                          if (prompt.isEmpty) {
                            setState(
                              () => _promptError =
                                  'Добавьте описание изображения',
                            );
                            return;
                          }

                          final response = await ref
                              .read(generationJobControllerProvider.notifier)
                              .createPromptOnlyJob(
                                modelId: selectedModel!.id,
                                templateId: selectedTemplate?.id,
                                prompt: prompt,
                                settings: {'aspectRatio': aspectRatio},
                              );
                          if (!context.mounted || response == null) return;
                          _openResult(context, response);
                        }
                      : null,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  AiModel? _selectModelForMode(CatalogResponse catalog, GenerationMode mode) {
    final matchingModels = catalog.models.where(
      (model) => model.category == mode.category && _isImageCapable(model),
    );
    final available = matchingModels.where((model) => model.isAvailable);
    if (available.isNotEmpty) return available.first;
    return matchingModels.isEmpty ? null : matchingModels.first;
  }

  List<Template> _templatesForModel(CatalogResponse catalog, AiModel model) {
    return catalog.templates
        .where(
          (template) =>
              template.defaultModelId == model.id &&
              template.isAvailable &&
              template.outputFormat == OutputFormat.image,
        )
        .toList();
  }

  bool _isImageCapable(AiModel model) {
    return model.supportedOutputs.contains(SupportedOutput.image) &&
        model.category == AiModelCategory.image;
  }

  String? _disabledReason({
    required AiModel? model,
    required Template? template,
    required int generationCost,
    required int? availableCoins,
    required bool balanceIsLoading,
    required String prompt,
  }) {
    if (prompt.trim().isEmpty) return 'Добавьте описание изображения';
    if (model == null) return 'Нет доступной модели для изображения.';
    if (!model.isAvailable) return modelAvailabilityDescription(model);
    if (template == null) {
      return 'Для выбранной модели пока нет доступного фото-шаблона.';
    }
    if (availableCoins == null) {
      return balanceIsLoading
          ? 'Загружаем баланс.'
          : 'Баланс временно недоступен.';
    }
    if (generationCost > availableCoins) {
      return insufficientCoinsQuoteCopy(
        cost: generationCost,
        available: availableCoins,
      );
    }
    return null;
  }

  void _openResult(BuildContext context, GenerationJobResponse response) {
    if (response.job.status != GenerationJobStatus.completed ||
        response.assets.isEmpty) {
      return;
    }
    context.push(AppRoutes.result(response.assets.first.id));
  }
}

class _CreateHeader extends StatelessWidget {
  const _CreateHeader({
    required this.availableCoins,
    required this.selectedModelName,
    this.selectedTemplateTitle,
  });

  final int? availableCoins;
  final String selectedModelName;
  final String? selectedTemplateTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      color: colorScheme.surface,
      borderColor: colorScheme.primary.withValues(alpha: 0.24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatusChip(
                label: availableCoins == null
                    ? 'Доступно: загружаем'
                    : 'Доступно: ${formatCoins(availableCoins!)}',
                icon: Icons.toll,
              ),
              StatusChip(label: selectedModelName, icon: Icons.image_outlined),
            ],
          ),
          const SizedBox(height: 14),
          Text('Новая генерация', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            selectedTemplateTitle == null
                ? 'Опишите изображение, проверьте стоимость и запустите задачу.'
                : 'Шаблон: $selectedTemplateTitle. Описание можно уточнить перед запуском.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _JobStateCard extends StatelessWidget {
  const _JobStateCard({
    required this.state,
    required this.onOpenResult,
    required this.onRetry,
  });

  final AsyncValue<GenerationJobResponse?> state;
  final ValueChanged<GenerationJobResponse> onOpenResult;
  final ValueChanged<GenerationJob> onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const AppCard(
        child: Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Expanded(child: Text('Создаём задачу')),
          ],
        ),
      );
    }

    if (state.hasError) {
      return AppCard(
        child: Text(
          generationErrorCopy(state.error!),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    final response = state.asData?.value;
    if (response == null) return const SizedBox.shrink();

    final job = response.job;
    final progress = job.progress?.clamp(0.0, 1.0).toDouble();
    final isFailed = job.status == GenerationJobStatus.failed;
    final isCompleted = job.status == GenerationJobStatus.completed;

    return AppCard(
      borderColor: isFailed
          ? theme.colorScheme.error.withValues(alpha: 0.55)
          : theme.colorScheme.primary.withValues(alpha: 0.28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFailed ? Icons.error_outline : Icons.auto_awesome,
                color: isFailed
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  generationProgressLabel(job.status),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: isCompleted ? 1 : progress),
          if (isFailed) ...[
            const SizedBox(height: 12),
            Text(
              'Генерация не завершилась. Настройки сохранены.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              job.costCoins > 0
                  ? 'Коины возвращены на баланс.'
                  : 'Списание не выполнено.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            AppButton(
              label: 'Повторить с теми же настройками',
              icon: Icons.refresh,
              secondary: true,
              onPressed: () => onRetry(job),
            ),
          ] else if (isCompleted && response.assets.isNotEmpty) ...[
            const SizedBox(height: 12),
            AppButton(
              label: 'Открыть результат',
              icon: Icons.open_in_new,
              secondary: true,
              onPressed: () => onOpenResult(response),
            ),
          ],
        ],
      ),
    );
  }
}
