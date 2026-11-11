// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_play_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackPlayRequest {

 String get trackId; String? get userId;
/// Create a copy of TrackPlayRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackPlayRequestCopyWith<TrackPlayRequest> get copyWith => _$TrackPlayRequestCopyWithImpl<TrackPlayRequest>(this as TrackPlayRequest, _$identity);

  /// Serializes this TrackPlayRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackPlayRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackPlayRequest&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackPlayRequest;
  return Object.hash(runtimeType,_this.trackId,_this.userId);
}

@override
String toString() {
  final _this = this as TrackPlayRequest;
  return 'TrackPlayRequest(trackId: ${_this.trackId}, userId: ${_this.userId})';
}


}

/// @nodoc
abstract mixin class $TrackPlayRequestCopyWith<$Res>  {
  factory $TrackPlayRequestCopyWith(TrackPlayRequest value, $Res Function(TrackPlayRequest) _then) = _$TrackPlayRequestCopyWithImpl;
@useResult
$Res call({
 String trackId, String? userId
});




}
/// @nodoc
class _$TrackPlayRequestCopyWithImpl<$Res>
    implements $TrackPlayRequestCopyWith<$Res> {
  _$TrackPlayRequestCopyWithImpl(this._self, this._then);

  final TrackPlayRequest _self;
  final $Res Function(TrackPlayRequest) _then;

/// Create a copy of TrackPlayRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackId = null,Object? userId = freezed,}) {
  return _then(TrackPlayRequest(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackPlayRequest].
extension TrackPlayRequestPatterns on TrackPlayRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackPlayRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackPlayRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackPlayRequest value)  $default,){
final _that = this;
switch (_that) {
case _TrackPlayRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackPlayRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TrackPlayRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String trackId,  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackPlayRequest() when $default != null:
return $default(_that.trackId,_that.userId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String trackId,  String? userId)  $default,) {final _that = this;
switch (_that) {
case _TrackPlayRequest():
return $default(_that.trackId,_that.userId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String trackId,  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _TrackPlayRequest() when $default != null:
return $default(_that.trackId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackPlayRequest implements TrackPlayRequest {
  const _TrackPlayRequest({required this.trackId, this.userId});
  factory _TrackPlayRequest.fromJson(Map<String, dynamic> json) => _$TrackPlayRequestFromJson(json);

@override final  String trackId;
@override final  String? userId;

/// Create a copy of TrackPlayRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackPlayRequestCopyWith<_TrackPlayRequest> get copyWith => __$TrackPlayRequestCopyWithImpl<_TrackPlayRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackPlayRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackPlayRequest&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,trackId,userId);
}

@override
String toString() {
    return 'TrackPlayRequest(trackId: $trackId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$TrackPlayRequestCopyWith<$Res> implements $TrackPlayRequestCopyWith<$Res> {
  factory _$TrackPlayRequestCopyWith(_TrackPlayRequest value, $Res Function(_TrackPlayRequest) _then) = __$TrackPlayRequestCopyWithImpl;
@override @useResult
$Res call({
 String trackId, String? userId
});




}
/// @nodoc
class __$TrackPlayRequestCopyWithImpl<$Res>
    implements _$TrackPlayRequestCopyWith<$Res> {
  __$TrackPlayRequestCopyWithImpl(this._self, this._then);

  final _TrackPlayRequest _self;
  final $Res Function(_TrackPlayRequest) _then;

/// Create a copy of TrackPlayRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackId = null,Object? userId = freezed,}) {
  return _then(_TrackPlayRequest(
trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
