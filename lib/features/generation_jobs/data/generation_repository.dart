import '../domain/generation_job_models.dart';
import 'generation_api_data_source.dart';

abstract class GenerationRepository {
  Future<CreateGenerationJobResponse> createJob(CreateGenerationJobInput input);
  Future<GenerationJobResponse> pollJob(String jobId);
  Future<GenerationJobResponse> getJob(String jobId);
  Future<List<GenerationJob>> getJobs();
}

class MockGenerationRepository implements GenerationRepository {
  const MockGenerationRepository(this._api);

  final GenerationApiDataSource _api;

  @override
  Future<CreateGenerationJobResponse> createJob(
    CreateGenerationJobInput input,
  ) async {
    try {
      return CreateGenerationJobResponse.fromJson(
        await _api.createJob(input.toJson()),
      );
    } on Object catch (error) {
      throw _mapGenerationError(error);
    }
  }

  @override
  Future<GenerationJobResponse> pollJob(String jobId) async {
    try {
      return GenerationJobResponse.fromJson(await _api.pollJob(jobId));
    } on Object catch (error) {
      throw _mapGenerationError(error);
    }
  }

  @override
  Future<GenerationJobResponse> getJob(String jobId) async {
    try {
      return GenerationJobResponse.fromJson(await _api.fetchJob(jobId));
    } on Object catch (error) {
      throw _mapGenerationError(error);
    }
  }

  @override
  Future<List<GenerationJob>> getJobs() async {
    try {
      final jobs = await _api.fetchJobs();
      return jobs.map(GenerationJob.fromJson).toList();
    } on Object catch (error) {
      throw _mapGenerationError(error);
    }
  }

  GenerationRepositoryException _mapGenerationError(Object error) {
    if (error is GenerationRepositoryException) return error;
    if (error is GenerationApiDataSourceException) {
      return GenerationRepositoryException(
        error.code,
        _messageForCode(error.code),
      );
    }
    if (error is FormatException || error is TypeError) {
      return GenerationRepositoryException(
        'backend_contract_violation',
        _messageForCode('backend_contract_violation'),
      );
    }
    return GenerationRepositoryException(
      'generation_unavailable',
      _messageForCode('generation_unavailable'),
    );
  }
}

class GenerationRepositoryException implements Exception {
  const GenerationRepositoryException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'GenerationRepositoryException($code, $message)';
}

String _messageForCode(String code) {
  return switch (code) {
    'insufficient_balance' => 'Недостаточно койнов для запуска генерации.',
    'invalid_prompt' => 'Добавьте описание изображения.',
    'model_unavailable' => 'Выбранная модель временно недоступна.',
    'template_unavailable' => 'Выбранный шаблон временно недоступен.',
    'job_not_found' => 'Задача не найдена.',
    'network_unavailable' => 'Генерация временно недоступна. Попробуйте позже.',
    'backend_contract_violation' =>
      'Не удалось прочитать состояние генерации. Мы уже готовим обновление.',
    _ => 'Не удалось выполнить генерацию. Попробуйте позже.',
  };
}
