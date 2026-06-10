// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  address: json['address'] as String,
  imageUrl: json['imageUrl'] as String,
  openHour: const IntConverter().fromJson(json['openHour'] as num),
  closeHour: const IntConverter().fromJson(json['closeHour'] as num),
  slotDurationMins: const IntConverter().fromJson(
    json['slotDurationMins'] as num,
  ),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$VenueImplToJson(
  _$VenueImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'address': instance.address,
  'imageUrl': instance.imageUrl,
  'openHour': const IntConverter().toJson(instance.openHour),
  'closeHour': const IntConverter().toJson(instance.closeHour),
  'slotDurationMins': const IntConverter().toJson(instance.slotDurationMins),
  'isActive': instance.isActive,
};
