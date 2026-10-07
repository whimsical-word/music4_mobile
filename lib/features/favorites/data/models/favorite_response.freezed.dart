// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FavoriteResponse {

 int get favoriteId; int get trackId; String get trackName; String get artistName; String? get img;/// ISO local date-time, e.g. 2026-10-08T12:30:45.123456.
 String? get likedAt;
/// Create a copy of FavoriteResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteResponseCopyWith<FavoriteResponse> get copyWith => _$FavoriteResponseCopyWithImpl<FavoriteResponse>(this as FavoriteResponse, _$identity);

  /// Serializes this FavoriteResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FavoriteResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteResponse&&(identical(other.favoriteId, _this.favoriteId) || other.favoriteId == _this.favoriteId)&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.trackName, _this.trackName) || other.trackName == _this.trackName)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.likedAt, _this.likedAt) || other.likedAt == _this.likedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FavoriteResponse;
  return Object.hash(runtimeType,_this.favoriteId,_this.trackId,_this.trackName,_this.artistName,_this.img,_this.likedAt);
}

@override
String toString() {
  final _this = this as FavoriteResponse;
  return 'FavoriteResponse(favoriteId: ${_this.favoriteId}, trackId: ${_this.trackId}, trackName: ${_this.trackName}, artistName: ${_this.artistName}, img: ${_this.img}, likedAt: ${_this.likedAt})';
}


}

/// @nodoc
abstract mixin class $FavoriteResponseCopyWith<$Res>  {
  factory $FavoriteResponseCopyWith(FavoriteResponse value, $Res Function(FavoriteResponse) _then) = _$FavoriteResponseCopyWithImpl;
@useResult
$Res call({
 int favoriteId, int trackId, String trackName, String artistName, String? img, String? likedAt
});




}
/// @nodoc
class _$FavoriteResponseCopyWithImpl<$Res>
    implements $FavoriteResponseCopyWith<$Res> {
  _$FavoriteResponseCopyWithImpl(this._self, this._then);

  final FavoriteResponse _self;
  final $Res Function(FavoriteResponse) _then;

/// Create a copy of FavoriteResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? favoriteId = null,Object? trackId = null,Object? trackName = null,Object? artistName = null,Object? img = freezed,Object? likedAt = freezed,}) {
  return _then(FavoriteResponse(
favoriteId: null == favoriteId ? _self.favoriteId : favoriteId // ignore: cast_nullable_to_non_nullable
as int,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int,trackName: null == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,likedAt: freezed == likedAt ? _self.likedAt : likedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FavoriteResponse].
extension FavoriteResponsePatterns on FavoriteResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteResponse value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int favoriteId,  int trackId,  String trackName,  String artistName,  String? img,  String? likedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteResponse() when $default != null:
return $default(_that.favoriteId,_that.trackId,_that.trackName,_that.artistName,_that.img,_that.likedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int favoriteId,  int trackId,  String trackName,  String artistName,  String? img,  String? likedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteResponse():
return $default(_that.favoriteId,_that.trackId,_that.trackName,_that.artistName,_that.img,_that.likedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int favoriteId,  int trackId,  String trackName,  String artistName,  String? img,  String? likedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteResponse() when $default != null:
return $default(_that.favoriteId,_that.trackId,_that.trackName,_that.artistName,_that.img,_that.likedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FavoriteResponse implements FavoriteResponse {
  const _FavoriteResponse({required this.favoriteId, required this.trackId, required this.trackName, this.artistName = '', this.img, this.likedAt});
  factory _FavoriteResponse.fromJson(Map<String, dynamic> json) => _$FavoriteResponseFromJson(json);

@override final  int favoriteId;
@override final  int trackId;
@override final  String trackName;
@override@JsonKey() final  String artistName;
@override final  String? img;
/// ISO local date-time, e.g. 2026-10-08T12:30:45.123456.
@override final  String? likedAt;

/// Create a copy of FavoriteResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteResponseCopyWith<_FavoriteResponse> get copyWith => __$FavoriteResponseCopyWithImpl<_FavoriteResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FavoriteResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteResponse&&(identical(other.favoriteId, favoriteId) || other.favoriteId == favoriteId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackName, trackName) || other.trackName == trackName)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.img, img) || other.img == img)&&(identical(other.likedAt, likedAt) || other.likedAt == likedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,favoriteId,trackId,trackName,artistName,img,likedAt);
}

@override
String toString() {
    return 'FavoriteResponse(favoriteId: $favoriteId, trackId: $trackId, trackName: $trackName, artistName: $artistName, img: $img, likedAt: $likedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteResponseCopyWith<$Res> implements $FavoriteResponseCopyWith<$Res> {
  factory _$FavoriteResponseCopyWith(_FavoriteResponse value, $Res Function(_FavoriteResponse) _then) = __$FavoriteResponseCopyWithImpl;
@override @useResult
$Res call({
 int favoriteId, int trackId, String trackName, String artistName, String? img, String? likedAt
});




}
/// @nodoc
class __$FavoriteResponseCopyWithImpl<$Res>
    implements _$FavoriteResponseCopyWith<$Res> {
  __$FavoriteResponseCopyWithImpl(this._self, this._then);

  final _FavoriteResponse _self;
  final $Res Function(_FavoriteResponse) _then;

/// Create a copy of FavoriteResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? favoriteId = null,Object? trackId = null,Object? trackName = null,Object? artistName = null,Object? img = freezed,Object? likedAt = freezed,}) {
  return _then(_FavoriteResponse(
favoriteId: null == favoriteId ? _self.favoriteId : favoriteId // ignore: cast_nullable_to_non_nullable
as int,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int,trackName: null == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,likedAt: freezed == likedAt ? _self.likedAt : likedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
