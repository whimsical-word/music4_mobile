// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_artist_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackArtistInfo {

 int get id; String get name; String? get role;
/// Create a copy of TrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackArtistInfoCopyWith<TrackArtistInfo> get copyWith => _$TrackArtistInfoCopyWithImpl<TrackArtistInfo>(this as TrackArtistInfo, _$identity);

  /// Serializes this TrackArtistInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackArtistInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackArtistInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackArtistInfo;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as TrackArtistInfo;
  return 'TrackArtistInfo(id: ${_this.id}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TrackArtistInfoCopyWith<$Res>  {
  factory $TrackArtistInfoCopyWith(TrackArtistInfo value, $Res Function(TrackArtistInfo) _then) = _$TrackArtistInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class _$TrackArtistInfoCopyWithImpl<$Res>
    implements $TrackArtistInfoCopyWith<$Res> {
  _$TrackArtistInfoCopyWithImpl(this._self, this._then);

  final TrackArtistInfo _self;
  final $Res Function(TrackArtistInfo) _then;

/// Create a copy of TrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(TrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackArtistInfo].
extension TrackArtistInfoPatterns on TrackArtistInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackArtistInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackArtistInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackArtistInfo value)  $default,){
final _that = this;
switch (_that) {
case _TrackArtistInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackArtistInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TrackArtistInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackArtistInfo() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? role)  $default,) {final _that = this;
switch (_that) {
case _TrackArtistInfo():
return $default(_that.id,_that.name,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _TrackArtistInfo() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackArtistInfo implements TrackArtistInfo {
  const _TrackArtistInfo({required this.id, required this.name, this.role});
  factory _TrackArtistInfo.fromJson(Map<String, dynamic> json) => _$TrackArtistInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? role;

/// Create a copy of TrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackArtistInfoCopyWith<_TrackArtistInfo> get copyWith => __$TrackArtistInfoCopyWithImpl<_TrackArtistInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackArtistInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackArtistInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role);
}

@override
String toString() {
    return 'TrackArtistInfo(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TrackArtistInfoCopyWith<$Res> implements $TrackArtistInfoCopyWith<$Res> {
  factory _$TrackArtistInfoCopyWith(_TrackArtistInfo value, $Res Function(_TrackArtistInfo) _then) = __$TrackArtistInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class __$TrackArtistInfoCopyWithImpl<$Res>
    implements _$TrackArtistInfoCopyWith<$Res> {
  __$TrackArtistInfoCopyWithImpl(this._self, this._then);

  final _TrackArtistInfo _self;
  final $Res Function(_TrackArtistInfo) _then;

/// Create a copy of TrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(_TrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
