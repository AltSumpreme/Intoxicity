import 'package:flutter/material.dart';

import '../../../../shared/widgets/glass_card.dart';
import '../../../journal/domain/analysis_result.dart';

class BehaviorCard extends StatefulWidget {
  const BehaviorCard({super.key, required this.behavior});

  final BehaviorEvidence behavior;

  @override
  State<BehaviorCard> createState() => _BehaviorCardState();
}

class _BehaviorCardState extends State<BehaviorCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        child: GlassCard(
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: cs.primary, width: 4)),
            ),
            padding: const EdgeInsets.only(left: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(widget.behavior.category, style: Theme.of(context).textTheme.titleLarge)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text('Severity ${(widget.behavior.severity * 100).round()}%'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text('“${widget.behavior.evidence}”', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic)),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(widget.behavior.impactSummary),
                  ),
                  crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 320),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
