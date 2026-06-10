import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../providers/slot_provider.dart';

/// Horizontal choice chips to filter the slot grid by time of day.
class SlotTimeFilterBar extends StatelessWidget {
  const SlotTimeFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final SlotTimeFilter selected;
  final ValueChanged<SlotTimeFilter> onChanged;

  static const _labels = {
    SlotTimeFilter.all: 'All',
    SlotTimeFilter.morning: 'Morning',
    SlotTimeFilter.afternoon: 'Afternoon',
    SlotTimeFilter.evening: 'Evening',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          for (final entry in _labels.entries) ...[
            ChoiceChip(
              label: Text(entry.value),
              selected: selected == entry.key,
              onSelected: (_) => onChanged(entry.key),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
