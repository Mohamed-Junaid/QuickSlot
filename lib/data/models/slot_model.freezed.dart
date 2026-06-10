// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'slot_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Slot {
  int get slotIndex => throw _privateConstructorUsedError;
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  bool get isBooked => throw _privateConstructorUsedError;
  bool get isBookedByCurrentUser => throw _privateConstructorUsedError;

  /// Create a copy of Slot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SlotCopyWith<Slot> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlotCopyWith<$Res> {
  factory $SlotCopyWith(Slot value, $Res Function(Slot) then) =
      _$SlotCopyWithImpl<$Res, Slot>;
  @useResult
  $Res call({
    int slotIndex,
    DateTime startTime,
    DateTime endTime,
    bool isBooked,
    bool isBookedByCurrentUser,
  });
}

/// @nodoc
class _$SlotCopyWithImpl<$Res, $Val extends Slot>
    implements $SlotCopyWith<$Res> {
  _$SlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Slot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotIndex = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isBooked = null,
    Object? isBookedByCurrentUser = null,
  }) {
    return _then(
      _value.copyWith(
            slotIndex: null == slotIndex
                ? _value.slotIndex
                : slotIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isBooked: null == isBooked
                ? _value.isBooked
                : isBooked // ignore: cast_nullable_to_non_nullable
                      as bool,
            isBookedByCurrentUser: null == isBookedByCurrentUser
                ? _value.isBookedByCurrentUser
                : isBookedByCurrentUser // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SlotImplCopyWith<$Res> implements $SlotCopyWith<$Res> {
  factory _$$SlotImplCopyWith(
    _$SlotImpl value,
    $Res Function(_$SlotImpl) then,
  ) = __$$SlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int slotIndex,
    DateTime startTime,
    DateTime endTime,
    bool isBooked,
    bool isBookedByCurrentUser,
  });
}

/// @nodoc
class __$$SlotImplCopyWithImpl<$Res>
    extends _$SlotCopyWithImpl<$Res, _$SlotImpl>
    implements _$$SlotImplCopyWith<$Res> {
  __$$SlotImplCopyWithImpl(_$SlotImpl _value, $Res Function(_$SlotImpl) _then)
    : super(_value, _then);

  /// Create a copy of Slot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slotIndex = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isBooked = null,
    Object? isBookedByCurrentUser = null,
  }) {
    return _then(
      _$SlotImpl(
        slotIndex: null == slotIndex
            ? _value.slotIndex
            : slotIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: null == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isBooked: null == isBooked
            ? _value.isBooked
            : isBooked // ignore: cast_nullable_to_non_nullable
                  as bool,
        isBookedByCurrentUser: null == isBookedByCurrentUser
            ? _value.isBookedByCurrentUser
            : isBookedByCurrentUser // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$SlotImpl implements _Slot {
  const _$SlotImpl({
    required this.slotIndex,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
    this.isBookedByCurrentUser = false,
  });

  @override
  final int slotIndex;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  @JsonKey()
  final bool isBooked;
  @override
  @JsonKey()
  final bool isBookedByCurrentUser;

  @override
  String toString() {
    return 'Slot(slotIndex: $slotIndex, startTime: $startTime, endTime: $endTime, isBooked: $isBooked, isBookedByCurrentUser: $isBookedByCurrentUser)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SlotImpl &&
            (identical(other.slotIndex, slotIndex) ||
                other.slotIndex == slotIndex) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isBooked, isBooked) ||
                other.isBooked == isBooked) &&
            (identical(other.isBookedByCurrentUser, isBookedByCurrentUser) ||
                other.isBookedByCurrentUser == isBookedByCurrentUser));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    slotIndex,
    startTime,
    endTime,
    isBooked,
    isBookedByCurrentUser,
  );

  /// Create a copy of Slot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SlotImplCopyWith<_$SlotImpl> get copyWith =>
      __$$SlotImplCopyWithImpl<_$SlotImpl>(this, _$identity);
}

abstract class _Slot implements Slot {
  const factory _Slot({
    required final int slotIndex,
    required final DateTime startTime,
    required final DateTime endTime,
    final bool isBooked,
    final bool isBookedByCurrentUser,
  }) = _$SlotImpl;

  @override
  int get slotIndex;
  @override
  DateTime get startTime;
  @override
  DateTime get endTime;
  @override
  bool get isBooked;
  @override
  bool get isBookedByCurrentUser;

  /// Create a copy of Slot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SlotImplCopyWith<_$SlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
