import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/l10n.dart';
import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../domain/billing_models.dart';
import '../../domain/purchase_models.dart';
import '../providers/billing_providers.dart';
import '../providers/purchase_providers.dart';

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceStateProvider);
    final packagesAsync = ref.watch(coinPackagesStateProvider);
    final purchaseState = ref.watch(purchaseControllerProvider);
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: balanceAsync.when(
          loading: () => LoadingState(label: l10n.pricingLoadingPro),
          error: (error, stackTrace) => ErrorState(
            title: l10n.pricingBalanceUnavailableTitle,
            description: l10n.pricingBalanceUnavailableDescription,
            onRetry: () => ref.invalidate(balanceStateProvider),
          ),
          data: (balanceState) {
            final balance = balanceState.data;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: l10n.commonBack,
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const NeonMediaCard(
                  title: '',
                  imageUrl:
                      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=1100&q=82',
                  width: double.infinity,
                  height: 340,
                  borderRadius: 8,
                ),
                const SizedBox(height: 30),
                Text(
                  l10n.pricingStartTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.pricingStartSubtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFB8B8BE),
                    fontSize: 16,
                    height: 1.28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 22),
                _BalancePill(
                  availableCoins: balance.availableCoins,
                  reservedCoins: balance.reservedCoins,
                ),
                const SizedBox(height: 24),
                packagesAsync.when(
                  loading: () =>
                      LoadingState(label: l10n.pricingLoadingPackages),
                  error: (error, stackTrace) => ErrorState(
                    title: l10n.pricingPackagesUnavailableTitle,
                    description: l10n.pricingPackagesUnavailableDescription,
                    onRetry: () => ref.invalidate(coinPackagesStateProvider),
                  ),
                  data: (packagesState) => _PackageStrip(
                    packages: packagesState.data,
                    selectedPackageId: purchaseState.selectedPackageId,
                    onSelected: (package) => ref
                        .read(purchaseControllerProvider.notifier)
                        .selectPackage(package.id),
                  ),
                ),
                const SizedBox(height: 28),
                NeonPillButton(
                  label: purchaseState.isBusy
                      ? l10n.pricingRestoringPurchases
                      : l10n.pricingBuyPackage,
                  onPressed: purchaseState.isBusy
                      ? null
                      : () async {
                          final packages = packagesAsync.asData?.value.data;
                          final selected = packages
                              ?.where(
                                (item) =>
                                    item.id == purchaseState.selectedPackageId,
                              )
                              .firstOrNull;
                          if (selected == null) {
                            _showMessage(context, l10n.pricingSelectPackage);
                            return;
                          }
                          await ref
                              .read(purchaseControllerProvider.notifier)
                              .purchase(selected);
                          if (!context.mounted) return;
                          _showPurchaseState(context, ref);
                        },
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: purchaseState.isBusy
                      ? null
                      : () async {
                          await ref
                              .read(purchaseControllerProvider.notifier)
                              .restorePurchases();
                          if (!context.mounted) return;
                          _showPurchaseState(context, ref);
                        },
                  icon: const Icon(Icons.restore),
                  label: Text(l10n.pricingRestorePurchases),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.pricingDemoMode,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8C8C92),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showPurchaseState(BuildContext context, WidgetRef ref) {
    final state = ref.read(purchaseControllerProvider);
    final l10n = context.l10n;
    final message = state.status == PurchaseFlowStatus.unavailable
        ? l10n.pricingPurchaseUnavailable
        : l10n.pricingPurchaseFailed;
    _showMessage(context, message);
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BalancePill extends StatelessWidget {
  const _BalancePill({
    required this.availableCoins,
    required this.reservedCoins,
  });

  final int availableCoins;
  final int reservedCoins;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: allAiPanelSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2B2B30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: allAiNeon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.pricingCoinsAvailable(formatCoins(availableCoins)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Text(
            l10n.pricingReserved(formatCoins(reservedCoins)),
            style: const TextStyle(
              color: allAiMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageStrip extends StatelessWidget {
  const _PackageStrip({
    required this.packages,
    required this.selectedPackageId,
    required this.onSelected,
  });

  final List<CoinPackage> packages;
  final String? selectedPackageId;
  final ValueChanged<CoinPackage> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (packages.isEmpty) {
      return Text(
        l10n.pricingPackagesEmpty,
        textAlign: TextAlign.center,
        style: const TextStyle(color: allAiMuted),
      );
    }

    return SizedBox(
      height: 116,
      child: ListView.separated(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final package = packages[index];
          final selected = selectedPackageId == package.id;
          return Material(
            color: selected ? allAiNeon : const Color(0xFF171719),
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              key: Key('coin-package-${package.id}'),
              onTap: package.isAvailable ? () => onSelected(package) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 190,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected ? allAiNeon : const Color(0xFF2B2B30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? Colors.black : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.pricingPackageCoins(formatCoins(package.coinAmount)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected
                            ? Colors.black.withValues(alpha: 0.72)
                            : allAiMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
