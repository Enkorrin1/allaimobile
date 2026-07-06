import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/generated_asset_preview.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/result_action_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../../generation_jobs/presentation/providers/generation_job_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';

class ResultViewerScreen extends ConsumerWidget {
  const ResultViewerScreen({required this.assetId, super.key});

  final String assetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(libraryItemByAssetProvider(assetId));

    return Scaffold(
      appBar: AppBar(title: const Text('Результат')),
      body: SafeArea(
        child: itemAsync.when(
          loading: () => const LoadingState(label: 'Загружаем результат'),
          error: (error, stackTrace) => const ErrorState(
            title: 'Результат недоступен',
            description: 'Не удалось загрузить результат. Попробуйте позже.',
          ),
          data: (item) {
            if (item == null) {
              return const ErrorState(
                title: 'Результат не найден',
                description: 'Такого результата нет в истории.',
              );
            }

            final theme = Theme.of(context);
            final asset = item.outputAsset;
            final isFailed = item.job.status == GenerationJobStatus.failed;
            final isCompleted =
                item.job.status == GenerationJobStatus.completed;
            final isActive = !item.job.isTerminal;
            final canShowResult = isCompleted && asset != null;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (isActive)
                  _ActiveResultCard(job: item.job)
                else
                  AspectRatio(
                    aspectRatio: asset?.type == AssetType.video ? 9 / 14 : 1,
                    child: AppCard(
                      padding: EdgeInsets.zero,
                      color: modelCategoryColor(
                        item.model.category,
                      ).withValues(alpha: 0.12),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: asset == null
                                ? Center(
                                    child: Icon(
                                      modelCategoryIcon(item.model.category),
                                      size: 84,
                                      color: modelCategoryColor(
                                        item.model.category,
                                      ),
                                    ),
                                  )
                                : GeneratedAssetPreview(
                                    url: asset.url,
                                    thumbnailUrl: asset.thumbnailUrl,
                                    isVideo: asset.type == AssetType.video,
                                    fallbackIcon: assetIcon(asset.type),
                                    accentColor: modelCategoryColor(
                                      item.model.category,
                                    ),
                                  ),
                          ),
                          Positioned(
                            left: 12,
                            top: 12,
                            child: StatusChip(
                              label: jobStatusLabel(item.job.status),
                              icon: isFailed
                                  ? Icons.error_outline
                                  : Icons.check_circle_outline,
                            ),
                          ),
                          if (asset?.type == AssetType.video)
                            const Center(
                              child: CircleAvatar(
                                radius: 28,
                                child: Icon(Icons.play_arrow),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                Text(
                  item.template?.title ?? item.model.name,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  item.job.prompt,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                if (isFailed)
                  _FailedResultCard(job: item.job)
                else if (canShowResult)
                  const ResultActionBar(),
                if (!isActive && !isFailed && !canShowResult)
                  const _ResultUnavailableCard(),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Метаданные'),
                const SizedBox(height: 8),
                AppCard(
                  child: Column(
                    children: [
                      _MetadataRow(label: 'Инструмент', value: item.model.name),
                      _MetadataRow(
                        label: 'Статус',
                        value: jobStatusLabel(item.job.status),
                      ),
                      _MetadataRow(
                        label: 'Создано',
                        value: formatDateLabel(item.job.createdAt),
                      ),
                      _MetadataRow(
                        label: 'Стоимость',
                        value: '${item.job.costCoins} койнов',
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActiveResultCard extends StatelessWidget {
  const _ActiveResultCard({required this.job});

  final GenerationJob job;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = job.progress?.clamp(0.0, 1.0).toDouble();

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  generationProgressLabel(job.status),
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: progress),
          const SizedBox(height: 12),
          Text(
            'Задача ещё выполняется. Результат появится здесь автоматически после завершения.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultUnavailableCard extends StatelessWidget {
  const _ResultUnavailableCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      child: Text(
        'Результат ещё не готов. Мы покажем превью и действия после завершения задачи.',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _FailedResultCard extends ConsumerWidget {
  const _FailedResultCard({required this.job});

  final GenerationJob job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Генерация не завершилась. Настройки сохранены.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 6),
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
            onPressed: () async {
              final response = await ref
                  .read(generationJobControllerProvider.notifier)
                  .retryJob(job);
              if (!context.mounted ||
                  response == null ||
                  response.assets.isEmpty) {
                return;
              }
              context.push(AppRoutes.result(response.assets.first.id));
            },
            secondary: true,
          ),
        ],
      ),
    );
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
