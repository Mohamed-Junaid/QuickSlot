import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'booking_model.freezed.dart';
part 'booking_model.g.dart';

/// Lifecycle status of a booking, persisted as a string in Firestore.
enum BookingStatus {
  @JsonValue('booked')
  booked,
  @JsonValue('cancelled')
  cancelled,
}

/// A booking for a single physical slot.
///
/// The Firestore document ID is deterministic: `{venueId}_{dayKey}_{slotIndex}`.
/// That ID — combined with a transaction — is what guarantees a slot can never
/// be double booked. [bookingId] mirrors the document ID.
///
/// [venueName] is denormalized so the "My Bookings" list renders without an
/// extra venue read.
@freezed
class Booking with _$Booking {
  const factory Booking({
    required String bookingId,
    required String venueId,
    required String venueName,
    required String userId,
    required String dayKey,
    required int slotIndex,
    @TimestampConverter() required DateTime startTime,
    @TimestampConverter() required DateTime endTime,
    @Default(BookingStatus.booked) BookingStatus status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
