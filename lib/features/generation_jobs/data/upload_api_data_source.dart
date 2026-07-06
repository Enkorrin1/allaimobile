abstract class UploadApiDataSource {
  Future<Map<String, dynamic>> requestUploadUrl(Map<String, dynamic> request);
}

class MockUploadApiDataSource implements UploadApiDataSource {
  const MockUploadApiDataSource();

  @override
  Future<Map<String, dynamic>> requestUploadUrl(Map<String, dynamic> request) {
    final clientRequestId = request['clientRequestId'] as String? ?? 'local';
    return Future.value({
      'asset': {
        'id': 'input-$clientRequestId',
        'type': 'image',
        'role': 'input',
        'url': 'mock://uploads/input-$clientRequestId',
        'mimeType': request['mimeType'] ?? 'image/png',
        'sizeBytes': request['sizeBytes'] ?? 0,
        'createdAt': DateTime.utc(2026, 7, 3, 9).toIso8601String(),
      },
      'upload': {
        'method': 'PUT',
        'url': 'mock://upload/input-$clientRequestId',
        'expiresAt': DateTime.utc(2026, 7, 3, 9, 15).toIso8601String(),
      },
      'maxSizeBytes': 10 * 1024 * 1024,
    });
  }
}

class DisabledLiveUploadApiDataSource implements UploadApiDataSource {
  const DisabledLiveUploadApiDataSource();

  @override
  Future<Map<String, dynamic>> requestUploadUrl(Map<String, dynamic> request) {
    throw const UploadApiDataSourceException(
      'network_unavailable',
      'Live upload adapter is disabled until an approved API base URL exists.',
    );
  }
}

class UploadApiDataSourceException implements Exception {
  const UploadApiDataSourceException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'UploadApiDataSourceException($code, $message)';
}
