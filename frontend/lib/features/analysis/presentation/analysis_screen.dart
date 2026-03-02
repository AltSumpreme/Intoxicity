import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../journal/domain/analysis_result.dart';

class AnalysisViewData {
  AnalysisViewData({required this.entry, required this.result});

  final String entry;
  final AnalysisResult result;
}

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key, required this.result});

  final AnalysisViewData result;

  @override
  Widget build(BuildContext context) {
    final data = result.result;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Emotional Insight Report')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GlassCard(
            child: Column(
              children: [
                Text('${data.toxicityScore.toStringAsFixed(1)}', style: Theme.of(context).textTheme.displaySmall),
                const Text('Toxicity score'),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: data.toxicityScore / 100),
                  duration: const Duration(milliseconds: 900),
                  builder: (_, value, __) => CircularProgressIndicator(
                    value: value,
                    minHeight: 12,
                    color: cs.primary,
                    backgroundColor: cs.primary.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [cs.primary, cs.secondary]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(data.riskLevel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emotional Breakdown', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      gridData: const FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      barGroups: data.emotionalProfile.entries.toList().asMap().entries.map((entry) {
                        return BarChartGroupData(x: entry.key, barRods: [
                          BarChartRodData(toY: entry.value.value, gradient: LinearGradient(colors: [cs.secondary, cs.primary]))
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ...data.topBehaviors.map(
            (behavior) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                collapsedBackgroundColor: cs.surface,
                backgroundColor: cs.surfaceContainerHighest,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                title: Text(behavior.behavior),
                subtitle: Text('Severity ${(behavior.severity * 100).toStringAsFixed(0)}%'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Evidence: "${behavior.sentence}"\n\nTone: ${behavior.sentimentLabel}'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
