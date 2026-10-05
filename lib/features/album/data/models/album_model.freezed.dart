// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumModel {

 String get id; String get title; String? get coverUrl; String get artistId; String get artistName; int get trackCount; DateTime get releaseDate;
/// Create a copy of AlbumModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumModelCopyWith<AlbumModel> get copyWith => _$AlbumModelCopyWithImpl<AlbumModel>(this as AlbumModel, _$identity);

  /// Serializes this AlbumModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlbumModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.artistId, _this.artistId) || other.artistId == _this.artistId)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.trackCount, _this.trackCount) || other.trackCount == _this.trackCount)&&(identical(other.releaseDate, _this.releaseDate) || other.releaseDate == _this.releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlbumModel;
  return Object.hash(runtimeType,_this.id,_this.title,_this.coverUrl,_this.artistId,_this.artistName,_this.trackCount,_this.releaseDate);
}

@override
String toString() {
  final _this = this as AlbumModel;
  return 'AlbumModel(id: ${_this.id}, title: ${_this.title}, coverUrl: ${_this.coverUrl}, artistId: ${_this.artistId}, artistName: ${_this.artistName}, trackCount: ${_this.trackCount}, releaseDate: ${_this.releaseDate})';
}


}

/// @nodoc
abstract mixin class $AlbumModelCopyWith<$Res>  {
  factory $AlbumModelCopyWith(AlbumModel value, $Res Function(AlbumModel) _then) = _$AlbumModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? coverUrl, String artistId, String artistName, int trackCount, DateTime releaseDate
});




}
/// @nodoc
class _$AlbumModelCopyWithImpl<$Res>
    implements $AlbumModelCopyWith<$Res> {
  _$AlbumModelCopyWithImpl(this._self, this._then);

  final AlbumModel _self;
  final $Res Function(AlbumModel) _then;

/// Create a copy of AlbumModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? coverUrl = freezed,Object? artistId = null,Object? artistName = null,Object? trackCount = null,Object? releaseDate = null,}) {
  return _then(AlbumModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumModel].
extension AlbumModelPatterns on AlbumModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumModel value)  $default,){
final _that = this;
switch (_that) {
case _AlbumModel():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumModel value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? coverUrl,  String artistId,  String artistName,  int trackCount,  DateTime releaseDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlbumModel() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.artistId,_that.artistName,_that.trackCount,_that.releaseDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? coverUrl,  String artistId,  String artistName,  int trackCount,  DateTime releaseDate)  $default,) {final _that = this;
switch (_that) {
case _AlbumModel():
return $default(_that.id,_that.title,_that.coverUrl,_that.artistId,_that.artistName,_that.trackCount,_that.releaseDate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? coverUrl,  String artistId,  String artistName,  int trackCount,  DateTime releaseDate)?  $default,) {final _that = this;
switch (_that) {
case _AlbumModel() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.artistId,_that.artistName,_that.trackCount,_that.releaseDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlbumModel implements AlbumModel {
  const _AlbumModel({required this.id, required this.title, this.coverUrl, required this.artistId, required this.artistName, this.trackCount = 0, required this.releaseDate});
  factory _AlbumModel.fromJson(Map<String, dynamic> json) => _$AlbumModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? coverUrl;
@override final  String artistId;
@override final  String artistName;
@override@JsonKey() final  int trackCount;
@override final  DateTime releaseDate;

/// Create a copy of AlbumModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumModelCopyWith<_AlbumModel> get copyWith => __$AlbumModelCopyWithImpl<_AlbumModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,coverUrl,artistId,artistName,trackCount,releaseDate);
}

@override
String toString() {
    return 'AlbumModel(id: $id, title: $title, coverUrl: $coverUrl, artistId: $artistId, artistName: $artistName, trackCount: $trackCount, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class _$AlbumModelCopyWith<$Res> implements $AlbumModelCopyWith<$Res> {
  factory _$AlbumModelCopyWith(_AlbumModel value, $Res Function(_AlbumModel) _then) = __$AlbumModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? coverUrl, String artistId, String artistName, int trackCount, DateTime releaseDate
});




}
/// @nodoc
class __$AlbumModelCopyWithImpl<$Res>
    implements _$AlbumModelCopyWith<$Res> {
  __$AlbumModelCopyWithImpl(this._self, this._then);

  final _AlbumModel _self;
  final $Res Function(_AlbumModel) _then;

/// Create a copy of AlbumModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? coverUrl = freezed,Object? artistId = null,Object? artistName = null,Object? trackCount = null,Object? releaseDate = null,}) {
  return _then(_AlbumModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,artistId: null == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String,artistName: null == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String,trackCount: null == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int,releaseDate: null == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
