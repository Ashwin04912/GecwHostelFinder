// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_details_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RoomDetailsEvent {
  String get hostelId => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> rooms, String hostelId)
        addRoomsToFirestore,
    required TResult Function(String hostelId) getHostelRoomDetailsById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult? Function(String hostelId)? getHostelRoomDetailsById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult Function(String hostelId)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_addRoomsToFirestore value) addRoomsToFirestore,
    required TResult Function(_getHostelRoomDetailsById value)
        getHostelRoomDetailsById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult? Function(_getHostelRoomDetailsById value)?
        getHostelRoomDetailsById,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult Function(_getHostelRoomDetailsById value)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomDetailsEventCopyWith<RoomDetailsEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomDetailsEventCopyWith<$Res> {
  factory $RoomDetailsEventCopyWith(
          RoomDetailsEvent value, $Res Function(RoomDetailsEvent) then) =
      _$RoomDetailsEventCopyWithImpl<$Res, RoomDetailsEvent>;
  @useResult
  $Res call({String hostelId});
}

/// @nodoc
class _$RoomDetailsEventCopyWithImpl<$Res, $Val extends RoomDetailsEvent>
    implements $RoomDetailsEventCopyWith<$Res> {
  _$RoomDetailsEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostelId = null,
  }) {
    return _then(_value.copyWith(
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$addRoomsToFirestoreImplCopyWith<$Res>
    implements $RoomDetailsEventCopyWith<$Res> {
  factory _$$addRoomsToFirestoreImplCopyWith(_$addRoomsToFirestoreImpl value,
          $Res Function(_$addRoomsToFirestoreImpl) then) =
      __$$addRoomsToFirestoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic> rooms, String hostelId});
}

/// @nodoc
class __$$addRoomsToFirestoreImplCopyWithImpl<$Res>
    extends _$RoomDetailsEventCopyWithImpl<$Res, _$addRoomsToFirestoreImpl>
    implements _$$addRoomsToFirestoreImplCopyWith<$Res> {
  __$$addRoomsToFirestoreImplCopyWithImpl(_$addRoomsToFirestoreImpl _value,
      $Res Function(_$addRoomsToFirestoreImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rooms = null,
    Object? hostelId = null,
  }) {
    return _then(_$addRoomsToFirestoreImpl(
      rooms: null == rooms
          ? _value._rooms
          : rooms // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$addRoomsToFirestoreImpl implements _addRoomsToFirestore {
  const _$addRoomsToFirestoreImpl(
      {required final Map<String, dynamic> rooms, required this.hostelId})
      : _rooms = rooms;

  final Map<String, dynamic> _rooms;
  @override
  Map<String, dynamic> get rooms {
    if (_rooms is EqualUnmodifiableMapView) return _rooms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_rooms);
  }

  @override
  final String hostelId;

  @override
  String toString() {
    return 'RoomDetailsEvent.addRoomsToFirestore(rooms: $rooms, hostelId: $hostelId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$addRoomsToFirestoreImpl &&
            const DeepCollectionEquality().equals(other._rooms, _rooms) &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_rooms), hostelId);

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$addRoomsToFirestoreImplCopyWith<_$addRoomsToFirestoreImpl> get copyWith =>
      __$$addRoomsToFirestoreImplCopyWithImpl<_$addRoomsToFirestoreImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> rooms, String hostelId)
        addRoomsToFirestore,
    required TResult Function(String hostelId) getHostelRoomDetailsById,
  }) {
    return addRoomsToFirestore(rooms, hostelId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult? Function(String hostelId)? getHostelRoomDetailsById,
  }) {
    return addRoomsToFirestore?.call(rooms, hostelId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult Function(String hostelId)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) {
    if (addRoomsToFirestore != null) {
      return addRoomsToFirestore(rooms, hostelId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_addRoomsToFirestore value) addRoomsToFirestore,
    required TResult Function(_getHostelRoomDetailsById value)
        getHostelRoomDetailsById,
  }) {
    return addRoomsToFirestore(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult? Function(_getHostelRoomDetailsById value)?
        getHostelRoomDetailsById,
  }) {
    return addRoomsToFirestore?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult Function(_getHostelRoomDetailsById value)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) {
    if (addRoomsToFirestore != null) {
      return addRoomsToFirestore(this);
    }
    return orElse();
  }
}

abstract class _addRoomsToFirestore implements RoomDetailsEvent {
  const factory _addRoomsToFirestore(
      {required final Map<String, dynamic> rooms,
      required final String hostelId}) = _$addRoomsToFirestoreImpl;

