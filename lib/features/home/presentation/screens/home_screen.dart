import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../features/billing/presentation/providers/billing_providers.dart';
import '../../../../features/library/presentation/providers/library_providers.dart';
import '../../../../features/tools/presentation/providers/catalog_providers.dart';
import '../../../../features/tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/coin_balance_chip.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/media_asset_tile.dart';
import '../../../../shared/widgets/model_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../../shared/widgets/template_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balance = ref.watch(balanceProvider).value;
    final catalogAsync = ref.watch(catalogProvider);
    final history = ref.watch(libraryHistoryProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AllAI'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CoinBalanceChip(
              label: balance == null
                  ? 'Баланс загружается'
                  : 'Баланс: ${formatCoins(balance.coinBalance)} койнов',
              compactLabel: balance == null
                  ? '...'
                  : formatCoins(balance.coinBalance),
              compact: true,
              onPressed: () => context.push(AppRoutes.pricing),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: catalogAsync.when(
          loading: () => const LoadingState(label: 'Загружаем каталог'),
          error: (error, stackTrace) => const ErrorState(
            title: 'Каталог недоступен',
            description: 'Не удалось открыть каталог.',
          ),
          data: (catalog) {
            final quickTemplates = catalog.templates.take(3).toList();
            final recentAssets = history.take(2).toList();
            final activeJobs = history.where((item) => !item.job.isTerminal);
            final activeJob = activeJobs.isEmpty ? null : activeJobs.first;

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Креативный пульт', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  'Генерируйте изображения, видео и social-ready материалы из одного мобильного рабочего пространства.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Создать ассет',
                        icon: Icons.auto_awesome,
                        onPressed: () => context.go(AppRoutes.create),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        label: 'Инструменты',
                        icon: Icons.widgets_outlined,
                        secondary: true,
                        onPressed: () => context.push(AppRoutes.tools),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          StatusChip(
                            label: activeJob == null
                                ? 'Нет активных'
                                : jobStatusLabel(activeJob.job.status),
                            icon: Icons.hourglass_top,
                          ),
                          const Spacer(),
                          Text(
                            activeJob == null
                                ? '0%'
                                : '${((activeJob.job.progress ?? 0) * 100).round()}%',
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        activeJob?.template?.title ?? 'Активная задача',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activeJob == null
                            ? 'Когда задача будет запущена, прогресс появится здесь.'
                            : 'Задача выполняется по шагам, прогресс обновится автоматически.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 14),
                      LinearProgressIndicator(
                        value: activeJob?.job.progress ?? 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                SectionHeader(
                  title: 'Быстрые шаблоны',
                  actionLabel: 'Все',
                  onActionPressed: () => context.push(AppRoutes.tools),
                ),
                const SizedBox(height: 8),
                for (final template in quickTemplates) ...[
                  TemplateCard(
                    title: template.title,
                    badge: templateBadge(template),
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
                    onTap: () =>
                        context.push(AppRoutes.templateDetail(template.id)),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 10),
                const SectionHeader(title: 'Рекомендуемые инструменты'),
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
                    onTap: () => context.push(AppRoutes.toolDetail(model.id)),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 10),
                SectionHeader(
                  title: 'Последние результаты',
                  actionLabel: 'Библиотека',
                  onActionPressed: () => context.go(AppRoutes.library),
                ),
                const SizedBox(height: 8),
                for (final item in recentAssets) ...[
                  MediaAssetTile(
                    title: item.template?.title ?? item.model.name,
                    kind: item.outputAsset == null
                        ? modelCategoryLabel(item.model.category)
                        : assetKindLabel(item.outputAsset!.type),
                    status: jobStatusLabel(item.job.status),
                    subtitle: formatDateLabel(item.job.updatedAt),
                    icon: item.outputAsset == null
                        ? modelCategoryIcon(item.model.category)
                        : assetIcon(item.outputAsset!.type),
                    accentColor: modelCategoryColor(item.model.category),
                    onTap: () => context.push(
                      AppRoutes.result(item.outputAsset?.id ?? item.job.id),
                    ),
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
}
