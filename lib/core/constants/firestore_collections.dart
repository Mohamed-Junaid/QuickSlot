/// Single source of truth for Firestore collection and field names.
///
/// Repositories and the seed script reference these constants instead of
/// hard-coded strings, so a schema rename happens in exactly one place.
class FirestoreCollections {
  FirestoreCollections._();

  static const String venues = 'venues';
  static const String bookings = 'bookings';
  static const String users = 'users';
}

/// Field keys for documents in the `venues` collection.
class VenueFields {
  VenueFields._();

  static const String name = 'name';
  static const String description = 'description';
  static const String address = 'address';
  static const String imageUrl = 'imageUrl';
  static const String openHour = 'openHour';
  static const String closeHour = 'closeHour';
  static const String slotDurationMins = 'slotDurationMins';
  static const String isActive = 'isActive';
}

/// Field keys for documents in the `bookings` collection.
///
/// A booking's document ID is deterministic: `{venueId}_{dayKey}_{slotIndex}`.
/// That ID is what makes double-booking impossible inside a transaction —
/// two racing writes target the identical document.
class BookingFields {
  BookingFields._();

  static const String bookingId = 'bookingId';
  static const String venueId = 'venueId';
  static const String venueName = 'venueName';
  static const String userId = 'userId';
  static const String dayKey = 'dayKey';
  static const String slotIndex = 'slotIndex';
  static const String startTime = 'startTime';
  static const String endTime = 'endTime';
  static const String status = 'status';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

/// Field keys for documents in the `users` collection.
class UserFields {
  UserFields._();

  static const String userId = 'userId';
  static const String email = 'email';
  static const String displayName = 'displayName';
  static const String createdAt = 'createdAt';
}

/// Allowed values for [BookingFields.status].
class BookingStatusValues {
  BookingStatusValues._();

  static const String booked = 'booked';
  static const String cancelled = 'cancelled';
}

/// Builds the deterministic booking document ID for a physical slot.
String bookingDocId({
  required String venueId,
  required String dayKey,
  required int slotIndex,
}) =>
    '${venueId}_${dayKey}_$slotIndex';
