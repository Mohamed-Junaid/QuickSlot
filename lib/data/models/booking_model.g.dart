// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      bookingId: json['bookingId'] as String,
      venueId: json['venueId'] as String,
      venueName: json['venueName'] as String,
      userId: json['userId'] as String,
      dayKey: json['dayKey'] as String,
      slotIndex: (json['slotIndex'] as num).toInt(),
      startTime: const TimestampConverter().fromJson(
        json['startTime'] as Timestamp,
      ),
      endTime: const TimestampConverter().fromJson(
        json['endTime'] as Timestamp,
      ),
      status:
          $enumDecodeNullable(_$BookingStatusEnumMap, json['status']) ??
          BookingStatus.booked,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
      updatedAt: const TimestampConverter().fromJson(
        json['updatedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'bookingId': instance.bookingId,
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'userId': instance.userId,
      'dayKey': instance.dayKey,
      'slotIndex': instance.slotIndex,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
      'status': _$BookingStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

const _$BookingStatusEnumMap = {
  BookingStatus.booked: 'booked',
  BookingStatus.cancelled: 'cancelled',
};
