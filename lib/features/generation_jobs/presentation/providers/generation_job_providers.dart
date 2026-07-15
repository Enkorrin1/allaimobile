import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../billing/presentation/providers/billing_providers.dart';
import '../../../library/presentation/providers/library_providers.dart';
import '../../data/generation_data_providers.dart';
import '../../data/generation_repository.dart';
import '../../domain/generation_job_models.dart';

final generationPollingDelaysProvider = Provider<List<Duration>>((ref) {
  return const [
    Duration(milliseconds: 250),
    Duration(milliseconds: 300),
    Duration(milliseconds: 350),
    Duration(milliseconds: 400),
  ];
});

final generationJobControllerProvider =
    NotifierProvider<
      GenerationJobController,
      AsyncValue<GenerationJobResponse?>
    >(GenerationJobController.new);

class GenerationJobController
    extends Notifier<AsyncValue<GenerationJobResponse?>> {
  int _pollToken = 0;

  GenerationJobResponse? get _currentResponse => state.asData?.value;

  @override
  AsyncValue<GenerationJobResponse?> build() {
    ref.onDispose(() => _pollToken += 1);
    return const AsyncValue.data(null);
  }

  Future<GenerationJobResponse?> createPromptOnlyJob({
    required String modelId,
    required String prompt,
    String? templateId,
    Map<String, Object?> settings = const {'aspectRatio': '9:16'},
    List<String> inputAssetIds = const [],
  }) async {
    final cleanPrompt = prompt.trim();
    if (cleanPrompt.isEmpty) {
      final error = const GenerationRepositoryException(
        'invalid_prompt',
        'Добавьте описание изображения',
      );
      state = AsyncValue.error(error, StackTrace.current);
      return null;
    }

    final token = ++_pollToken;
    state = const AsyncValue.loading();
    try {
      final created = await ref
          .read(generationRepositoryProvider)
          .createJob(
            CreateGenerationJobInput(
              modelId: modelId,
              templateId: templateId,
              prompt: cleanPrompt,
              inputAssetIds: inputAssetIds,
              settings: settings,
              clientRequestId:
                  'client-${DateTime.now().microsecondsSinceEpoch}',
            ),
          );
      final response = GenerationJobResponse(
        job: created.job,
        assets: const [],
      );
      state = AsyncValue.data(response);
      _invalidateRuntimeState();
      return _pollUntilTerminal(created.job.id, token, lastValid: response);
    } on GenerationRepositoryException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  Future<GenerationJobResponse?> retryJob(GenerationJob job) {
    return createPromptOnlyJob(
      modelId: job.modelId,
      templateId: job.templateId,
      prompt: job.prompt,
      settings: job.settings,
    );
  }

  Future<GenerationJobResponse?> restoreLatestActiveJob() async {
    if (state.isLoading) return _currentResponse;
    try {
      final jobs = await ref.read(generationRepositoryProvider).getJobs();
      GenerationJob? activeJob;
      for (final job in jobs) {
        if (!job.isTerminal) {
          activeJob = job;
          break;
        }
      }
      if (activeJob == null) return _currentResponse;

      final token = ++_pollToken;
      final response = await ref
          .read(generationRepositoryProvider)
          .getJob(activeJob.id);
      state = AsyncValue.data(response);
      return _pollUntilTerminal(activeJob.id, token, lastValid: response);
    } on GenerationRepositoryException catch (error, stackTrace) {
      final currentResponse = _currentResponse;
      if (currentResponse != null) return currentResponse;
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  Future<GenerationJobResponse?> pollJob(String jobId) async {
    final token = ++_pollToken;
    return _pollUntilTerminal(jobId, token, lastValid: _currentResponse);
  }

  Future<GenerationJobResponse?> _pollUntilTerminal(
    String jobId,
    int token, {
    GenerationJobResponse? lastValid,
  }) async {
    var response = lastValid;
    final delays = ref.read(generationPollingDelaysProvider);
    var step = 0;

    while (token == _pollToken && response?.job.isTerminal != true) {
      final delayIndex = step >= delays.length ? delays.length - 1 : step;
      final delay = delays[delayIndex];
      if (delay > Duration.zero) await Future<void>.delayed(delay);
      if (token != _pollToken) return response;

      try {
        response = await ref.read(generationRepositoryProvider).pollJob(jobId);
        state = AsyncValue.data(response);
        _invalidateRuntimeState();
      } on GenerationRepositoryException catch (error, stackTrace) {
        if (response != null) {
          state = AsyncValue.data(response);
          return response;
        }
        state = AsyncValue.error(error, stackTrace);
        return null;
      }
      step += 1;
    }

    return response;
  }

  void _invalidateRuntimeState() {
    ref
      ..invalidate(balanceStateProvider)
      ..invalidate(balanceProvider)
      ..invalidate(coinTransactionsStateProvider)
      ..invalidate(coinTransactionsProvider)
      ..invalidate(libraryHistoryProvider);
  }
}

String generationProgressLabel(GenerationJobStatus status) => switch (status) {
  GenerationJobStatus.draft => 'Черновик',
  GenerationJobStatus.validating => 'Проверяем запрос',
  GenerationJobStatus.queued => 'Задача в очереди',
  GenerationJobStatus.running => 'Генерируем изображение',
  GenerationJobStatus.processing => 'Сохраняем результат',
  GenerationJobStatus.completed => 'Готово',
  GenerationJobStatus.failed => 'Ошибка генерации',
  GenerationJobStatus.canceled => 'Отменено',
  GenerationJobStatus.refunded => 'Возврат',
};

String generationErrorCopy(Object error) {
  if (error is GenerationRepositoryException) return error.message;
  return 'Не удалось выполнить генерацию. Попробуйте позже.';
}
