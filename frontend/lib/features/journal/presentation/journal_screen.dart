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

class _JournalScreenState extends ConsumerState<JournalScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  bool _loading = false;
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat();

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
  void dispose() {
    _controller.dispose();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intoxicity'),
        actions: [IconButton(onPressed: () => context.push('/history'), icon: const Icon(Icons.history))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 420),
              opacity: 1,
              child: Text('Tell your story.\nFeel your clarity.', style: Theme.of(context).textTheme.displaySmall),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: cs.surface.withValues(alpha: 0.95),
                  hintText: 'What happened, and how did it feel in your body and mind?',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(color: cs.primary.withValues(alpha: 0.12), width: 1),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            AnimatedBuilder(
              animation: _shimmer,
              builder: (_, __) {
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(-1 + (_shimmer.value * 2), -0.2),
                      end: Alignment(1, 0.2),
                      colors: [cs.primary, cs.secondary, cs.primary],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: cs.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 2),
                    ],
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
                        : const Text('Analyze My Story'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
