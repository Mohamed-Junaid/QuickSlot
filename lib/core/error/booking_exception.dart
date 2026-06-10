/// Thrown when a slot is already taken at commit time — the core guard that
/// keeps a slot from being double booked. The UI surfaces this as "pick
/// another slot".
class SlotUnavailableException implements Exception {
  const SlotUnavailableException([
    this.message = 'This slot was just booked. Please choose another.',
  ]);

  final String message;

  @override
  String toString() => 'SlotUnavailableException: $message';
}

/// Thrown when cancelling a booking that no longer exists.
class BookingNotFoundException implements Exception {
  const BookingNotFoundException([this.message = 'Booking not found.']);

  final String message;

  @override
  String toString() => 'BookingNotFoundException: $message';
}

/// Thrown when a user tries to cancel a booking they do not own.
class BookingPermissionException implements Exception {
  const BookingPermissionException([
    this.message = 'You can only cancel your own bookings.',
  ]);

  final String message;

  @override
  String toString() => 'BookingPermissionException: $message';
}
