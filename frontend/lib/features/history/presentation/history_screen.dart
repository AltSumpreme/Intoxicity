import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../analysis/presentation/analysis_screen.dart';
import '../../journal/data/providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reflection History')),
      body: history.when(
        data: (entries) => ListView.separated(
          padding: const EdgeInsets.all(20),
          itemBuilder: (context, index) {
            final item = entries[index];
            return ListTile(
              tileColor: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              leading: CircleAvatar(
                backgroundColor: _riskColor(item.toxicityScore),
                radius: 8,
              ),
              title: Text(item.riskLevel),
              subtitle: Text(
                '${item.toxicityScore.round()} • ${item.createdAt != null ? DateFormat.yMMMd().add_jm().format(item.createdAt!) : 'now'}',
              ),
              onTap: () => context.push(
                '/analysis',
                extra: AnalysisViewData(entry: item.content ?? '', result: item),
              ),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemCount: entries.length,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Unable to load history right now.')),
      ),
    );
  }

  Color _riskColor(double score) {
    if (score <= 25) return Colors.green;
    if (score <= 50) return Colors.orange;
    if (score <= 75) return Colors.deepOrange;
    return Colors.red;
  }
}
