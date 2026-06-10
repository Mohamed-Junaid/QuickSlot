import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/booking_model.dart';

/// Prominent card for the user's nearest upcoming booking, on a filled
/// primary surface so it stands out from the rest of the dashboard.
class UpcomingBookingCard extends StatelessWidget {
  const UpcomingBookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  final Booking booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.primary,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.upcoming_rounded, color: cs.onPrimary, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Next booking',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.9),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                booking.venueName,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: cs.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: AppDateUtils.fullDate(booking.startTime),
                color: cs.onPrimary,
              ),
              const SizedBox(height: AppSpacing.xs),
              _InfoRow(
                icon: Icons.schedule_outlined,
                text: '${AppDateUtils.timeLabel(booking.startTime)} - '
                    '${AppDateUtils.timeLabel(booking.endTime)}',
                color: cs.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.9)),
        const SizedBox(width: AppSpacing.sm),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: color.withValues(alpha: 0.95)),
        ),
      ],
    );
  }
}
