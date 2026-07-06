import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/generated_asset_preview.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/media_asset_tile.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../generation_jobs/domain/generation_job_models.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../domain/library_history_item.dart';
import '../providers/library_providers.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(libraryHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Библиотека')),
      body: SafeArea(
        child: historyAsync.when(
          loading: () => const LoadingState(label: 'Загружаем историю'),
          error: (error, stackTrace) => const ErrorState(
            title: 'История недоступна',
            description: 'Не удалось прочитать историю генераций.',
          ),
          data: (history) => LayoutBuilder(
            builder: (context, constraints) {
              final useList = constraints.maxWidth < 560;

              return CustomScrollView(
                slivers: [
                  if (history.isEmpty)
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverToBoxAdapter(
                        child: EmptyState(
                          icon: Icons.auto_awesome_outlined,
                          title: 'Пока нет созданных результатов',
                          description:
                              'Запустите первую генерацию, и она появится здесь.',
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList.list(
                        children: [
                          Text(
                            'История генераций',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Здесь сохраняются активные, готовые и неудачные генерации с моделью, датой и стоимостью.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              StatusChip(
                                label: 'Все',
                                icon: Icons.all_inclusive,
                              ),
                              StatusChip(
                                label: 'Фото',
                                icon: Icons.image_outlined,
                              ),
                              StatusChip(
                                label: 'В работе',
                                icon: Icons.timelapse,
                              ),
                              StatusChip(
                                label: 'Ошибки',
                                icon: Icons.error_outline,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const SectionHeader(title: 'Сгенерированные ассеты'),
                        ],
                      ),
                    ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: useList
                        ? SliverList.separated(
                            itemBuilder: (context, index) =>
                                _HistoryTile(item: history[index]),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemCount: history.length,
                          )
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.86,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  _HistoryTile(item: history[index]),
                              childCount: history.length,
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.item});

  final LibraryHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final asset = item.outputAsset;
    final isActive = !item.job.isTerminal;
    final targetId = asset?.id ?? item.job.id;

    return MediaAssetTile(
      title: item.template?.title ?? item.model.name,
      kind: asset == null
          ? modelCategoryLabel(item.model.category)
          : assetKindLabel(asset.type),
      status: jobStatusLabel(item.job.status),
      subtitle:
          '${formatDateLabel(item.job.updatedAt)} • ${item.job.costCoins} койнов${isActive ? ' • ${generationStatusProgress(item.job)}' : ''}',
      icon: asset == null
          ? modelCategoryIcon(item.model.category)
          : assetIcon(asset.type),
      accentColor: modelCategoryColor(item.model.category),
      preview: asset == null
          ? null
          : GeneratedAssetPreview(
              url: asset.url,
              thumbnailUrl: asset.thumbnailUrl,
              isVideo: asset.type == AssetType.video,
              fallbackIcon: assetIcon(asset.type),
              accentColor: modelCategoryColor(item.model.category),
            ),
      onTap: () => context.push(AppRoutes.result(targetId)),
    );
  }
}

String generationStatusProgress(GenerationJob job) {
  final progress = job.progress;
  if (progress == null) return jobStatusLabel(job.status);
  return '${(progress * 100).round()}%';
}
