import 'package:cached_network_image/cached_network_image.dart';
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
import '../../../../shared/widgets/neon_media_card.dart';

class GeneratorScreen extends ConsumerStatefulWidget {
  const GeneratorScreen({
    this.initialCategory = AiModelCategory.video,
    super.key,
  });

  final AiModelCategory initialCategory;

  @override
  ConsumerState<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends ConsumerState<GeneratorScreen> {
  final _promptController = TextEditingController();
  String _prompt = '';
  bool _restoreRequested = false;
  AiModelCategory _selectedCategory = AiModelCategory.video;
  String? _selectedModelId;

  static const _suggestions = [
    'Futuristic walk of her',
    'Majestic baby tiger walk',
    'Tiny dragon flying',
    'Cinematic product reveal',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _restoreRequested) return;
      _restoreRequested = true;
      ref
          .read(generationJobControllerProvider.notifier)
          .restoreLatestActiveJob();
    });
  }

  @override
  void didUpdateWidget(covariant GeneratorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      setState(() {
        _selectedCategory = widget.initialCategory;
        _selectedModelId = null;
      });
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogStateProvider);
    final balanceAsync = ref.watch(balanceStateProvider);
    final jobState = ref.watch(generationJobControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const _ComposerLoading(),
          error: (error, stackTrace) => _ComposerError(
            title: 'Generator unavailable',
            description: 'Could not load creation tools. Try again.',
            onRetry: () => ref.invalidate(catalogStateProvider),
          ),
          data: (state) {
            final catalog = state.catalog;
            final visibleModels = _modelsForCategory(
              catalog,
              _selectedCategory,
            );
            final selectedModel = _selectedModel(visibleModels);

            if (selectedModel == null) {
              return _ComposerError(
                title: 'No generator available',
                description:
                    'Creation models will appear after catalog update.',
                onRetry: () => ref.invalidate(catalogStateProvider),
              );
            }

            final selectedTemplate = _templateForModel(catalog, selectedModel);
            final generationCost = selectedModel.cost.minCoins;
            final availableCoins =
                balanceAsync.asData?.value.data.availableCoins;
            final disabledReason = _disabledReason(
              model: selectedModel,
              generationCost: generationCost,
              availableCoins: availableCoins,
              balanceIsLoading: balanceAsync.isLoading,
              prompt: _prompt,
            );
            final canSubmit = !jobState.isLoading && disabledReason == null;

            return _VideoComposer(
              controller: _promptController,
              prompt: _prompt,
              modes: catalog.modes,
              selectedCategory: _selectedCategory,
              models: visibleModels,
              selectedModel: selectedModel,
              suggestions: _suggestions,
              disabledReason: disabledReason,
              showDisabledReason:
                  _prompt.trim().isNotEmpty || disabledReason == null,
              jobState: jobState,
              availableCoins: availableCoins,
              generationCost: generationCost,
              canSubmit: canSubmit,
              onClose: () => context.go(AppRoutes.home),
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  _selectedModelId = null;
                });
              },
              onModelSelected: (model) {
                setState(() => _selectedModelId = model.id);
              },
              onPromptChanged: (value) => setState(() => _prompt = value),
              onSuggestionSelected: (suggestion) {
                _promptController.text = suggestion;
                _promptController.selection = TextSelection.collapsed(
                  offset: suggestion.length,
                );
                setState(() => _prompt = suggestion);
              },
              onAddImage: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image upload will be connected later.'),
                  ),
                );
              },
              onRetry: (job) async {
                final response = await ref
                    .read(generationJobControllerProvider.notifier)
                    .retryJob(job);
                if (!context.mounted || response == null) return;
                _openResult(context, response);
              },
              onGenerate: canSubmit
                  ? () async {
                      final prompt = _promptController.text.trim();
                      if (prompt.isEmpty) return;

                      final response = await ref
                          .read(generationJobControllerProvider.notifier)
                          .createPromptOnlyJob(
                            modelId: selectedModel.id,
                            templateId: selectedTemplate?.id,
                            prompt: prompt,
                            settings: const {'aspectRatio': '9:16'},
                          );

                      if (!context.mounted || response == null) return;
                      _openResult(context, response);
                    }
                  : null,
            );
          },
        ),
      ),
    );
  }

  List<AiModel> _modelsForCategory(
    CatalogResponse catalog,
    AiModelCategory category,
  ) {
    return catalog.models.where((model) => model.category == category).toList();
  }

  AiModel? _selectedModel(List<AiModel> models) {
    if (models.isEmpty) return null;
    if (_selectedModelId == null) return models.first;
    return models.firstWhere(
      (model) => model.id == _selectedModelId,
      orElse: () => models.first,
    );
  }

  Template? _templateForModel(CatalogResponse catalog, AiModel model) {
    final outputFormat = model.supportedOutputs.contains(SupportedOutput.video)
        ? OutputFormat.video
        : OutputFormat.image;
    final templates = catalog.templates
        .where(
          (template) =>
              template.defaultModelId == model.id &&
              template.isAvailable &&
              template.outputFormat == outputFormat,
        )
        .toList();
    return templates.isEmpty ? null : templates.first;
  }

  String? _disabledReason({
    required AiModel model,
    required int generationCost,
    required int? availableCoins,
    required bool balanceIsLoading,
    required String prompt,
  }) {
    if (prompt.trim().isEmpty) return _emptyPromptCopy(model.category);
    if (!model.isAvailable) return modelAvailabilityDescription(model);
    if (availableCoins == null) {
      return balanceIsLoading
          ? 'Loading balance...'
          : 'Balance is temporarily unavailable.';
    }
    if (generationCost > availableCoins) {
      return insufficientCoinsQuoteCopy(
        cost: generationCost,
        available: availableCoins,
      );
    }
    return null;
  }

  String _emptyPromptCopy(AiModelCategory category) => switch (category) {
    AiModelCategory.image => 'Describe an image to generate.',
    AiModelCategory.video => 'Describe a video to generate.',
    AiModelCategory.upscale => 'Describe what needs better quality.',
    AiModelCategory.avatar => 'Describe the avatar scene.',
    AiModelCategory.motion => 'Describe the motion you want.',
  };

  void _openResult(BuildContext context, GenerationJobResponse response) {
    if (response.job.status != GenerationJobStatus.completed ||
        response.assets.isEmpty) {
      return;
    }
    context.push(AppRoutes.result(response.assets.first.id));
  }
}

