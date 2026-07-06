import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/mock_api_providers.dart';
import 'generation_api_data_source.dart';
import 'generation_repository.dart';

final generationApiDataSourceProvider = Provider<GenerationApiDataSource>((
  ref,
) {
  return MockGenerationApiDataSource(ref.watch(mockAllAiApiProvider));
});

final generationRepositoryProvider = Provider<GenerationRepository>((ref) {
  return MockGenerationRepository(ref.watch(generationApiDataSourceProvider));
});
