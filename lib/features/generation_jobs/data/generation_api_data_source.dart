import '../../../core/api/mock_allai_api.dart';

abstract class GenerationApiDataSource {
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> request);
  Future<Map<String, dynamic>> fetchJob(String jobId);
  Future<Map<String, dynamic>> pollJob(String jobId);
  Future<List<Map<String, dynamic>>> fetchJobs();
}

class MockGenerationApiDataSource implements GenerationApiDataSource {
  const MockGenerationApiDataSource(this._api);

  final MockAllAiApi _api;

  @override
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> request) {
    return _safeCall(() => _api.createGenerationJob(request));
  }

  @override
  Future<Map<String, dynamic>> fetchJob(String jobId) {
    return _safeCall(() => _api.getGenerationJob(jobId));
  }

  @override
  Future<Map<String, dynamic>> pollJob(String jobId) {
    return _safeCall(() => _api.advanceGenerationJob(jobId));
  }

  @override
  Future<List<Map<String, dynamic>>> fetchJobs() {
    return _safeCall(() => _api.getJobs());
  }

  Future<T> _safeCall<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on MockApiException catch (error) {
      throw GenerationApiDataSourceException(error.code, error.message);
    }
  }
}

class DisabledLiveGenerationApiDataSource implements GenerationApiDataSource {
  const DisabledLiveGenerationApiDataSource();

  @override
  Future<Map<String, dynamic>> createJob(Map<String, dynamic> request) {
    throw const GenerationApiDataSourceException(
      'network_unavailable',
      'Live generation adapter is disabled until an approved API base URL exists.',
    );
  }

  @override
  Future<Map<String, dynamic>> fetchJob(String jobId) {
    throw const GenerationApiDataSourceException(
      'network_unavailable',
      'Live generation adapter is disabled until an approved API base URL exists.',
    );
  }

  @override
  Future<Map<String, dynamic>> pollJob(String jobId) {
    throw const GenerationApiDataSourceException(
      'network_unavailable',
      'Live generation adapter is disabled until an approved API base URL exists.',
    );
  }

  @override
  Future<List<Map<String, dynamic>>> fetchJobs() {
    throw const GenerationApiDataSourceException(
      'network_unavailable',
      'Live generation adapter is disabled until an approved API base URL exists.',
    );
  }
}

class GenerationApiDataSourceException implements Exception {
  const GenerationApiDataSourceException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'GenerationApiDataSourceException($code, $message)';
}
