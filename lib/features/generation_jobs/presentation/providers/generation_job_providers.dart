import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/mock_allai_api.dart';
import '../../../../core/api/mock_api_providers.dart';
import '../../../billing/presentation/providers/billing_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../data/generation_repository.dart';
import '../../domain/generation_job_models.dart';

final generationRepositoryProvider = Provider<GenerationRepository>((ref) {
  return MockGenerationRepository(ref.watch(mockAllAiApiProvider));
});

final generationJobControllerProvider =
    NotifierProvider<
      GenerationJobController,
      AsyncValue<GenerationJobResponse?>
    >(GenerationJobController.new);

class GenerationJobController
    extends Notifier<AsyncValue<GenerationJobResponse?>> {
  @override
  AsyncValue<GenerationJobResponse?> build() => const AsyncValue.data(null);

  Future<GenerationJobResponse?> createMockJob({
    required String modelId,
    required String prompt,
    String? templateId,
    Map<String, Object?> settings = const {'aspectRatio': '9:16'},
  }) async {
    state = const AsyncValue.loading();
    try {
      final response = await ref
          .read(generationRepositoryProvider)
          .createAndRunJob(
            CreateGenerationJobInput(
              modelId: modelId,
              templateId: templateId,
              prompt: prompt,
              settings: settings,
              clientRequestId:
                  'client-${DateTime.now().microsecondsSinceEpoch}',
            ),
          );
      ref
        ..invalidate(balanceStateProvider)
        ..invalidate(balanceProvider)
        ..invalidate(coinTransactionsStateProvider)
        ..invalidate(coinTransactionsProvider)
        ..invalidate(libraryHistoryProvider);
      state = AsyncValue.data(response);
      return response;
    } on MockApiException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }
}
