// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtistResponse {

 int get id; String get name; String? get img; String? get cover; int get trackTotal; int get albumTotal;
/// Create a copy of ArtistResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistResponseCopyWith<ArtistResponse> get copyWith => _$ArtistResponseCopyWithImpl<ArtistResponse>(this as ArtistResponse, _$identity);

  /// Serializes this ArtistResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArtistResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.cover, _this.cover) || other.cover == _this.cover)&&(identical(other.trackTotal, _this.trackTotal) || other.trackTotal == _this.trackTotal)&&(identical(other.albumTotal, _this.albumTotal) || other.albumTotal == _this.albumTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArtistResponse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.cover,_this.trackTotal,_this.albumTotal);
}

@override
String toString() {
  final _this = this as ArtistResponse;
  return 'ArtistResponse(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, cover: ${_this.cover}, trackTotal: ${_this.trackTotal}, albumTotal: ${_this.albumTotal})';
}


}

/// @nodoc
abstract mixin class $ArtistResponseCopyWith<$Res>  {
  factory $ArtistResponseCopyWith(ArtistResponse value, $Res Function(ArtistResponse) _then) = _$ArtistResponseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, String? cover, int trackTotal, int albumTotal
});




}
/// @nodoc
class _$ArtistResponseCopyWithImpl<$Res>
    implements $ArtistResponseCopyWith<$Res> {
  _$ArtistResponseCopyWithImpl(this._self, this._then);

  final ArtistResponse _self;
  final $Res Function(ArtistResponse) _then;

/// Create a copy of ArtistResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? cover = freezed,Object? trackTotal = null,Object? albumTotal = null,}) {
  return _then(ArtistResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: null == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int,albumTotal: null == albumTotal ? _self.albumTotal : albumTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistResponse].
extension ArtistResponsePatterns on ArtistResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistResponse value)  $default,){
final _that = this;
switch (_that) {
case _ArtistResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? cover,  int trackTotal,  int albumTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistResponse() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.cover,_that.trackTotal,_that.albumTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? cover,  int trackTotal,  int albumTotal)  $default,) {final _that = this;
switch (_that) {
case _ArtistResponse():
return $default(_that.id,_that.name,_that.img,_that.cover,_that.trackTotal,_that.albumTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  String? cover,  int trackTotal,  int albumTotal)?  $default,) {final _that = this;
switch (_that) {
case _ArtistResponse() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.cover,_that.trackTotal,_that.albumTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistResponse implements ArtistResponse {
  const _ArtistResponse({required this.id, required this.name, this.img, this.cover, this.trackTotal = 0, this.albumTotal = 0});
  factory _ArtistResponse.fromJson(Map<String, dynamic> json) => _$ArtistResponseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  String? cover;
@override@JsonKey() final  int trackTotal;
@override@JsonKey() final  int albumTotal;

/// Create a copy of ArtistResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistResponseCopyWith<_ArtistResponse> get copyWith => __$ArtistResponseCopyWithImpl<_ArtistResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.trackTotal, trackTotal) || other.trackTotal == trackTotal)&&(identical(other.albumTotal, albumTotal) || other.albumTotal == albumTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,cover,trackTotal,albumTotal);
}

@override
String toString() {
    return 'ArtistResponse(id: $id, name: $name, img: $img, cover: $cover, trackTotal: $trackTotal, albumTotal: $albumTotal)';
}


}

/// @nodoc
abstract mixin class _$ArtistResponseCopyWith<$Res> implements $ArtistResponseCopyWith<$Res> {
  factory _$ArtistResponseCopyWith(_ArtistResponse value, $Res Function(_ArtistResponse) _then) = __$ArtistResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, String? cover, int trackTotal, int albumTotal
});




}
/// @nodoc
class __$ArtistResponseCopyWithImpl<$Res>
    implements _$ArtistResponseCopyWith<$Res> {
  __$ArtistResponseCopyWithImpl(this._self, this._then);

  final _ArtistResponse _self;
  final $Res Function(_ArtistResponse) _then;

/// Create a copy of ArtistResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? cover = freezed,Object? trackTotal = null,Object? albumTotal = null,}) {
  return _then(_ArtistResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: null == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int,albumTotal: null == albumTotal ? _self.albumTotal : albumTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
