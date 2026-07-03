import '../../../core/api/public_billing_sanitizer.dart';
import 'billing_api_data_source.dart';
import 'billing_cache_data_source.dart';
import '../domain/billing_models.dart';

abstract class BillingRepository {
  Future<BillingBalance> getBalance();
  Future<List<CoinPackage>> getPackages();
  Future<List<CoinTransaction>> getTransactions();
  Future<BillingRepositoryResult<BillingBalance>> getBalanceState({
    bool forceRefresh = false,
  });
  Future<BillingRepositoryResult<List<CoinPackage>>> getPackagesState({
    bool forceRefresh = false,
  });
  Future<BillingRepositoryResult<List<CoinTransaction>>> getTransactionsState();
}

class MockBillingRepository implements BillingRepository {
  const MockBillingRepository(this._api, this._cache);

  final BillingApiDataSource _api;
  final BillingCacheDataSource _cache;

  @override
  Future<BillingBalance> getBalance() async {
    return (await getBalanceState()).data;
  }

  @override
  Future<List<CoinPackage>> getPackages() async {
    return (await getPackagesState()).data;
  }

  @override
  Future<List<CoinTransaction>> getTransactions() async {
    return (await getTransactionsState()).data;
  }

  @override
  Future<BillingRepositoryResult<BillingBalance>> getBalanceState({
    bool forceRefresh = false,
  }) async {
    final cached = await _readCachedBalance();
    if (cached != null && !forceRefresh) return cached;

    try {
      final balanceJson = sanitizePublicBalanceJson(
        await _api.fetchBalance(),
        defaultUserId: BillingCacheDataSource.defaultUserId,
      );
      await _cache.writeBalance(balanceJson);
      return BillingRepositoryResult(
        data: BillingBalance.fromJson(balanceJson),
        isFromCache: false,
      );
    } on Object catch (error) {
      final safeError = _mapBillingError(error, 'balance_unavailable');
      if (cached != null) return cached.copyWith(refreshError: safeError);
      throw safeError;
    }
  }

  @override
  Future<BillingRepositoryResult<List<CoinPackage>>> getPackagesState({
    bool forceRefresh = false,
  }) async {
    final cached = await _readCachedPackages();
    if (cached != null && !forceRefresh) return cached;

    try {
      final packagesJson = sanitizePublicPackagesJson(
        await _api.fetchPackages(),
      );
      await _cache.writePackages(packagesJson);
      return BillingRepositoryResult(
        data: packagesJson.map(CoinPackage.fromJson).toList(),
        isFromCache: false,
      );
    } on Object catch (error) {
      final safeError = _mapBillingError(error, 'packages_unavailable');
      if (cached != null) return cached.copyWith(refreshError: safeError);
      throw safeError;
    }
  }

  @override
  Future<BillingRepositoryResult<List<CoinTransaction>>>
  getTransactionsState() async {
    try {
      final transactions = await _api.fetchTransactions();
      return BillingRepositoryResult(
        data: transactions.map(CoinTransaction.fromJson).toList(),
        isFromCache: false,
      );
    } on Object catch (error) {
      final cached = await _cache.readTransactions();
      if (cached.isNotEmpty) {
        return BillingRepositoryResult(
          data: cached.map(CoinTransaction.fromJson).toList(),
          isFromCache: true,
          refreshError: _mapBillingError(error, 'pricing_unavailable'),
        );
      }
      throw _mapBillingError(error, 'pricing_unavailable');
    }
  }

  Future<BillingRepositoryResult<BillingBalance>?> _readCachedBalance() async {
    final cached = await _cache.readBalance();
    if (cached == null) return null;
    final sanitized = sanitizePublicBalanceJson(
      cached,
      defaultUserId: BillingCacheDataSource.defaultUserId,
    );
    return BillingRepositoryResult(
      data: BillingBalance.fromJson(sanitized),
      isFromCache: true,
    );
  }

  Future<BillingRepositoryResult<List<CoinPackage>>?>
  _readCachedPackages() async {
    final cached = await _cache.readPackages();
    if (cached.isEmpty) return null;
    final sanitized = sanitizePublicPackagesJson(cached);
    return BillingRepositoryResult(
      data: sanitized.map(CoinPackage.fromJson).toList(),
      isFromCache: true,
    );
  }

  BillingRepositoryException _mapBillingError(
    Object error,
    String fallbackCode,
  ) {
    if (error is BillingRepositoryException) return error;
    if (error is PublicBillingSanitizationException) {
      return BillingRepositoryException(
        error.code,
        _messageForCode(error.code),
      );
    }
    if (error is BillingApiDataSourceException) {
      return BillingRepositoryException(
        error.code,
        _messageForCode(error.code),
      );
    }
    if (error is FormatException || error is TypeError) {
      return BillingRepositoryException(
        fallbackCode,
        _messageForCode(fallbackCode),
      );
    }
    return BillingRepositoryException(
      fallbackCode,
      _messageForCode(fallbackCode),
    );
  }
}

class BillingRepositoryResult<T> {
  const BillingRepositoryResult({
    required this.data,
    required this.isFromCache,
    this.refreshError,
  });

  final T data;
  final bool isFromCache;
  final BillingRepositoryException? refreshError;

  BillingRepositoryResult<T> copyWith({
    T? data,
    bool? isFromCache,
    BillingRepositoryException? refreshError,
  }) {
    return BillingRepositoryResult<T>(
      data: data ?? this.data,
      isFromCache: isFromCache ?? this.isFromCache,
      refreshError: refreshError ?? this.refreshError,
    );
  }
}

class BillingRepositoryException implements Exception {
  const BillingRepositoryException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'BillingRepositoryException($code, $message)';
}

String _messageForCode(String code) {
  return switch (code) {
    'balance_unavailable' => 'Баланс временно недоступен. Попробуйте позже.',
    'packages_unavailable' => 'Пакеты временно недоступны. Попробуйте позже.',
    'pricing_unavailable' => 'Данные по коинам временно недоступны.',
    'backend_contract_violation' =>
      'Данные по коинам временно недоступны. Мы уже готовим обновление.',
    'network_unavailable' =>
      'Не удалось обновить данные. Проверьте подключение или попробуйте позже.',
    _ => 'Не удалось загрузить данные по коинам. Попробуйте позже.',
  };
}
