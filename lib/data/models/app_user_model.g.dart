// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppUserImpl _$$AppUserImplFromJson(Map<String, dynamic> json) =>
    _$AppUserImpl(
      userId: json['userId'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      createdAt: const TimestampConverter().fromJson(
        json['createdAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$$AppUserImplToJson(_$AppUserImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'displayName': instance.displayName,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
    };
