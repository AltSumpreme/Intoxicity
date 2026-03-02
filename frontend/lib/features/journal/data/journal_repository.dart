import '../../../app/core/network/api_client.dart';
import '../domain/analysis_result.dart';

class JournalRepository {
  JournalRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AnalysisResult> analyze(String content) async {
    final json = await _apiClient.analyze(content);
    return AnalysisResult.fromJson(json);
  }

  Future<List<AnalysisResult>> history() async {
    final payload = await _apiClient.history();
    return payload.map(AnalysisResult.fromJson).toList();
  }
}
