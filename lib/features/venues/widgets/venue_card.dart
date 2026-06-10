import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/venue_model.dart';

/// Modern venue card: cover image, name, location, and a slot-info chip.
class VenueCard extends StatelessWidget {
  const VenueCard({super.key, required this.venue, this.onTap});

  final Venue venue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VenueImage(imageUrl: venue.imageUrl),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    venue.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(Icons.place_outlined,
                          size: 16, color: cs.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          venue.address,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _SlotInfoChip(
                    text: '${venue.openHour}:00 - ${venue.closeHour}:00 · '
                        '${venue.slotDurationMins} min slots',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlotInfoChip extends StatelessWidget {
  const _SlotInfoChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule_outlined, size: 14, color: cs.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: cs.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  const _VenueImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return ColoredBox(color: cs.surfaceContainerHighest);
        },
        errorBuilder: (context, error, stackTrace) => ColoredBox(
          color: cs.surfaceContainerHighest,
          child: Icon(Icons.image_not_supported_outlined,
              color: cs.onSurfaceVariant),
        ),
      ),
    );
  }
}
