import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/error_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../../../../shared/widgets/neon_media_card.dart';
import '../../../tools/presentation/view_models/catalog_ui_mappers.dart';
import '../../domain/billing_models.dart';
import '../providers/billing_providers.dart';

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceStateProvider);
    final packagesAsync = ref.watch(coinPackagesStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: balanceAsync.when(
          loading: () => const LoadingState(label: 'Loading PRO'),
          error: (error, stackTrace) => ErrorState(
            title: 'Balance is unavailable',
            description: 'Coin data could not be loaded right now.',
            onRetry: () => ref.invalidate(balanceStateProvider),
          ),
          data: (balanceState) {
            final balance = balanceState.data;

            return ListView(
              padding: const EdgeInsets.fromLTRB(30, 8, 30, 28),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: 'Back',
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
                  height: 520,
                  borderRadius: 30,
                ),
                const SizedBox(height: 42),
                const Text(
                  'Start Creating Now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Generate anything. PRO purchase flow will be connected after store setup.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFB8B8BE),
                    fontSize: 20,
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
                  loading: () => const LoadingState(label: 'Loading packages'),
                  error: (error, stackTrace) => ErrorState(
                    title: 'Packages are unavailable',
                    description: 'The demo package list could not be loaded.',
                    onRetry: () => ref.invalidate(coinPackagesStateProvider),
                  ),
                  data: (packagesState) =>
                      _PackageStrip(packages: packagesState.data),
                ),
                const SizedBox(height: 28),
                NeonPillButton(
                  label: 'Continue',
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Purchases will be connected later.'),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Demo mode. No live payment is charged in this build.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: allAiPanelSoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF2B2B30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: allAiNeon),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${formatCoins(availableCoins)} coins available',
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
            '${formatCoins(reservedCoins)} reserved',
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
  const _PackageStrip({required this.packages});

  final List<CoinPackage> packages;

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) {
      return const Text(
        'Coin packages will appear here after billing setup.',
        textAlign: TextAlign.center,
        style: TextStyle(color: allAiMuted),
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
          return Container(
            width: 190,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: package.isHighlighted
                  ? allAiNeon
                  : const Color(0xFF171719),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: package.isHighlighted
                    ? allAiNeon
                    : const Color(0xFF2B2B30),
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
                    color: package.isHighlighted ? Colors.black : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                Text(
                  '${formatCoins(package.coinAmount)} coins',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: package.isHighlighted
                        ? Colors.black.withValues(alpha: 0.72)
                        : allAiMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
