import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/result_action_bar.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../../library/presentation/providers/library_providers.dart';

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
            description: 'Mock repository вернул ошибку.',
          ),
          data: (item) {
            if (item == null) {
              return const ErrorState(
                title: 'Результат не найден',
                description: 'Такого static result нет в mock history.',
              );
            }

            final theme = Theme.of(context);
            final asset = item.outputAsset;
            final isFailed = item.job.status == GenerationJobStatus.failed;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AspectRatio(
                  aspectRatio: asset?.type == AssetType.video ? 9 / 14 : 1,
                  child: AppCard(
                    color: modelCategoryColor(
                      item.model.category,
                    ).withValues(alpha: 0.12),
                    child: Stack(
                      children: [
                        Center(
                          child: Icon(
                            asset == null
                                ? modelCategoryIcon(item.model.category)
                                : assetIcon(asset.type),
                            size: 84,
                            color: modelCategoryColor(item.model.category),
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
                if (isFailed) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.job.errorMessage ??
                              'Генерация не завершилась. Койны возвращены на баланс.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          label: 'Повторить с теми же настройками',
                          icon: Icons.refresh,
                          onPressed: () {},
                          secondary: true,
                        ),
                      ],
                    ),
                  ),
                ] else
                  const ResultActionBar(),
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
