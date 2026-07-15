import 'package:dio/dio.dart';

abstract class ContentCardsApiDataSource {
  Future<Map<String, dynamic>> fetchCards({
    required String surface,
    required String locale,
  });
}

class LiveContentCardsApiDataSource implements ContentCardsApiDataSource {
  LiveContentCardsApiDataSource(this._dio);

  final Dio _dio;

  @override
  Future<Map<String, dynamic>> fetchCards({
    required String surface,
    required String locale,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      'content/cards',
      queryParameters: {'surface': surface, 'locale': locale},
    );
    final data = response.data;
    if (data == null) {
      throw const ContentCardsApiDataSourceException(
        'empty_response',
        'Content cards response is empty.',
      );
    }
    return data;
  }
}

class DisabledContentCardsApiDataSource implements ContentCardsApiDataSource {
  const DisabledContentCardsApiDataSource();

  @override
  Future<Map<String, dynamic>> fetchCards({
    required String surface,
    required String locale,
  }) {
    throw const ContentCardsApiDataSourceException(
      'network_disabled',
      'Content cards API is disabled until API_BASE_URL is configured.',
    );
  }
}

class ContentCardsApiDataSourceException implements Exception {
  const ContentCardsApiDataSourceException(this.code, this.message);

  final String code;
  final String message;

  @override
  String toString() => 'ContentCardsApiDataSourceException($code, $message)';
}
