import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/utils/timestamp_converter.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

/// The signed-in user (anonymous auth). [userId] mirrors the Firestore
/// document ID and the FirebaseAuth uid.
@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String userId,
    String? email,
    String? displayName,
    @TimestampConverter() required DateTime createdAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
