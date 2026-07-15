enum StorePlatform { appleAppStore, googlePlay }

enum PurchaseFlowStatus {
  idle,
  purchasing,
  restoring,
  verified,
  unavailable,
  failed,
}

class StorePurchaseRequest {
  const StorePurchaseRequest({
    required this.packageId,
    required this.storeProductId,
    required this.platform,
    required this.clientRequestId,
  });

  final String packageId;
  final String storeProductId;
  final StorePlatform platform;
  final String clientRequestId;
}

class StorePurchaseReceipt {
  const StorePurchaseReceipt({
    required this.transactionId,
    required this.storeProductId,
    required this.verificationPayload,
  });

  final String transactionId;
  final String storeProductId;
  final String verificationPayload;
}

class PurchaseFlowState {
  const PurchaseFlowState({
    this.status = PurchaseFlowStatus.idle,
    this.selectedPackageId,
    this.transactionId,
    this.errorCode,
  });

  final PurchaseFlowStatus status;
  final String? selectedPackageId;
  final String? transactionId;
  final String? errorCode;

  bool get isBusy =>
      status == PurchaseFlowStatus.purchasing ||
      status == PurchaseFlowStatus.restoring;
}
