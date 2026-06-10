import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/booking_repository.dart';
import '../../../data/repositories/venue_repository.dart';
import '../../bookings/providers/bookings_provider.dart';
import '../../bookings/view/my_bookings_view.dart';
import '../../home/view/home_view.dart';
import '../../profile/view/profile_view.dart';
import '../../venues/providers/venue_provider.dart';

/// Material 3 bottom-navigation shell hosting Home, My Bookings, and Profile.
/// Owns the venue and bookings providers so all three tabs share one source of
/// truth. Recreated (via key) when the signed-in user changes.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.userId});

  final String userId;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  late final VenueProvider _venueProvider =
      VenueProvider(VenueRepository())..loadVenues();
  late final BookingsProvider _bookingsProvider =
      BookingsProvider(BookingRepository(), widget.userId)..loadBookings();

  @override
  void dispose() {
    _venueProvider.dispose();
    _bookingsProvider.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    setState(() => _index = index);
    // Refresh bookings when entering the bookings or profile tab so stats and
    // lists reflect anything booked from the home flow.
    if (index != 0) _bookingsProvider.loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _venueProvider),
        ChangeNotifierProvider.value(value: _bookingsProvider),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeView(userId: widget.userId),
            const MyBookingsView(),
            const ProfileView(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note_rounded),
              label: 'My Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
