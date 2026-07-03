import '../../../core/api/public_catalog_sanitizer.dart';
import 'catalog_api_data_source.dart';
import 'catalog_cache_data_source.dart';
import '../domain/catalog_models.dart';

abstract class CatalogRepository {
  Future<CatalogResponse> getCatalog();
  Future<CatalogRepositoryResult> getCatalogState({bool forceRefresh = false});
}

class MockCatalogRepository implements CatalogRepository {
  const MockCatalogRepository(this._api, this._cache);

  final CatalogApiDataSource _api;
  final CatalogCacheDataSource _cache;

  @override
  Future<CatalogResponse> getCatalog() async {
    return (await getCatalogState()).catalog;
  }

  @override
  Future<CatalogRepositoryResult> getCatalogState({
    bool forceRefresh = false,
  }) async {
    final cached = await _readCachedCatalog();
    if (cached != null && !forceRefresh) return cached;

    try {
      final catalogJson = sanitizePublicCatalogJson(await _api.fetchCatalog());
      await _cache.writeCatalog(catalogJson);
      return CatalogRepositoryResult(
        catalog: _parseCatalog(catalogJson),
        isFromCache: false,
      );
    } on Object catch (error) {
      final safeError = _mapCatalogError(error);
      if (cached != null) return cached.copyWith(refreshError: safeError);
      throw safeError;
    }
  }

  Future<CatalogRepositoryResult?> _readCachedCatalog() async {
    final cachedJson = await _cache.readCatalog();
    if (cachedJson == null) return null;

    try {
      final sanitized = sanitizePublicCatalogJson(cachedJson);
      return CatalogRepositoryResult(
        catalog: _parseCatalog(sanitized),
        isFromCache: true,
      );
    } on Object catch (error) {
      throw _mapCatalogError(error, fallbackCode: 'catalog_cache_miss');
    }
  }

  CatalogResponse _parseCatalog(Map<String, dynamic> json) {
    try {
      return CatalogResponse.fromJson(json);
    } on Object catch (error) {
      throw _mapCatalogError(error);
    }
  }

  CatalogRepositoryException _mapCatalogError(
    Object error, {
    String fallbackCode = 'catalog_unavailable',
  }) {
    if (error is CatalogRepositoryException) return error;
    if (error is PublicCatalogSanitizationException) {
      return CatalogRepositoryException(
        error.code,
        _messageForCode(error.code),
      );
    }
    if (error is CatalogApiDataSourceException) {
      return CatalogRepositoryException(
        error.code,
        _messageForCode(error.code),
      );
    }
    if (error is FormatException || error is TypeError) {
      return CatalogRepositoryException(
        'catalog_parse_failed',
        _messageForCode('catalog_parse_failed'),
      );
    }
    return CatalogRepositoryException(
      fallbackCode,
      _messageForCode(fallbackCode),
    );
  }
}

class CatalogRepositoryResult {
  const CatalogRepositoryResult({
    required this.catalog,
    required this.isFromCache,
    this.refreshError,
  });

  final CatalogResponse catalog;
  final bool isFromCache;
  final CatalogRepositoryException? refreshError;

  bool get isEmpty => catalog.models.isEmpty || catalog.templates.isEmpty;

  CatalogRepositoryResult copyWith({
    CatalogResponse? catalog,
    bool? isFromCache,
    CatalogRepositoryException? refreshError,
  }) {
    return CatalogRepositoryResult(
      catalog: catalog ?? this.catalog,
      isFromCache: isFromCache ?? this.isFromCache,
      refreshError: refreshError ?? this.refreshError,
    );
  }
}

class CatalogRepositoryException implements Exception {
  const CatalogRepositoryException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'CatalogRepositoryException($code, $message)';
}

String _messageForCode(String code) {
  return switch (code) {
    'catalog_empty' => 'Каталог пока пуст. Попробуйте обновить позже.',
    'catalog_parse_failed' =>
      'Не удалось прочитать каталог. Попробуйте обновить позже.',
    'catalog_cache_miss' =>
      'Сохраненный каталог недоступен. Попробуйте обновить позже.',
    'backend_contract_violation' =>
      'Каталог временно недоступен. Мы уже готовим обновление.',
    'network_unavailable' =>
      'Не удалось обновить каталог. Проверьте подключение или попробуйте позже.',
    _ => 'Не удалось загрузить каталог. Попробуйте позже.',
  };
}
