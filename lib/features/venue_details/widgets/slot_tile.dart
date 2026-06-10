import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/slot_model.dart';

/// One slot in the grid. Available slots are tappable to book; booked slots are
/// inert. While its booking is in flight, the tile shows a spinner.
class SlotTile extends StatelessWidget {
  const SlotTile({
    super.key,
    required this.slot,
    this.onTap,
    this.isLoading = false,
  });

  final Slot slot;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final booked = slot.isBooked;

    final background = booked ? cs.surfaceContainerHighest : cs.primaryContainer;
    final foreground = booked ? cs.onSurfaceVariant : cs.onPrimaryContainer;
    final border = booked ? cs.outlineVariant : cs.primary;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        // Only available slots that aren't mid-booking accept a tap.
        onTap: (booked || isLoading) ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppDateUtils.timeLabel(slot.startTime),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: foreground,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booked ? 'Booked' : 'Available',
                        style: theme.textTheme.labelSmall
                            ?.copyWith(color: foreground),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
