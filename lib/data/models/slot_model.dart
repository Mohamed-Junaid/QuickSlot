import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot_model.freezed.dart';

/// A single time slot in a venue's day grid.
///
/// This is a derived UI model, built at runtime by combining a venue's hours
/// with that day's bookings. It is never read from or written to Firestore, so
/// it has no JSON serialization — only Freezed equality and copyWith.
@freezed
class Slot with _$Slot {
  const factory Slot({
    required int slotIndex,
    required DateTime startTime,
    required DateTime endTime,
    @Default(false) bool isBooked,
    @Default(false) bool isBookedByCurrentUser,
  }) = _Slot;
}
