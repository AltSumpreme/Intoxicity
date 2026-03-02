import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../analysis/presentation/analysis_screen.dart';
import '../data/providers.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  Future<void> _submit() async {
    if (_controller.text.trim().length < 20) return;
    setState(() => _loading = true);
    final repository = ref.read(journalRepositoryProvider);
    try {
      final result = await repository.analyze(_controller.text.trim());
      if (!mounted) return;
      context.push('/analysis', extra: AnalysisViewData(entry: _controller.text.trim(), result: result));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intoxicity Journal'),
        actions: [IconButton(onPressed: () => context.push('/history'), icon: const Icon(Icons.history))],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 900),
        opacity: 1,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Speak your truth, softly.', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: cs.surface,
                    hintText: 'Write what happened. Your reflection stays compassionate and private...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: BorderSide(color: cs.primary, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: cs.primary.withValues(alpha: 0.35), blurRadius: 18, spreadRadius: 2)],
                ),
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: _loading
                      ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Analyze My Narrative'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
