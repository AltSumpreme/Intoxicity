import 'package:flutter/material.dart';

import '../../../shared/widgets/glass_card.dart';
import '../../journal/domain/analysis_result.dart';
import 'widgets/behavior_card.dart';
import 'widgets/score_aura.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Your Emotional Clarity')),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 420),
        opacity: 1,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ScoreAura(score: data.toxicityScore),
            const SizedBox(height: 18),
            Text('Patterns Detected', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            ...data.topBehaviors.map((behavior) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BehaviorCard(behavior: behavior),
                )),
            const SizedBox(height: 12),
            Text('How This May Be Affecting You', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            GlassCard(
              child: Text(data.emotionalShiftSummary, style: Theme.of(context).textTheme.bodyLarge),
            ),
            const SizedBox(height: 18),
            Text('You Deserve Clarity.', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Take this insight as affirmation, not blame. You are allowed to trust your perception, honor your boundaries, and seek relationships that feel safe and reciprocal.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
