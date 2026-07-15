import '../domain/purchase_models.dart';

abstract interface class StorePurchaseGateway {
  bool get isConfigured;
  Future<StorePurchaseReceipt> purchase(StorePurchaseRequest request);
  Future<List<StorePurchaseReceipt>> restore();
}

class DisabledStorePurchaseGateway implements StorePurchaseGateway {
  const DisabledStorePurchaseGateway();

  @override
  bool get isConfigured => false;

  @override
  Future<StorePurchaseReceipt> purchase(StorePurchaseRequest request) {
    throw const StorePurchaseException('store_not_configured');
  }

  @override
  Future<List<StorePurchaseReceipt>> restore() {
    throw const StorePurchaseException('store_not_configured');
  }
}

class StorePurchaseException implements Exception {
  const StorePurchaseException(this.code);
  final String code;
}
