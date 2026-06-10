import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/booking_model.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_header.dart';
import '../providers/bookings_provider.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_card_skeleton.dart';

/// My Bookings tab: upcoming and past sections, with cancel on upcoming.
/// Reads the shared [BookingsProvider] from the navigation shell.
class MyBookingsView extends StatelessWidget {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: _body(context, provider),
    );
  }

  Widget _body(BuildContext context, BookingsProvider provider) {
    switch (provider.state) {
      case BookingsViewState.initial:
      case BookingsViewState.loading:
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            BookingCardSkeleton(),
            SizedBox(height: AppSpacing.lg),
            BookingCardSkeleton(),
            SizedBox(height: AppSpacing.lg),
            BookingCardSkeleton(),
          ],
        );

      case BookingsViewState.error:
        return AppErrorView(
          message: provider.errorMessage ?? 'Something went wrong.',
          onRetry: provider.loadBookings,
        );

      case BookingsViewState.success:
        if (provider.isEmpty) {
          return const EmptyState(
            icon: Icons.event_available_outlined,
            title: 'No bookings yet',
            message: 'Your booked slots will show up here.',
          );
        }
        return _BookingsList(provider: provider);
    }
  }
}

class _BookingsList extends StatelessWidget {
  const _BookingsList({required this.provider});

  final BookingsProvider provider;

  @override
  Widget build(BuildContext context) {
    final upcoming = provider.upcomingBookings;
    final past = provider.pastBookings;

    return RefreshIndicator(
      onRefresh: provider.loadBookings,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          if (upcoming.isNotEmpty) ...[
            const SectionHeader(title: 'Upcoming'),
            const SizedBox(height: AppSpacing.md),
            for (final booking in upcoming) ...[
              BookingCard(
                booking: booking,
                isCancelling: provider.cancellingBookingId == booking.bookingId,
                onCancel: () => _onCancel(context, booking),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
          if (past.isNotEmpty) ...[
            const SectionHeader(title: 'Past'),
            const SizedBox(height: AppSpacing.md),
            for (final booking in past) ...[
              BookingCard(booking: booking),
              const SizedBox(height: AppSpacing.lg),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _onCancel(BuildContext context, Booking booking) async {
    final provider = context.read<BookingsProvider>();

    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Cancel booking',
      message: 'Cancel your booking at ${booking.venueName}? '
          'This frees the slot for others.',
      confirmLabel: 'Cancel booking',
      cancelLabel: 'Keep',
    );
    if (!confirmed || !context.mounted) return;

    final result = await provider.cancelBooking(booking.bookingId);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            result == CancelResult.success
                ? 'Booking cancelled.'
                : 'Could not cancel booking. Please try again.',
          ),
        ),
      );
  }
}
