import 'package:flutter/material.dart';

class ScoreAura extends StatefulWidget {
  const ScoreAura({super.key, required this.score});

  final double score;

  @override
  State<ScoreAura> createState() => _ScoreAuraState();
}

class _ScoreAuraState extends State<ScoreAura> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final roundedScore = widget.score.round();
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final glow = 24 + (_controller.value * 20);
        return Container(
          height: 250,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                cs.primary.withValues(alpha: 0.32),
                cs.primary.withValues(alpha: 0.08),
                Colors.transparent,
              ],
              stops: const [0.1, 0.58, 1],
            ),
            boxShadow: [
              BoxShadow(color: cs.primary.withValues(alpha: 0.3), blurRadius: glow, spreadRadius: 2),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _headlineLabel(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text('$roundedScore', style: Theme.of(context).textTheme.displaySmall),
              Text('risk score', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }

  String _headlineLabel() {
    if (widget.score >= 75) return 'High Emotional Risk';
    if (widget.score >= 50) return 'Elevated Emotional Risk';
    if (widget.score >= 25) return 'Moderate Emotional Risk';
    return 'Low Emotional Risk';
  }
}
