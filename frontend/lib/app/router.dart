import 'package:go_router/go_router.dart';

import '../features/analysis/presentation/analysis_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/journal/presentation/journal_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const JournalScreen()),
    GoRoute(path: '/analysis', builder: (context, state) {
      final result = state.extra as AnalysisViewData;
      return AnalysisScreen(result: result);
    }),
    GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
  ],
);
