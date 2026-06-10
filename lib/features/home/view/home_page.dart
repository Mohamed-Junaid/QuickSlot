import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/venue_repository.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shimmer.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../bookings/view/my_bookings_page.dart';
import '../../venues/providers/venue_provider.dart';
import '../../venues/view/venue_list_page.dart';
import '../../venues/widgets/venue_card.dart';
import '../../venues/widgets/venue_card_skeleton.dart';
import '../../venue_details/view/venue_details_page.dart';
import '../widgets/quick_stats.dart';
import '../widgets/upcoming_booking_card.dart';
import '../widgets/welcome_header.dart';

/// Dashboard home. Owns a venue provider and a bookings provider, and lays out
/// the welcome header, upcoming booking, quick stats, and available venues.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Safe: HomePage is only shown by AuthGate once authenticated.
    final userId = context.read<AuthProvider>().userId!;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => VenueProvider(VenueRepository())..loadVenues(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              BookingsProvider(BookingRepository(), userId)..loadBookings(),
        ),
      ],
      child: _HomeView(userId: userId),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    final venueProvider = context.watch<VenueProvider>();
    final bookingsProvider = context.watch<BookingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickSlot'),
        actions: [
          IconButton(
            tooltip: 'My bookings',
            icon: const Icon(Icons.event_note_outlined),
            onPressed: () => _push(context, MyBookingsPage(userId: userId)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([
          venueProvider.loadVenues(),
          bookingsProvider.loadBookings(),
        ]),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            const WelcomeHeader(),
            const SizedBox(height: AppSpacing.xl),
            _UpcomingSection(
              provider: bookingsProvider,
              onTap: () => _push(context, MyBookingsPage(userId: userId)),
            ),
            const SizedBox(height: AppSpacing.lg),
            QuickStats(
              totalBookings: bookingsProvider.activeCount,
              upcomingBookings: bookingsProvider.upcomingCount,
            ),
            const SizedBox(height: AppSpacing.xl),
            SectionHeader(
              title: 'Available venues',
              actionLabel: 'See all',
              onAction: () =>
                  _push(context, VenueListPage(userId: userId)),
            ),
            const SizedBox(height: AppSpacing.md),
            ..._venueSection(context, venueProvider),
          ],
        ),
      ),
    );
  }

  List<Widget> _venueSection(BuildContext context, VenueProvider provider) {
    switch (provider.state) {
      case VenueViewState.initial:
      case VenueViewState.loading:
        return const [
          VenueCardSkeleton(),
          SizedBox(height: AppSpacing.lg),
          VenueCardSkeleton(),
        ];

      case VenueViewState.error:
        return [
          AppErrorView(
            message: provider.errorMessage ?? 'Could not load venues.',
            onRetry: provider.loadVenues,
          ),
        ];

      case VenueViewState.success:
        if (provider.isEmpty) {
          return const [
            EmptyState(
              icon: Icons.storefront_outlined,
              title: 'No venues yet',
              message: 'Venues will appear here once they are added.',
            ),
          ];
        }
        return [
          for (final venue in provider.venues) ...[
            VenueCard(
              venue: venue,
              onTap: () => _push(
                context,
                VenueDetailsPage(venue: venue, currentUserId: userId),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ];
    }
  }

  /// Pushes [page] and, once it pops, reloads bookings so a slot booked or
  /// cancelled on the pushed screen is reflected on the dashboard.
  Future<void> _push(BuildContext context, Widget page) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => page),
    );
    if (!context.mounted) return;
    await context.read<BookingsProvider>().loadBookings();
  }
}

/// Upcoming booking, or a friendly prompt when there are none.
class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.provider, required this.onTap});

  final BookingsProvider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (provider.state == BookingsViewState.loading ||
        provider.state == BookingsViewState.initial) {
      return const Shimmer(
        child: SkeletonBox(height: 132, radius: AppRadius.lg),
      );
    }

    final next = provider.nextUpcoming;
    if (next == null) {
      return _NoUpcomingCard(onTap: onTap);
    }
    return UpcomingBookingCard(booking: next, onTap: onTap);
  }
}

class _NoUpcomingCard extends StatelessWidget {
  const _NoUpcomingCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(Icons.event_available_outlined, color: cs.primary, size: 32),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No upcoming bookings',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Pick a venue below to book your first slot.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: cs.onSurfaceVariant),
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
