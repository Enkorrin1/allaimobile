import 'package:dio/dio.dart';

import '../config/env.dart';

class DioClient {
  DioClient() : dio = Dio(BaseOptions(baseUrl: Env.apiBaseUrl));

  final Dio dio;
}
