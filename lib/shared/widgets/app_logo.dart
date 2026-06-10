import 'package:flutter/material.dart';

/// App logo placeholder — a rounded badge with the brand glyph. Swap the icon
/// for a real asset later without touching call sites.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.event_available_rounded,
        size: size * 0.55,
        color: cs.onPrimary,
      ),
    );
  }
}
