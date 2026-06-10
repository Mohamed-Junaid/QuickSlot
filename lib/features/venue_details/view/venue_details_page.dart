import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/venue_model.dart';
import '../../../data/repositories/venue_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loader.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/slot_provider.dart';
import '../widgets/date_selector.dart';
import '../widgets/slot_grid.dart';

/// Shows a venue's slot grid for a chosen date. Slots are read-only here —
/// booking comes later. [currentUserId] is passed from the venue list (which
/// lives under the auth provider) since pushed routes can't read it directly.
class VenueDetailsPage extends StatelessWidget {
  const VenueDetailsPage({
    super.key,
    required this.venue,
    this.currentUserId,
  });

  final Venue venue;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          SlotProvider(VenueRepository(), venue, currentUserId)..loadSlots(),
      child: Scaffold(
        appBar: AppBar(title: Text(venue.name)),
        body: _VenueDetailsView(venue: venue),
      ),
    );
  }
}

class _VenueDetailsView extends StatelessWidget {
  const _VenueDetailsView({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SlotProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VenueHeader(venue: venue),
        const Divider(height: 1),
        DateSelector(
          selectedDate: provider.selectedDate,
          onDateSelected: provider.selectDate,
        ),
        const _SlotLegend(),
        const Divider(height: 1),
        Expanded(child: _SlotArea(provider: provider)),
      ],
    );
  }
}

class _SlotArea extends StatelessWidget {
  const _SlotArea({required this.provider});

  final SlotProvider provider;

  @override
  Widget build(BuildContext context) {
    switch (provider.state) {
      case SlotViewState.initial:
      case SlotViewState.loading:
        return const AppLoader(message: 'Loading slots');

      case SlotViewState.error:
        return AppErrorView(
          message: provider.errorMessage ?? 'Something went wrong.',
          onRetry: provider.loadSlots,
        );

      case SlotViewState.success:
        if (provider.isEmpty) {
          return const EmptyState(
            icon: Icons.event_busy_outlined,
            message: 'No slots available for this day.',
          );
        }
        return SlotGrid(slots: provider.slots);
    }
  }
}

class _VenueHeader extends StatelessWidget {
  const _VenueHeader({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venue.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          _IconLine(icon: Icons.place_outlined, text: venue.address),
          const SizedBox(height: 4),
          _IconLine(
            icon: Icons.schedule_outlined,
            text: '${venue.openHour}:00 - ${venue.closeHour}:00 · '
                '${venue.slotDurationMins} min slots',
          ),
        ],
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
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}

/// Legend explaining the two slot colors.
class _SlotLegend extends StatelessWidget {
  const _SlotLegend();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _LegendItem(color: cs.primaryContainer, label: 'Available'),
          const SizedBox(width: 16),
          _LegendItem(color: cs.surfaceContainerHighest, label: 'Booked'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
