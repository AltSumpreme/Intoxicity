import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../analysis/presentation/analysis_screen.dart';
import '../data/providers.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  bool _loading = false;

  static const _prompts = [
    'What happened today that made me feel small?',
    'Which words felt comforting vs controlling?',
    'When did I feel safest in this relationship?',
    'What boundary did I want to set but could not?',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_controller.text.trim().length < 20) return;
    setState(() => _loading = true);
    final repository = ref.read(journalRepositoryProvider);
    try {
      final content = _controller.text.trim();
      final result = await repository.analyze(content);
      if (!mounted) return;
      context.push('/analysis', extra: AnalysisViewData(entry: content, result: result));
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
        actions: [
          IconButton(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.auto_stories_rounded),
            tooltip: 'History',
          ),
        ],
      ),
      body: Stack(
        children: [
          const _AnimatedAuraBackground(),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Text('Speak your truth, softly.', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 6),
                  Text(
                    'We listen for patterns so your reflection feels clear, grounded, and empowering.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.favorite_rounded, color: cs.primary),
                            const SizedBox(width: 8),
                            Text('Daily Reflection', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          decoration: BoxDecoration(
                            color: cs.surface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: cs.primary.withValues(alpha: 0.12),
                                blurRadius: 14,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            minLines: 5,
                            maxLines: 8,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(16),
                              hintText: 'Write what happened, how it felt, and what you needed in that moment...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(22),
                                borderSide: BorderSide(color: cs.primary, width: 1.8),
                              ),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_controller.text.trim().length} characters',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 52,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _prompts.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return ActionChip(
                          label: Text(_prompts[index]),
                          onPressed: () {
                            final base = _controller.text.trim();
                            _controller.text = base.isEmpty ? _prompts[index] : '$base\n\n${_prompts[index]}';
                            _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  _AnalyzeButton(loading: _loading, onPressed: _submit),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyzeButton extends StatelessWidget {
  const _AnalyzeButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      curve: Curves.easeOutBack,
      duration: const Duration(milliseconds: 650),
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.38),
              blurRadius: 26,
              spreadRadius: 3,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FilledButton.icon(
          onPressed: loading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          ),
          icon: loading
              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.auto_graph_rounded),
          label: Text(loading ? 'Analyzing your narrative...' : 'Reveal Emotional Patterns'),
        ),
      ),
    );
  }
}

class _AnimatedAuraBackground extends StatefulWidget {
  const _AnimatedAuraBackground();

  @override
  State<_AnimatedAuraBackground> createState() => _AnimatedAuraBackgroundState();
}

class _AnimatedAuraBackgroundState extends State<_AnimatedAuraBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        return Stack(
          children: [
            Positioned(
              top: -90 + (30 * t),
              left: -80,
              child: _AuraBlob(size: 240, color: cs.secondary.withValues(alpha: 0.14)),
            ),
            Positioned(
              top: 120,
              right: -70 + (20 * math.sin(t * math.pi)),
              child: _AuraBlob(size: 200, color: cs.primary.withValues(alpha: 0.10)),
            ),
            Positioned(
              bottom: -120 + (20 * t),
              right: 20,
              child: _AuraBlob(size: 260, color: cs.secondary.withValues(alpha: 0.10)),
            ),
          ],
        );
      },
    );
  }
}

class _AuraBlob extends StatelessWidget {
  const _AuraBlob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 20)],
        ),
      ),
    );
  }
}
