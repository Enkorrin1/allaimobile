import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/store_purchase_gateway.dart';
import '../../domain/billing_models.dart';
import '../../domain/purchase_models.dart';

final storePurchaseGatewayProvider = Provider<StorePurchaseGateway>((ref) {
  return const DisabledStorePurchaseGateway();
});

final purchaseControllerProvider =
    NotifierProvider<PurchaseController, PurchaseFlowState>(
      PurchaseController.new,
    );

class PurchaseController extends Notifier<PurchaseFlowState> {
  @override
  PurchaseFlowState build() => const PurchaseFlowState();

  void selectPackage(String packageId) {
    if (state.isBusy) return;
    state = PurchaseFlowState(selectedPackageId: packageId);
  }

  Future<void> purchase(CoinPackage package) async {
    if (state.isBusy || state.selectedPackageId != package.id) return;
    final gateway = ref.read(storePurchaseGatewayProvider);
    if (!gateway.isConfigured) {
      state = PurchaseFlowState(
        status: PurchaseFlowStatus.unavailable,
        selectedPackageId: package.id,
        errorCode: 'store_not_configured',
      );
      return;
    }

    state = PurchaseFlowState(
      status: PurchaseFlowStatus.purchasing,
      selectedPackageId: package.id,
    );
    try {
      // Store product IDs must come from an approved backend package contract.
      throw const StorePurchaseException('product_id_missing');
    } on StorePurchaseException catch (error) {
      state = PurchaseFlowState(
        status: PurchaseFlowStatus.failed,
        selectedPackageId: package.id,
        errorCode: error.code,
      );
    }
  }

  Future<void> restorePurchases() async {
    if (state.isBusy) return;
    final gateway = ref.read(storePurchaseGatewayProvider);
    if (!gateway.isConfigured) {
      state = PurchaseFlowState(
        status: PurchaseFlowStatus.unavailable,
        selectedPackageId: state.selectedPackageId,
        errorCode: 'store_not_configured',
      );
      return;
    }
    state = PurchaseFlowState(
      status: PurchaseFlowStatus.restoring,
      selectedPackageId: state.selectedPackageId,
    );
    try {
      await gateway.restore();
      state = PurchaseFlowState(
        status: PurchaseFlowStatus.verified,
        selectedPackageId: state.selectedPackageId,
      );
    } on StorePurchaseException catch (error) {
      state = PurchaseFlowState(
        status: PurchaseFlowStatus.failed,
        selectedPackageId: state.selectedPackageId,
        errorCode: error.code,
      );
    }
  }
}
