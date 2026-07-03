import '../../../core/api/mock_allai_api.dart';

abstract class CatalogApiDataSource {
  Future<Map<String, dynamic>> fetchCatalog();
}

class MockCatalogApiDataSource implements CatalogApiDataSource {
  const MockCatalogApiDataSource(this._api);

  final MockAllAiApi _api;

  @override
  Future<Map<String, dynamic>> fetchCatalog() {
    return _api.getCatalog();
  }
}

class DisabledLiveCatalogApiDataSource implements CatalogApiDataSource {
  const DisabledLiveCatalogApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchCatalog() {
    throw const CatalogApiDataSourceException(
      'network_unavailable',
      'Live catalog adapter is disabled until an approved API base URL exists.',
    );
  }
}

class CatalogApiDataSourceException implements Exception {
  const CatalogApiDataSourceException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'CatalogApiDataSourceException($code, $message)';
}
