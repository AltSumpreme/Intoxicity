import 'dart:ui';

import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25)),
          ),
          padding: const EdgeInsets.all(18),
          child: child,
        ),
      ),
    );
  }
}
