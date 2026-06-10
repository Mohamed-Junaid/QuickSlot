import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickslot/core/error/booking_exception.dart';
import 'package:quickslot/data/models/booking_model.dart';
import 'package:quickslot/data/models/slot_model.dart';
import 'package:quickslot/data/models/venue_model.dart';
import 'package:quickslot/data/repositories/booking_repository.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late BookingRepository repository;

  const venue = Venue(
    id: 'venue_court_a',
    name: 'Court A',
    description: '',
    address: '',
    imageUrl: '',
    openHour: 8,
    closeHour: 22,
    slotDurationMins: 60,
  );

  // A fixed slot so the deterministic document id is stable across tests.
  final slot = Slot(
    slotIndex: 0,
    startTime: DateTime(2026, 6, 10, 8),
    endTime: DateTime(2026, 6, 10, 9),
  );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repository = BookingRepository(firestore: firestore);
  });

  test('books a free slot', () async {
    final booking =
        await repository.bookSlot(venue: venue, slot: slot, userId: 'userA');

    expect(booking.status, BookingStatus.booked);
    expect(booking.bookingId, 'venue_court_a_2026-06-10_0');
    expect(booking.userId, 'userA');
  });

  test('rejects booking a slot that is already booked', () async {
    await repository.bookSlot(venue: venue, slot: slot, userId: 'userA');

    expect(
      () => repository.bookSlot(venue: venue, slot: slot, userId: 'userB'),
      throwsA(isA<SlotUnavailableException>()),
    );
  });

  test('allows re-booking a slot after it is cancelled', () async {
    final first =
        await repository.bookSlot(venue: venue, slot: slot, userId: 'userA');
    await repository.cancelBooking(
      bookingId: first.bookingId,
      userId: 'userA',
    );

    // A different user can now claim the freed slot.
    final second =
        await repository.bookSlot(venue: venue, slot: slot, userId: 'userB');

    expect(second.status, BookingStatus.booked);
    expect(second.userId, 'userB');
  });

  test('cancel only succeeds for the booking owner', () async {
    final booking =
        await repository.bookSlot(venue: venue, slot: slot, userId: 'userA');

    expect(
      () => repository.cancelBooking(
        bookingId: booking.bookingId,
        userId: 'someoneElse',
      ),
      throwsA(isA<BookingPermissionException>()),
    );
  });

  test('getUserBookings returns only that user\'s bookings', () async {
    final slotB = slot.copyWith(slotIndex: 1, startTime: slot.startTime.add(const Duration(hours: 1)));
    await repository.bookSlot(venue: venue, slot: slot, userId: 'userA');
    await repository.bookSlot(venue: venue, slot: slotB, userId: 'userB');

    final mine = await repository.getUserBookings('userA');

    expect(mine, hasLength(1));
    expect(mine.single.userId, 'userA');
  });
}
