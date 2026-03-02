import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cs.surface.withValues(alpha: 0.72),
                cs.surface.withValues(alpha: 0.52),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: cs.primary.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(color: cs.primary.withValues(alpha: 0.08), blurRadius: 22, spreadRadius: 1),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: child,
        ),
      ),
    );
  }
}
