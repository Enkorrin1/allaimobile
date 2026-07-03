import '../../../core/api/public_catalog_sanitizer.dart';
import '../../../core/database/app_database.dart';

class CatalogCacheDataSource {
  const CatalogCacheDataSource(this._database);

  static const currentSnapshotId = 'current';

  final AppDatabase _database;

  Future<Map<String, dynamic>?> readCatalog() {
    return _database.readCatalogSnapshot(currentSnapshotId);
  }

  Future<void> writeCatalog(Map<String, dynamic> catalogJson) {
    return _database.writeCatalogSnapshot(
      currentSnapshotId,
      sanitizePublicCatalogJson(catalogJson),
    );
  }
}