  Map<String, dynamic> get rooms;
  @override
  String get hostelId;

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$addRoomsToFirestoreImplCopyWith<_$addRoomsToFirestoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$getHostelRoomDetailsByIdImplCopyWith<$Res>
    implements $RoomDetailsEventCopyWith<$Res> {
  factory _$$getHostelRoomDetailsByIdImplCopyWith(
          _$getHostelRoomDetailsByIdImpl value,
          $Res Function(_$getHostelRoomDetailsByIdImpl) then) =
      __$$getHostelRoomDetailsByIdImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String hostelId});
}

/// @nodoc
class __$$getHostelRoomDetailsByIdImplCopyWithImpl<$Res>
    extends _$RoomDetailsEventCopyWithImpl<$Res, _$getHostelRoomDetailsByIdImpl>
    implements _$$getHostelRoomDetailsByIdImplCopyWith<$Res> {
  __$$getHostelRoomDetailsByIdImplCopyWithImpl(
      _$getHostelRoomDetailsByIdImpl _value,
      $Res Function(_$getHostelRoomDetailsByIdImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostelId = null,
  }) {
    return _then(_$getHostelRoomDetailsByIdImpl(
      hostelId: null == hostelId
          ? _value.hostelId
          : hostelId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$getHostelRoomDetailsByIdImpl implements _getHostelRoomDetailsById {
  const _$getHostelRoomDetailsByIdImpl({required this.hostelId});

  @override
  final String hostelId;

  @override
  String toString() {
    return 'RoomDetailsEvent.getHostelRoomDetailsById(hostelId: $hostelId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$getHostelRoomDetailsByIdImpl &&
            (identical(other.hostelId, hostelId) ||
                other.hostelId == hostelId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hostelId);

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$getHostelRoomDetailsByIdImplCopyWith<_$getHostelRoomDetailsByIdImpl>
      get copyWith => __$$getHostelRoomDetailsByIdImplCopyWithImpl<
          _$getHostelRoomDetailsByIdImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Map<String, dynamic> rooms, String hostelId)
        addRoomsToFirestore,
    required TResult Function(String hostelId) getHostelRoomDetailsById,
  }) {
    return getHostelRoomDetailsById(hostelId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult? Function(String hostelId)? getHostelRoomDetailsById,
  }) {
    return getHostelRoomDetailsById?.call(hostelId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Map<String, dynamic> rooms, String hostelId)?
        addRoomsToFirestore,
    TResult Function(String hostelId)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) {
    if (getHostelRoomDetailsById != null) {
      return getHostelRoomDetailsById(hostelId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_addRoomsToFirestore value) addRoomsToFirestore,
    required TResult Function(_getHostelRoomDetailsById value)
        getHostelRoomDetailsById,
  }) {
    return getHostelRoomDetailsById(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult? Function(_getHostelRoomDetailsById value)?
        getHostelRoomDetailsById,
  }) {
    return getHostelRoomDetailsById?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_addRoomsToFirestore value)? addRoomsToFirestore,
    TResult Function(_getHostelRoomDetailsById value)? getHostelRoomDetailsById,
    required TResult orElse(),
  }) {
    if (getHostelRoomDetailsById != null) {
      return getHostelRoomDetailsById(this);
    }
    return orElse();
  }
}

abstract class _getHostelRoomDetailsById implements RoomDetailsEvent {
  const factory _getHostelRoomDetailsById({required final String hostelId}) =
      _$getHostelRoomDetailsByIdImpl;

  @override
  String get hostelId;

  /// Create a copy of RoomDetailsEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$getHostelRoomDetailsByIdImplCopyWith<_$getHostelRoomDetailsByIdImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RoomDetailsState {
  bool get isSubmitting => throw _privateConstructorUsedError;
  Option<Either<FormFailures, Unit>> get successOrFailureOption =>
      throw _privateConstructorUsedError;
  Option<Either<FormFailures, List<Map<String, dynamic>>>>
      get fetchSuccessOrFailureOption => throw _privateConstructorUsedError;

  /// Create a copy of RoomDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomDetailsStateCopyWith<RoomDetailsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomDetailsStateCopyWith<$Res> {
  factory $RoomDetailsStateCopyWith(
          RoomDetailsState value, $Res Function(RoomDetailsState) then) =
      _$RoomDetailsStateCopyWithImpl<$Res, RoomDetailsState>;
  @useResult
  $Res call(
      {bool isSubmitting,
      Option<Either<FormFailures, Unit>> successOrFailureOption,
      Option<Either<FormFailures, List<Map<String, dynamic>>>>
          fetchSuccessOrFailureOption});
}

