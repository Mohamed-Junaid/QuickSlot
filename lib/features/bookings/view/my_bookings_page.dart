import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers/bookings_provider.dart';
import '../widgets/booking_card.dart';
import '../widgets/booking_card_skeleton.dart';

/// Lists the signed-in user's bookings and lets them cancel. [userId] is passed
/// in because this route is pushed above the auth provider.
class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          BookingsProvider(BookingRepository(), userId)..loadBookings(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const _MyBookingsView(),
      ),
    );
  }
}

class _MyBookingsView extends StatelessWidget {
  const _MyBookingsView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingsProvider>();

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
        return RefreshIndicator(
          onRefresh: provider.loadBookings,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: provider.bookings.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
            itemBuilder: (context, index) {
              final booking = provider.bookings[index];
              return BookingCard(
                booking: booking,
                isCancelling:
                    provider.cancellingBookingId == booking.bookingId,
                onCancel: () => _onCancel(context, booking),
              );
            },
          ),
        );
    }
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

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
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
