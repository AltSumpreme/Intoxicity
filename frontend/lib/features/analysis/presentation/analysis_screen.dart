import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../journal/domain/analysis_result.dart';

class AnalysisViewData {
  AnalysisViewData({required this.entry, required this.result});

  final String entry;
  final AnalysisResult result;
}

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key, required this.result});

  final AnalysisViewData result;

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _pageAnimationController;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _pageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
    _fade = CurvedAnimation(parent: _pageAnimationController, curve: Curves.easeOutQuart);
  }

  @override
  void dispose() {
    _pageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.result.result;
    final cs = Theme.of(context).colorScheme;
    final topBehaviors = data.topBehaviors.take(5).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Emotional Insight Report')),
      body: Stack(
        children: [
          _AnimatedAnalysisBackdrop(color: cs.primary),
          FadeTransition(
            opacity: _fade,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _AnimatedEntry(
                  delay: 0,
                  child: GlassCard(
                    child: Column(
                      children: [
                        Text('${data.toxicityScore.toStringAsFixed(1)}', style: Theme.of(context).textTheme.displaySmall),
                        const Text('Toxicity score'),
                        const SizedBox(height: 10),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: data.toxicityScore / 100),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (_, value, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: LinearProgressIndicator(
                              value: value,
                              minHeight: 14,
                              color: cs.primary,
                              backgroundColor: cs.primary.withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            data.riskLevel,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _AnimatedEntry(
                  delay: 120,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Emotional Breakdown', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text('Higher bars indicate stronger emotional weight in the narrative.'),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 240,
                          child: BarChart(
                            BarChartData(
                              maxY: 1,
                              gridData: FlGridData(
                                show: true,
                                horizontalInterval: 0.25,
                                getDrawingHorizontalLine: (_) => FlLine(
                                  color: cs.primary.withValues(alpha: 0.08),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: (value, _) => Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) {
                                      final keys = data.emotionalProfile.keys.toList();
                                      final idx = value.toInt();
                                      if (idx < 0 || idx >= keys.length) return const SizedBox.shrink();
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          keys[idx].substring(0, 3).toUpperCase(),
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              barGroups: data.emotionalProfile.entries.toList().asMap().entries.map((entry) {
                                return BarChartGroupData(x: entry.key, barRods: [
                                  BarChartRodData(
                                    toY: entry.value.value,
                                    width: 18,
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(colors: [cs.secondary, cs.primary]),
                                  ),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _AnimatedEntry(
                  delay: 220,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.priority_high_rounded, color: cs.primary),
                            const SizedBox(width: 8),
                            Text('Top 5 Harmful Behaviors', style: Theme.of(context).textTheme.titleLarge),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('These are the strongest recurring patterns detected in this entry.'),
                        const SizedBox(height: 12),
                        if (topBehaviors.isEmpty)
                          const Text('No harmful behavior patterns were strongly detected in this reflection.'),
                        ...topBehaviors.asMap().entries.map(
                          (entry) {
                            final index = entry.key;
                            final behavior = entry.value;
                            return _AnimatedEntry(
                              delay: 300 + (index * 100),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ExpansionTile(
                                  collapsedBackgroundColor: cs.surface,
                                  backgroundColor: cs.surfaceContainerHighest,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  title: Row(
                                    children: [
                                      Container(
                                        height: 28,
                                        width: 28,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(colors: [cs.secondary, cs.primary]),
                                        ),
                                        child: Text('#${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(behavior.behavior)),
                                    ],
                                  ),
                                  subtitle: Text(
                                    'Severity ${(behavior.severity * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(color: cs.primary, fontWeight: FontWeight.w600),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Evidence', style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 6),
                                          Text('"${behavior.sentence}"'),
                                          const SizedBox(height: 8),
                                          Text('Detected tone: ${behavior.sentimentLabel}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedEntry extends StatelessWidget {
  const _AnimatedEntry({required this.child, required this.delay});

  final Widget child;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 700 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, inner) {
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(0, 22 * (1 - value)), child: inner),
        );
      },
      child: child,
    );
  }
}

class _AnimatedAnalysisBackdrop extends StatefulWidget {
  const _AnimatedAnalysisBackdrop({required this.color});

  final Color color;

  @override
  State<_AnimatedAnalysisBackdrop> createState() => _AnimatedAnalysisBackdropState();
}

class _AnimatedAnalysisBackdropState extends State<_AnimatedAnalysisBackdrop> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat(reverse: true);
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
              top: -110 + (24 * t),
              left: -90,
              child: _Bubble(size: 250, color: widget.color.withValues(alpha: 0.08)),
            ),
            Positioned(
              top: 160,
              right: -70 + (20 * math.sin(math.pi * t)),
              child: _Bubble(size: 200, color: cs.secondary.withValues(alpha: 0.08)),
            ),
          ],
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.size, required this.color});

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
