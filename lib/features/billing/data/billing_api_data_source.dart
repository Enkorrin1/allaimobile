import '../../../core/api/mock_allai_api.dart';

abstract class BillingApiDataSource {
  Future<Map<String, dynamic>> fetchBalance();
  Future<List<Map<String, dynamic>>> fetchPackages();
  Future<List<Map<String, dynamic>>> fetchTransactions();
}

class MockBillingApiDataSource implements BillingApiDataSource {
  const MockBillingApiDataSource(this._api);

  final MockAllAiApi _api;

  @override
  Future<Map<String, dynamic>> fetchBalance() {
    return _api.getBalance();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPackages() {
    return _api.getPackages();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() {
    return _api.getTransactions();
  }
}

class DisabledLiveBillingApiDataSource implements BillingApiDataSource {
  const DisabledLiveBillingApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchBalance() {
    throw const BillingApiDataSourceException(
      'network_unavailable',
      'Live billing adapter is disabled until an approved API base URL exists.',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchPackages() {
    throw const BillingApiDataSourceException(
      'network_unavailable',
      'Live billing adapter is disabled until an approved API base URL exists.',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchTransactions() {
    throw const BillingApiDataSourceException(
      'network_unavailable',
      'Live billing adapter is disabled until an approved API base URL exists.',
    );
  }
}

class BillingApiDataSourceException implements Exception {
  const BillingApiDataSourceException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'BillingApiDataSourceException($code, $message)';
}
