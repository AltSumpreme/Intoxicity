import 'package:dio/dio.dart';

final class ApiClient {
  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8000/api/v1'),
              connectTimeout: const Duration(seconds: 20),
              receiveTimeout: const Duration(seconds: 60),
            ));

  final Dio _dio;

  Future<Map<String, dynamic>> analyze(String content) async {
    final response = await _dio.post('/analyze', data: {'content': content});
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<List<Map<String, dynamic>>> history() async {
    final response = await _dio.get('/history');
    return List<Map<String, dynamic>>.from(response.data as List);
  }
}
