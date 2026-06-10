import 'package:flutter/material.dart';

import '../../../data/models/slot_model.dart';
import 'slot_tile.dart';

/// Scrollable grid of slot tiles for the selected day.
class SlotGrid extends StatelessWidget {
  const SlotGrid({
    super.key,
    required this.slots,
    required this.onSlotTap,
    this.bookingSlotIndex,
  });

  final List<Slot> slots;
  final ValueChanged<Slot> onSlotTap;

  /// Index of the slot currently being booked, if any.
  final int? bookingSlotIndex;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        return SlotTile(
          slot: slot,
          isLoading: bookingSlotIndex == slot.slotIndex,
          onTap: () => onSlotTap(slot),
        );
      },
    );
  }
}
