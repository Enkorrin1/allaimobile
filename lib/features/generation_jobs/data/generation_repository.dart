import '../../../core/api/mock_allai_api.dart';
import '../domain/generation_job_models.dart';

abstract class GenerationRepository {
  Future<CreateGenerationJobResponse> createJob(CreateGenerationJobInput input);
  Future<GenerationJobResponse> advanceJob(String jobId);
  Future<GenerationJobResponse> getJob(String jobId);
  Future<GenerationJobResponse> createAndRunJob(CreateGenerationJobInput input);
}

class MockGenerationRepository implements GenerationRepository {
  const MockGenerationRepository(this._api);

  final MockAllAiApi _api;

  @override
  Future<CreateGenerationJobResponse> createJob(
    CreateGenerationJobInput input,
  ) async {
    return CreateGenerationJobResponse.fromJson(
      await _api.createGenerationJob(input.toJson()),
    );
  }

  @override
  Future<GenerationJobResponse> advanceJob(String jobId) async {
    return GenerationJobResponse.fromJson(
      await _api.advanceGenerationJob(jobId),
    );
  }

  @override
  Future<GenerationJobResponse> getJob(String jobId) async {
    return GenerationJobResponse.fromJson(await _api.getGenerationJob(jobId));
  }

  @override
  Future<GenerationJobResponse> createAndRunJob(
    CreateGenerationJobInput input,
  ) async {
    final created = await createJob(input);
    var response = GenerationJobResponse(job: created.job, assets: const []);
    while (!response.job.isTerminal) {
      response = await advanceJob(response.job.id);
    }
    return response;
  }
}
