import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../../../data/models/booking_model.dart';

/// Card for a single booking: venue, date, slot time, status, and — for active
/// bookings — a cancel action. [isCancelling] shows a spinner in place of the
/// button while the cancel transaction runs.
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.booking,
    required this.onCancel,
    this.isCancelling = false,
  });

  final Booking booking;
  final VoidCallback onCancel;
  final bool isCancelling;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = booking.status == BookingStatus.booked;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.venueName, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  _IconLine(
                    icon: Icons.calendar_today_outlined,
                    text: AppDateUtils.fullDate(booking.startTime),
                  ),
                  const SizedBox(height: 4),
                  _IconLine(
                    icon: Icons.schedule_outlined,
                    text: '${AppDateUtils.timeLabel(booking.startTime)} - '
                        '${AppDateUtils.timeLabel(booking.endTime)}',
                  ),
                  const SizedBox(height: 8),
                  _StatusChip(isActive: isActive),
                ],
              ),
            ),
            if (isActive) _CancelAction(isCancelling: isCancelling, onCancel: onCancel),
          ],
        ),
      ),
    );
  }
}

class _CancelAction extends StatelessWidget {
  const _CancelAction({required this.isCancelling, required this.onCancel});

  final bool isCancelling;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    if (isCancelling) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return TextButton(
      onPressed: onCancel,
      child: const Text('Cancel'),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = isActive ? cs.primary : cs.outline;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Booked' : 'Cancelled',
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
