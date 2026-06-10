import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_collections.dart';
import '../../core/error/booking_exception.dart';
import '../../core/utils/date_utils.dart';
import '../models/booking_model.dart';
import '../models/slot_model.dart';
import '../models/venue_model.dart';

/// Creates, cancels, and lists bookings.
///
/// Both writes run inside [FirebaseFirestore.runTransaction] so the
/// read-check-write is atomic. Because every booking lives at the deterministic
/// document ID `{venueId}_{dayKey}_{slotIndex}`, two users racing for the same
/// slot contend on the identical document — the transaction serializes them and
/// the loser fails with [SlotUnavailableException]. A slot is never double
/// booked.
class BookingRepository {
  BookingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _bookings =>
      _firestore.collection(FirestoreCollections.bookings);

  /// Atomically books [slot] at [venue] for [userId].
  ///
  /// Throws [SlotUnavailableException] if the slot is already booked. Re-books a
  /// previously cancelled slot by overwriting the same document.
  Future<Booking> bookSlot({
    required Venue venue,
    required Slot slot,
    required String userId,
  }) async {
    final dayKey = AppDateUtils.dayKey(slot.startTime);
    final docId = bookingDocId(
      venueId: venue.id,
      dayKey: dayKey,
      slotIndex: slot.slotIndex,
    );
    final ref = _bookings.doc(docId);
    final now = DateTime.now();

    final booking = Booking(
      bookingId: docId,
      venueId: venue.id,
      venueName: venue.name,
      userId: userId,
      dayKey: dayKey,
      slotIndex: slot.slotIndex,
      startTime: slot.startTime,
      endTime: slot.endTime,
      status: BookingStatus.booked,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      if (snapshot.exists) {
        final existing = Booking.fromJson(snapshot.data()!);
        if (existing.status == BookingStatus.booked) {
          throw const SlotUnavailableException();
        }
      }

      transaction.set(ref, booking.toJson());
    });

    return booking;
  }

  /// Atomically cancels a booking the user owns. Idempotent: cancelling an
  /// already-cancelled booking is a no-op.
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  }) async {
    final ref = _bookings.doc(bookingId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);

      if (!snapshot.exists) {
        throw const BookingNotFoundException();
      }

      final existing = Booking.fromJson(snapshot.data()!);

      if (existing.userId != userId) {
        throw const BookingPermissionException();
      }
      if (existing.status == BookingStatus.cancelled) {
        return;
      }

      transaction.update(ref, {
        BookingFields.status: BookingStatusValues.cancelled,
        BookingFields.updatedAt: Timestamp.fromDate(DateTime.now()),
      });
    });
  }

  /// All bookings for [userId], newest first. Includes cancelled bookings so
  /// the UI can decide whether to show or hide them.
  Future<List<Booking>> getUserBookings(String userId) async {
    final snapshot = await _bookings
        .where(BookingFields.userId, isEqualTo: userId)
        .orderBy(BookingFields.createdAt, descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Booking.fromJson(doc.data()))
        .toList();
  }
}