class _VideoComposer extends StatelessWidget {
  const _VideoComposer({
    required this.controller,
    required this.prompt,
    required this.modes,
    required this.selectedCategory,
    required this.models,
    required this.selectedModel,
    required this.suggestions,
    required this.disabledReason,
    required this.showDisabledReason,
    required this.jobState,
    required this.availableCoins,
    required this.generationCost,
    required this.canSubmit,
    required this.onClose,
    required this.onCategorySelected,
    required this.onModelSelected,
    required this.onPromptChanged,
    required this.onSuggestionSelected,
    required this.onAddImage,
    required this.onRetry,
    required this.onGenerate,
  });

  final TextEditingController controller;
  final String prompt;
  final List<GenerationMode> modes;
  final AiModelCategory selectedCategory;
  final List<AiModel> models;
  final AiModel selectedModel;
  final List<String> suggestions;
  final String? disabledReason;
  final bool showDisabledReason;
  final AsyncValue<GenerationJobResponse?> jobState;
  final int? availableCoins;
  final int generationCost;
  final bool canSubmit;
  final VoidCallback onClose;
  final ValueChanged<AiModelCategory> onCategorySelected;
  final ValueChanged<AiModel> onModelSelected;
  final ValueChanged<String> onPromptChanged;
  final ValueChanged<String> onSuggestionSelected;
  final VoidCallback onAddImage;
  final ValueChanged<GenerationJob> onRetry;
  final VoidCallback? onGenerate;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 48,
                      height: 46,
                    ),
                    onPressed: onClose,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                    tooltip: 'Close',
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _screenTitle(selectedCategory),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        Expanded(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(bottom: bottomInset),
            child: ListView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
              children: [
                const SizedBox(height: 26),
                SizedBox(
                  height: 204,
                  child: TextField(
                    controller: controller,
                    autofocus: false,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    keyboardAppearance: Brightness.dark,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    cursorColor: allAiNeon,
                    onChanged: onPromptChanged,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w500,
                      height: 1.18,
                    ),
                    decoration: InputDecoration(
                      hintText: _promptHint(selectedCategory),
                      hintStyle: const TextStyle(
                        color: Color(0xFF88888D),
                        fontSize: 27,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _SuggestionRail(
                  suggestions: suggestions,
                  onSelected: onSuggestionSelected,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _AddImageButton(onPressed: onAddImage)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _GenerateButton(
                        enabled: canSubmit,
                        loading: jobState.isLoading,
                        onPressed: onGenerate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _ComposerMeta(
                  selectedModel: selectedModel,
                  availableCoins: availableCoins,
                  generationCost: generationCost,
                  disabledReason: showDisabledReason ? disabledReason : null,
                ),
                _GenerationStatus(
                  state: jobState,
                  onOpenResult: (response) =>
                      _openCompletedResult(context, response),
                  onRetry: onRetry,
                ),
                const SizedBox(height: 16),
                _FormatModelPanel(
                  modes: modes,
                  selectedCategory: selectedCategory,
                  models: models,
                  selectedModelId: selectedModel.id,
                  onCategorySelected: onCategorySelected,
                  onModelSelected: onModelSelected,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _screenTitle(AiModelCategory category) => switch (category) {
    AiModelCategory.image => 'Image Generation',
    AiModelCategory.video => 'Video Generation',
    AiModelCategory.upscale => 'Upscale',
    AiModelCategory.avatar => 'Avatar Generation',
    AiModelCategory.motion => 'Motion Control',
  };

  String _promptHint(AiModelCategory category) => switch (category) {
    AiModelCategory.image => 'Describe an image...',
    AiModelCategory.video => 'Describe a video...',
    AiModelCategory.upscale => 'Describe what to enhance...',
    AiModelCategory.avatar => 'Describe an avatar...',
    AiModelCategory.motion => 'Describe motion...',
  };

  void _openCompletedResult(
    BuildContext context,
    GenerationJobResponse response,
  ) {
    if (response.job.status != GenerationJobStatus.completed ||
        response.assets.isEmpty) {
      return;
    }
    context.push(AppRoutes.result(response.assets.first.id));
  }
}

class _FormatModelPanel extends StatelessWidget {
  const _FormatModelPanel({
    required this.modes,
    required this.selectedCategory,
    required this.models,
    required this.selectedModelId,
    required this.onCategorySelected,
    required this.onModelSelected,
  });

  final List<GenerationMode> modes;
  final AiModelCategory selectedCategory;
  final List<AiModel> models;
  final String selectedModelId;
  final ValueChanged<AiModelCategory> onCategorySelected;
  final ValueChanged<AiModel> onModelSelected;

  @override
  Widget build(BuildContext context) {
    final sortedModes = [...modes]..sort((a, b) => a.order.compareTo(b.order));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151316),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF151316), Color(0xFF111113)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PanelEyebrow('ФОРМАТ'),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: sortedModes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final mode = sortedModes[index];
                return _FormatPill(
                  mode: mode,
                  selected: mode.category == selectedCategory,
                  onTap: () => onCategorySelected(mode.category),
                );
              },
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _PanelEyebrow('МОДЕЛИ'),
              const Spacer(),
              Text(
                _modelCountCopy(models.length),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFC7C7CC),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: models.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final model = models[index];
                return _GeneratorModelCard(
                  model: model,
                  selected: model.id == selectedModelId,
                  onTap: () => onModelSelected(model),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelEyebrow extends StatelessWidget {
  const _PanelEyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: allAiNeon,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }
}

class _FormatPill extends StatelessWidget {
  const _FormatPill({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final GenerationMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 94,
      child: Material(
        color: selected
            ? allAiNeon.withValues(alpha: 0.10)
            : const Color(0xFF1C1B1F),
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? allAiNeon
                    : Colors.white.withValues(alpha: 0.10),
                width: selected ? 1.4 : 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Center(
                child: Text(
                  mode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? allAiNeon : const Color(0xFFD4D4D8),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneratorModelCard extends StatelessWidget {
  const _GeneratorModelCard({
    required this.model,
    required this.selected,
    required this.onTap,
  });

  final AiModel model;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = _generatorModelMeta(model);
    final borderColor = selected
        ? allAiNeon
        : Colors.white.withValues(alpha: 0.10);

    return SizedBox(
      width: 156,
      child: Material(
        color: const Color(0xFF1A191C),
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: model.isAvailable ? onTap : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: allAiNeon.withValues(alpha: 0.10),
                        blurRadius: 12,
                        spreadRadius: -8,
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ModelThumb(imageUrl: meta.imageUrl),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meta.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                height: 1.08,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meta.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: allAiNeon,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                height: 1.12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          costLabel(model.cost),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFC7C7CC),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (selected)
                        Icon(
                          Icons.check_circle,
                          color: allAiNeon.withValues(alpha: 0.9),
                          size: 18,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ModelThumb extends StatelessWidget {
  const _ModelThumb({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: SizedBox(
        width: 38,
        height: 38,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 140),
          placeholder: (context, url) => const _ThumbFallback(),
          errorWidget: (context, url, error) => const _ThumbFallback(),
        ),
      ),
    );
  }
}

class _ThumbFallback extends StatelessWidget {
  const _ThumbFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF34343A), Color(0xFF111113)],
        ),
      ),
    );
  }
}

class _GeneratorModelMeta {
  const _GeneratorModelMeta({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String imageUrl;
}

_GeneratorModelMeta _generatorModelMeta(AiModel model) {
  return _GeneratorModelMeta(
    title: model.name,
    subtitle:
        model.shortLabel ??
        model.providerLabel ??
        modelCategoryLabel(model.category),
    imageUrl:
        model.thumbnailUrl ??
        'https://storage.googleapis.com/allai-media/landing/studio-presets/v5/product-ugc-hook.webp?v=2',
  );
}

String _generatorModelTitle(AiModel model) => _generatorModelMeta(model).title;

String _modelCountCopy(int count) {
  final word = count == 1
      ? 'модель'
      : count < 5
      ? 'модели'
      : 'моделей';
  return '$count $word';
}

class _SuggestionRail extends StatelessWidget {
  const _SuggestionRail({required this.suggestions, required this.onSelected});

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: suggestions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ActionChip(
            label: Text(suggestion),
            onPressed: () => onSelected(suggestion),
            backgroundColor: const Color(0xFF151515),
            side: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
            shape: const StadiumBorder(),
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          );
        },
      ),
    );
  }
}

class _AddImageButton extends StatelessWidget {
  const _AddImageButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF1D1D1F),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 26),
              SizedBox(width: 8),
              Text(
                'Add image',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenerateButton extends StatelessWidget {
  const _GenerateButton({
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final bool enabled;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: allAiNeon,
          disabledBackgroundColor: allAiNeon.withValues(alpha: 0.46),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.black.withValues(alpha: 0.62),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.black,
                ),
              )
            : const Text('Generate'),
      ),
    );
  }
}

class _ComposerMeta extends StatelessWidget {
  const _ComposerMeta({
    required this.selectedModel,
    required this.availableCoins,
    required this.generationCost,
    this.disabledReason,
  });

  final AiModel selectedModel;
  final int? availableCoins;
  final int generationCost;
  final String? disabledReason;

  @override
  Widget build(BuildContext context) {
    final copy =
        disabledReason ??
        '${_generatorModelTitle(selectedModel)} · Cost ${formatCoins(generationCost)} coins'
            '${availableCoins == null ? '' : ' · ${formatCoins(availableCoins!)} available'}';

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 160),
      child: Text(
        copy,
        key: ValueKey(copy),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: disabledReason == null ? allAiMuted : const Color(0xFFFFD879),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
      ),
    );
  }
}

