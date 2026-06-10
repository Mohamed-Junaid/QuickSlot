import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/slot_model.dart';

/// One slot in the grid. Renders Available or Booked. No tap action yet.
class SlotTile extends StatelessWidget {
  const SlotTile({super.key, required this.slot});

  final Slot slot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final booked = slot.isBooked;

    final background = booked ? cs.surfaceContainerHighest : cs.primaryContainer;
    final foreground = booked ? cs.onSurfaceVariant : cs.onPrimaryContainer;
    final border = booked ? cs.outlineVariant : cs.primary;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppDateUtils.timeLabel(slot.startTime),
            style: theme.textTheme.titleSmall
                ?.copyWith(color: foreground, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            booked ? 'Booked' : 'Available',
            style: theme.textTheme.labelSmall?.copyWith(color: foreground),
          ),
        ],
      ),
    );
  }
}
