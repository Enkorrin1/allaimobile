import '../../../core/api/public_billing_sanitizer.dart';
import '../../../core/database/app_database.dart';

class BillingCacheDataSource {
  const BillingCacheDataSource(this._database);

  static const defaultUserId = 'demo-user';

  final AppDatabase _database;

  Future<Map<String, dynamic>?> readBalance() {
    return _database.readBillingSnapshot(defaultUserId);
  }

  Future<void> writeBalance(Map<String, dynamic> balanceJson) {
    final sanitized = sanitizePublicBalanceJson(
      balanceJson,
      defaultUserId: defaultUserId,
    );
    return _database.writeBillingSnapshot(
      userId: sanitized['userId'] as String,
      coinBalance: sanitized['coinBalance'] as int,
      reservedCoins: sanitized['reservedCoins'] as int,
      updatedAt: DateTime.parse(sanitized['updatedAt'] as String),
    );
  }

  Future<List<Map<String, dynamic>>> readPackages() {
    return _database.readCoinPackages();
  }

  Future<void> writePackages(List<Map<String, dynamic>> packagesJson) async {
    final packages = sanitizePublicPackagesJson(packagesJson);
    for (final package in packages) {
      await _database.writeCoinPackage(package);
    }
  }

  Future<List<Map<String, dynamic>>> readTransactions() {
    return _database.readCoinTransactions();
  }
}
