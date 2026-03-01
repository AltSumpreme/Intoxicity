import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/core/network/api_client.dart';
import '../domain/analysis_result.dart';
import 'journal_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => JournalRepository(ref.read(apiClientProvider)),
);

final historyProvider = FutureProvider<List<AnalysisResult>>(
  (ref) => ref.read(journalRepositoryProvider).history(),
);
