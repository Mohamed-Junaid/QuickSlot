import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/widgets/shimmer.dart';

/// Shimmer placeholder shaped like a [BookingCard], shown while bookings load.
class BookingCardSkeleton extends StatelessWidget {
  const BookingCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Shimmer(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SkeletonBox(width: 160, height: 18),
              SizedBox(height: AppSpacing.md),
              SkeletonBox(width: 140, height: 14),
              SizedBox(height: AppSpacing.sm),
              SkeletonBox(width: 100, height: 14),
              SizedBox(height: AppSpacing.md),
              SkeletonBox(width: 72, height: 22, radius: AppRadius.lg),
            ],
          ),
        ),
      ),
    );
  }
}
