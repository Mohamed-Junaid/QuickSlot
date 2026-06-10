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
  openHour: (json['openHour'] as num).toInt(),
  closeHour: (json['closeHour'] as num).toInt(),
  slotDurationMins: (json['slotDurationMins'] as num).toInt(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'address': instance.address,
      'imageUrl': instance.imageUrl,
      'openHour': instance.openHour,
      'closeHour': instance.closeHour,
      'slotDurationMins': instance.slotDurationMins,
      'isActive': instance.isActive,
    };
