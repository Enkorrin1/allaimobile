import 'package:allai_mobile/features/billing/domain/billing_models.dart';
import 'package:allai_mobile/features/billing/domain/purchase_models.dart';
import 'package:allai_mobile/features/billing/presentation/providers/purchase_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('purchase flow fails closed while store is not configured', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final controller = container.read(purchaseControllerProvider.notifier);

    controller.selectPackage(_package.id);
    await controller.purchase(_package);
    final state = container.read(purchaseControllerProvider);

    expect(state.status, PurchaseFlowStatus.unavailable);
    expect(state.selectedPackageId, _package.id);
    expect(state.errorCode, 'store_not_configured');
  });

  test('restore flow fails closed while store is not configured', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container
        .read(purchaseControllerProvider.notifier)
        .restorePurchases();
    final state = container.read(purchaseControllerProvider);

    expect(state.status, PurchaseFlowStatus.unavailable);
    expect(state.errorCode, 'store_not_configured');
  });
}

const _package = CoinPackage(
  id: 'coins-500',
  name: 'Creator',
  coinAmount: 500,
  description: 'Creator package',
  isHighlighted: true,
  isAvailable: true,
);
