import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/cost_preview_card.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../providers/billing_providers.dart';
import '../view_models/billing_copy.dart';

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final balanceAsync = ref.watch(balanceStateProvider);
    final packagesAsync = ref.watch(coinPackagesStateProvider);
    final transactionsAsync = ref.watch(coinTransactionsStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Коины')),
      body: SafeArea(
        child: balanceAsync.when(
          loading: () => const LoadingState(label: 'Загружаем баланс'),
          error: (error, stackTrace) => ErrorState(
            title: 'Баланс недоступен',
            description: 'Не удалось загрузить данные по коинам.',
            onRetry: () => ref.invalidate(balanceStateProvider),
          ),
          data: (balanceState) {
            final balance = balanceState.data;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Баланс и пакеты', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(
                  billingUnavailableCopy,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (balanceState.isFromCache ||
                    balanceState.refreshError != null) ...[
                  const SizedBox(height: 12),
                  const StatusChip(
                    label: 'Показываем сохраненные данные',
                    icon: Icons.offline_pin_outlined,
                  ),
                ],
                const SizedBox(height: 16),
                CostPreviewCard(
                  costLabel:
                      'Баланс: ${formatCoins(balance.coinBalance)} койнов',
                  reserveCopy:
                      'Доступно сейчас: ${formatCoins(balance.availableCoins)} койнов. Зарезервировано: ${formatCoins(balance.reservedCoins)}.',
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Пакеты'),
                const SizedBox(height: 8),
                packagesAsync.when(
                  loading: () => const LoadingState(label: 'Загружаем пакеты'),
                  error: (error, stackTrace) => ErrorState(
                    title: 'Пакеты недоступны',
                    description:
                        'Не удалось обновить список пакетов. Попробуйте позже.',
                    onRetry: () => ref.invalidate(coinPackagesStateProvider),
                  ),
                  data: (packagesState) {
                    final packages = packagesState.data;
                    if (packages.isEmpty) {
                      return ErrorState(
                        title: 'Пакеты пока не добавлены',
                        description:
                            'Покупки появятся после подключения платежей.',
                        onRetry: () =>
                            ref.invalidate(coinPackagesStateProvider),
                      );
                    }
                    return Column(
                      children: [
                        for (final package in packages) ...[
                          AppCard(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  package.isHighlighted
                                      ? Icons.workspace_premium_outlined
                                      : Icons.toll,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              package.name,
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ),
                                          if (package.isHighlighted)
                                            const StatusChip(
                                              label: 'Популярно',
                                              icon: Icons.star_border,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        package.priceLabel ??
                                            '${formatCoins(package.coinAmount)} койнов',
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      if (!package.isAvailable) ...[
                                        const SizedBox(height: 6),
                                        const StatusChip(
                                          label: 'Недоступно',
                                          icon: Icons.lock_outline,
                                        ),
                                      ],
                                      const SizedBox(height: 6),
                                      Text(
                                        package.description,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    );
                  },
                ),
                AppButton(
                  label: topUpBalanceCopy,
                  icon: Icons.lock_outline,
                  onPressed: null,
                ),
                const SizedBox(height: 22),
                const SectionHeader(title: 'Транзакции'),
                const SizedBox(height: 8),
                transactionsAsync.when(
                  loading: () =>
                      const LoadingState(label: 'Загружаем транзакции'),
                  error: (error, stackTrace) => const ErrorState(
                    title: 'Транзакции недоступны',
                    description:
                        'История операций временно недоступна. Попробуйте позже.',
                  ),
                  data: (transactionsState) {
                    if (transactionsState.data.isEmpty) {
                      return const AppCard(
                        child: ErrorState(
                          title: 'Операций пока нет',
                          description:
                              'История появится после первых генераций или пополнений.',
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (final transaction in transactionsState.data) ...[
                          AppCard(
                            child: Row(
                              children: [
                                const Icon(Icons.receipt_long_outlined),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        formatDateLabel(transaction.createdAt),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  transaction.amount > 0
                                      ? '+${formatCoins(transaction.amount)}'
                                      : '-${formatCoins(transaction.amount.abs())}',
                                  style: theme.textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