class _GenerationStatus extends StatelessWidget {
  const _GenerationStatus({
    required this.state,
    required this.onOpenResult,
    required this.onRetry,
  });

  final AsyncValue<GenerationJobResponse?> state;
  final ValueChanged<GenerationJobResponse> onOpenResult;
  final ValueChanged<GenerationJob> onRetry;

  @override
  Widget build(BuildContext context) {
    if (!state.isLoading && !state.hasError && state.asData?.value == null) {
      return const SizedBox.shrink();
    }

    final response = state.asData?.value;
    final job = response?.job;
    final isFailed = job?.status == GenerationJobStatus.failed;
    final isCompleted = job?.status == GenerationJobStatus.completed;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFailed
              ? const Color(0xFFFF8A80)
              : allAiNeon.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.isLoading)
            const _StatusRow(icon: Icons.auto_awesome, label: 'Generating...')
          else if (state.hasError)
            _StatusRow(
              icon: Icons.error_outline,
              label: generationErrorCopy(state.error!),
              danger: true,
            )
          else if (job != null)
            _StatusRow(
              icon: isFailed ? Icons.error_outline : Icons.auto_awesome,
              label: generationProgressLabel(job.status),
              danger: isFailed,
            ),
          if (job?.progress != null) ...[
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: isCompleted ? 1 : job!.progress!.clamp(0, 1).toDouble(),
              backgroundColor: const Color(0xFF333337),
              color: allAiNeon,
            ),
          ],
          if (isFailed && job != null) ...[
            const SizedBox(height: 10),
            const Text(
              'Генерация не завершилась. Настройки сохранены.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              job.costCoins > 0
                  ? 'Койны возвращены на баланс.'
                  : 'Списание не выполнено.',
              style: const TextStyle(
                color: allAiMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => onRetry(job),
              icon: const Icon(Icons.refresh),
              label: const Text('Повторить'),
            ),
          ],
          if (isCompleted &&
              response != null &&
              response.assets.isNotEmpty) ...[
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => onOpenResult(response),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open result'),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: danger ? const Color(0xFFFF8A80) : allAiNeon,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: danger ? const Color(0xFFFFDAD6) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ComposerLoading extends StatelessWidget {
  const _ComposerLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: allAiNeon));
  }
}

class _ComposerError extends StatelessWidget {
  const _ComposerError({
    required this.title,
    required this.description,
    required this.onRetry,
  });

  final String title;
  final String description;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: allAiMuted,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
