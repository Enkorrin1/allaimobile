import 'dart:convert';

import '../../../core/database/app_database.dart';

class ContentCardsCacheDataSource {
  const ContentCardsCacheDataSource(this._database);

  final AppDatabase _database;

  Future<Map<String, dynamic>?> readCards({
    required String surface,
    required String locale,
  }) async {
    final raw = await _database.readMetadata(_key(surface, locale));
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> writeCards({
    required String surface,
    required String locale,
    required Map<String, dynamic> json,
  }) {
    return _database.writeMetadata(
      _key(surface, locale),
      jsonEncode(json),
      DateTime.now().toUtc(),
    );
  }

  String _key(String surface, String locale) {
    return 'content_cards_${surface}_$locale';
  }
}
