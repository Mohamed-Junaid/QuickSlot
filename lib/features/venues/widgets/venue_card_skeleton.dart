import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/shimmer.dart';

/// Shimmer placeholder shaped like a [VenueCard], shown while venues load.
class VenueCardSkeleton extends StatelessWidget {
  const VenueCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AspectRatio(aspectRatio: 16 / 9, child: SkeletonBox(height: double.infinity)),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SkeletonBox(width: 180, height: 18),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(width: 120, height: 14),
                  SizedBox(height: AppSpacing.md),
                  SkeletonBox(width: 200, height: 24, radius: AppRadius.sm),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
