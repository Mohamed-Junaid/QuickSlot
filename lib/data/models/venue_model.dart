import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_model.freezed.dart';
part 'venue_model.g.dart';

/// A bookable venue. Slots are not stored on the venue; they are derived at
/// runtime from [openHour], [closeHour], and [slotDurationMins].
///
/// [id] is the Firestore document ID. Repositories inject it via
/// `Venue.fromJson({...doc.data(), 'id': doc.id})` and strip it before writing.
@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required String description,
    required String address,
    required String imageUrl,
    required int openHour,
    required int closeHour,
    required int slotDurationMins,
    @Default(true) bool isActive,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}
