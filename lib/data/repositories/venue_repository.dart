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
    final snapshot = await _dayBookingsQuery(venue.id, date).get();
    return _buildSlots(
      venue: venue,
      date: date,
      bookedByIndex: _bookedByIndex(snapshot.docs),
      currentUserId: currentUserId,
    );
  }

  /// Live slot grid for [venue] on [date]. Emits a new grid whenever a booking
  /// for that day is created or cancelled, so a slot flips to Booked on other
  /// devices without a manual refresh.
  Stream<List<Slot>> watchSlots({
    required Venue venue,
    required DateTime date,
    String? currentUserId,
  }) {
    return _dayBookingsQuery(venue.id, date).snapshots().map(
          (snapshot) => _buildSlots(
            venue: venue,
            date: date,
            bookedByIndex: _bookedByIndex(snapshot.docs),
            currentUserId: currentUserId,
          ),
        );
  }

  Query<Map<String, dynamic>> _dayBookingsQuery(String venueId, DateTime date) {
    return _bookings
        .where(BookingFields.venueId, isEqualTo: venueId)
        .where(BookingFields.dayKey, isEqualTo: AppDateUtils.dayKey(date));
  }

  /// Maps booking docs to the slot indexes they occupy. Only "booked" rows
  /// count; cancelled ones free the slot. Filtering in memory avoids needing a
  /// composite index that also covers `status`.
  Map<int, Booking> _bookedByIndex(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    final bookedByIndex = <int, Booking>{};
    for (final doc in docs) {
      final booking = Booking.fromJson(doc.data());
      if (booking.status == BookingStatus.booked) {
        bookedByIndex[booking.slotIndex] = booking;
      }
    }
    return bookedByIndex;
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
