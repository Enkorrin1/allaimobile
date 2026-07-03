import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import 'mock_allai_api.dart';

final mockAllAiApiProvider = Provider<MockAllAiApi>((ref) {
  return MockAllAiApi(database: ref.watch(appDatabaseProvider));
});