/// @nodoc
class _$RoomDetailsStateCopyWithImpl<$Res, $Val extends RoomDetailsState>
    implements $RoomDetailsStateCopyWith<$Res> {
  _$RoomDetailsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? successOrFailureOption = null,
    Object? fetchSuccessOrFailureOption = null,
  }) {
    return _then(_value.copyWith(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      successOrFailureOption: null == successOrFailureOption
          ? _value.successOrFailureOption
          : successOrFailureOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<FormFailures, Unit>>,
      fetchSuccessOrFailureOption: null == fetchSuccessOrFailureOption
          ? _value.fetchSuccessOrFailureOption
          : fetchSuccessOrFailureOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<FormFailures, List<Map<String, dynamic>>>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomDetailsStateImplCopyWith<$Res>
    implements $RoomDetailsStateCopyWith<$Res> {
  factory _$$RoomDetailsStateImplCopyWith(_$RoomDetailsStateImpl value,
          $Res Function(_$RoomDetailsStateImpl) then) =
      __$$RoomDetailsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isSubmitting,
      Option<Either<FormFailures, Unit>> successOrFailureOption,
      Option<Either<FormFailures, List<Map<String, dynamic>>>>
          fetchSuccessOrFailureOption});
}

/// @nodoc
class __$$RoomDetailsStateImplCopyWithImpl<$Res>
    extends _$RoomDetailsStateCopyWithImpl<$Res, _$RoomDetailsStateImpl>
    implements _$$RoomDetailsStateImplCopyWith<$Res> {
  __$$RoomDetailsStateImplCopyWithImpl(_$RoomDetailsStateImpl _value,
      $Res Function(_$RoomDetailsStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoomDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? successOrFailureOption = null,
    Object? fetchSuccessOrFailureOption = null,
  }) {
    return _then(_$RoomDetailsStateImpl(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      successOrFailureOption: null == successOrFailureOption
          ? _value.successOrFailureOption
          : successOrFailureOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<FormFailures, Unit>>,
      fetchSuccessOrFailureOption: null == fetchSuccessOrFailureOption
          ? _value.fetchSuccessOrFailureOption
          : fetchSuccessOrFailureOption // ignore: cast_nullable_to_non_nullable
              as Option<Either<FormFailures, List<Map<String, dynamic>>>>,
    ));
  }
}

/// @nodoc

class _$RoomDetailsStateImpl implements _RoomDetailsState {
  _$RoomDetailsStateImpl(
      {required this.isSubmitting,
      required this.successOrFailureOption,
      required this.fetchSuccessOrFailureOption});

  @override
  final bool isSubmitting;
  @override
  final Option<Either<FormFailures, Unit>> successOrFailureOption;
  @override
  final Option<Either<FormFailures, List<Map<String, dynamic>>>>
      fetchSuccessOrFailureOption;

  @override
  String toString() {
    return 'RoomDetailsState(isSubmitting: $isSubmitting, successOrFailureOption: $successOrFailureOption, fetchSuccessOrFailureOption: $fetchSuccessOrFailureOption)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomDetailsStateImpl &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.successOrFailureOption, successOrFailureOption) ||
                other.successOrFailureOption == successOrFailureOption) &&
            (identical(other.fetchSuccessOrFailureOption,
                    fetchSuccessOrFailureOption) ||
                other.fetchSuccessOrFailureOption ==
                    fetchSuccessOrFailureOption));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isSubmitting,
      successOrFailureOption, fetchSuccessOrFailureOption);

  /// Create a copy of RoomDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomDetailsStateImplCopyWith<_$RoomDetailsStateImpl> get copyWith =>
      __$$RoomDetailsStateImplCopyWithImpl<_$RoomDetailsStateImpl>(
          this, _$identity);
}

abstract class _RoomDetailsState implements RoomDetailsState {
  factory _RoomDetailsState(
      {required final bool isSubmitting,
      required final Option<Either<FormFailures, Unit>> successOrFailureOption,
      required final Option<Either<FormFailures, List<Map<String, dynamic>>>>
          fetchSuccessOrFailureOption}) = _$RoomDetailsStateImpl;

  @override
  bool get isSubmitting;
  @override
  Option<Either<FormFailures, Unit>> get successOrFailureOption;
  @override
  Option<Either<FormFailures, List<Map<String, dynamic>>>>
      get fetchSuccessOrFailureOption;

  /// Create a copy of RoomDetailsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomDetailsStateImplCopyWith<_$RoomDetailsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
