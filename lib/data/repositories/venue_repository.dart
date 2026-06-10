import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../../core/utils/date_utils.dart';
import '../models/booking_model.dart';
import '../models/slot_model.dart';
import '../models/venue_model.dart';

/// Reads venues and derives their per-day slot grids.
///
/// Slots are not stored in Firestore. [getSlots] computes the grid from the
/// venue's open/close hours and slot duration, then marks which slots are
/// taken by reading that day's bookings.
class VenueRepository {
  VenueRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _venues =>
      _firestore.collection(FirestoreCollections.venues);

  CollectionReference<Map<String, dynamic>> get _bookings =>
      _firestore.collection(FirestoreCollections.bookings);

  /// All active venues.
  Future<List<Venue>> getVenues() async {
    final snapshot =
        await _venues.where(VenueFields.isActive, isEqualTo: true).get();
    return snapshot.docs
        .map((doc) => Venue.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  /// The slot grid for [venue] on [date], with availability resolved against
  /// existing bookings. [currentUserId] flags which slots the signed-in user
  /// already booked.
  Future<List<Slot>> getSlots({
    required Venue venue,
    required DateTime date,
    String? currentUserId,
  }) async {
    final dayKey = AppDateUtils.dayKey(date);

    final snapshot = await _bookings
        .where(BookingFields.venueId, isEqualTo: venue.id)
        .where(BookingFields.dayKey, isEqualTo: dayKey)
        .get();

    // Only "booked" rows occupy a slot; cancelled ones free it up. Filtering in
    // memory avoids needing a composite index that also covers `status`.
    final bookedByIndex = <int, Booking>{};
    for (final doc in snapshot.docs) {
      final booking = Booking.fromJson(doc.data());
      if (booking.status == BookingStatus.booked) {
        bookedByIndex[booking.slotIndex] = booking;
      }
    }

    return _buildSlots(
      venue: venue,
      date: date,
      bookedByIndex: bookedByIndex,
      currentUserId: currentUserId,
    );
  }

  List<Slot> _buildSlots({
    required Venue venue,
    required DateTime date,
    required Map<int, Booking> bookedByIndex,
    String? currentUserId,
  }) {
    final day = AppDateUtils.dayOnly(date);
    final openingMinutes = venue.openHour * 60;
    final totalMinutes = (venue.closeHour - venue.openHour) * 60;
    final slotCount = totalMinutes ~/ venue.slotDurationMins;

    return List<Slot>.generate(slotCount, (index) {
      final start = day.add(
        Duration(minutes: openingMinutes + index * venue.slotDurationMins),
      );
      final end = start.add(Duration(minutes: venue.slotDurationMins));
      final booking = bookedByIndex[index];

      return Slot(
        slotIndex: index,
        startTime: start,
        endTime: end,
        isBooked: booking != null,
        isBookedByCurrentUser:
            booking != null && booking.userId == currentUserId,
      );
    });
  }
}
