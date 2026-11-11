// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackArtistInfoModel {

 int? get id; String? get name; String? get role;
/// Create a copy of TrackArtistInfoModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackArtistInfoModelCopyWith<TrackArtistInfoModel> get copyWith => _$TrackArtistInfoModelCopyWithImpl<TrackArtistInfoModel>(this as TrackArtistInfoModel, _$identity);

  /// Serializes this TrackArtistInfoModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackArtistInfoModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackArtistInfoModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackArtistInfoModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as TrackArtistInfoModel;
  return 'TrackArtistInfoModel(id: ${_this.id}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $TrackArtistInfoModelCopyWith<$Res>  {
  factory $TrackArtistInfoModelCopyWith(TrackArtistInfoModel value, $Res Function(TrackArtistInfoModel) _then) = _$TrackArtistInfoModelCopyWithImpl;
@useResult
$Res call({
 int? id, String? name, String? role
});




}
/// @nodoc
class _$TrackArtistInfoModelCopyWithImpl<$Res>
    implements $TrackArtistInfoModelCopyWith<$Res> {
  _$TrackArtistInfoModelCopyWithImpl(this._self, this._then);

  final TrackArtistInfoModel _self;
  final $Res Function(TrackArtistInfoModel) _then;

/// Create a copy of TrackArtistInfoModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? role = freezed,}) {
  return _then(TrackArtistInfoModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackArtistInfoModel].
extension TrackArtistInfoModelPatterns on TrackArtistInfoModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackArtistInfoModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackArtistInfoModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackArtistInfoModel value)  $default,){
final _that = this;
switch (_that) {
case _TrackArtistInfoModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackArtistInfoModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrackArtistInfoModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? name,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackArtistInfoModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? name,  String? role)  $default,) {final _that = this;
switch (_that) {
case _TrackArtistInfoModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? name,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _TrackArtistInfoModel() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackArtistInfoModel implements TrackArtistInfoModel {
  const _TrackArtistInfoModel({this.id, this.name, this.role});
  factory _TrackArtistInfoModel.fromJson(Map<String, dynamic> json) => _$TrackArtistInfoModelFromJson(json);

@override final  int? id;
@override final  String? name;
@override final  String? role;

/// Create a copy of TrackArtistInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackArtistInfoModelCopyWith<_TrackArtistInfoModel> get copyWith => __$TrackArtistInfoModelCopyWithImpl<_TrackArtistInfoModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackArtistInfoModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackArtistInfoModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role);
}

@override
String toString() {
    return 'TrackArtistInfoModel(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$TrackArtistInfoModelCopyWith<$Res> implements $TrackArtistInfoModelCopyWith<$Res> {
  factory _$TrackArtistInfoModelCopyWith(_TrackArtistInfoModel value, $Res Function(_TrackArtistInfoModel) _then) = __$TrackArtistInfoModelCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? name, String? role
});




}
/// @nodoc
class __$TrackArtistInfoModelCopyWithImpl<$Res>
    implements _$TrackArtistInfoModelCopyWith<$Res> {
  __$TrackArtistInfoModelCopyWithImpl(this._self, this._then);

  final _TrackArtistInfoModel _self;
  final $Res Function(_TrackArtistInfoModel) _then;

/// Create a copy of TrackArtistInfoModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? role = freezed,}) {
  return _then(_TrackArtistInfoModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PlaylistTrackModel {

 int get id; String get name; String? get albumName; String? get img; int get duration; String? get filePath; String? get previewPath; int get viewCount; List<TrackArtistInfoModel> get artists;
/// Create a copy of PlaylistTrackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistTrackModelCopyWith<PlaylistTrackModel> get copyWith => _$PlaylistTrackModelCopyWithImpl<PlaylistTrackModel>(this as PlaylistTrackModel, _$identity);

  /// Serializes this PlaylistTrackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlaylistTrackModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistTrackModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.albumName, _this.albumName) || other.albumName == _this.albumName)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.filePath, _this.filePath) || other.filePath == _this.filePath)&&(identical(other.previewPath, _this.previewPath) || other.previewPath == _this.previewPath)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&const DeepCollectionEquality().equals(other.artists, _this.artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlaylistTrackModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.albumName,_this.img,_this.duration,_this.filePath,_this.previewPath,_this.viewCount,const DeepCollectionEquality().hash(_this.artists));
}

@override
String toString() {
  final _this = this as PlaylistTrackModel;
  return 'PlaylistTrackModel(id: ${_this.id}, name: ${_this.name}, albumName: ${_this.albumName}, img: ${_this.img}, duration: ${_this.duration}, filePath: ${_this.filePath}, previewPath: ${_this.previewPath}, viewCount: ${_this.viewCount}, artists: ${_this.artists})';
}


}

/// @nodoc
abstract mixin class $PlaylistTrackModelCopyWith<$Res>  {
  factory $PlaylistTrackModelCopyWith(PlaylistTrackModel value, $Res Function(PlaylistTrackModel) _then) = _$PlaylistTrackModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? albumName, String? img, int duration, String? filePath, String? previewPath, int viewCount, List<TrackArtistInfoModel> artists
});




}
/// @nodoc
class _$PlaylistTrackModelCopyWithImpl<$Res>
    implements $PlaylistTrackModelCopyWith<$Res> {
  _$PlaylistTrackModelCopyWithImpl(this._self, this._then);

  final PlaylistTrackModel _self;
  final $Res Function(PlaylistTrackModel) _then;

/// Create a copy of PlaylistTrackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? albumName = freezed,Object? img = freezed,Object? duration = null,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = null,Object? artists = null,}) {
  return _then(PlaylistTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfoModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaylistTrackModel].
extension PlaylistTrackModelPatterns on PlaylistTrackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaylistTrackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaylistTrackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaylistTrackModel value)  $default,){
final _that = this;
switch (_that) {
case _PlaylistTrackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaylistTrackModel value)?  $default,){
final _that = this;
switch (_that) {
case _PlaylistTrackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int viewCount,  List<TrackArtistInfoModel> artists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaylistTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.artists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int viewCount,  List<TrackArtistInfoModel> artists)  $default,) {final _that = this;
switch (_that) {
case _PlaylistTrackModel():
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.artists);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int viewCount,  List<TrackArtistInfoModel> artists)?  $default,) {final _that = this;
switch (_that) {
case _PlaylistTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.artists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaylistTrackModel extends PlaylistTrackModel {
  const _PlaylistTrackModel({required this.id, required this.name, this.albumName, this.img, this.duration = 0, this.filePath, this.previewPath, this.viewCount = 0,  List<TrackArtistInfoModel> artists = const []}): _artists = artists,super._();
  factory _PlaylistTrackModel.fromJson(Map<String, dynamic> json) => _$PlaylistTrackModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? albumName;
@override final  String? img;
@override@JsonKey() final  int duration;
@override final  String? filePath;
@override final  String? previewPath;
@override@JsonKey() final  int viewCount;
 final  List<TrackArtistInfoModel> _artists;
@override@JsonKey() List<TrackArtistInfoModel> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}


/// Create a copy of PlaylistTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaylistTrackModelCopyWith<_PlaylistTrackModel> get copyWith => __$PlaylistTrackModelCopyWithImpl<_PlaylistTrackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaylistTrackModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaylistTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.img, img) || other.img == img)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&const DeepCollectionEquality().equals(other.artists, _artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,albumName,img,duration,filePath,previewPath,viewCount,const DeepCollectionEquality().hash(_artists));
}

@override
String toString() {
    return 'PlaylistTrackModel(id: $id, name: $name, albumName: $albumName, img: $img, duration: $duration, filePath: $filePath, previewPath: $previewPath, viewCount: $viewCount, artists: $artists)';
}


}

/// @nodoc
abstract mixin class _$PlaylistTrackModelCopyWith<$Res> implements $PlaylistTrackModelCopyWith<$Res> {
  factory _$PlaylistTrackModelCopyWith(_PlaylistTrackModel value, $Res Function(_PlaylistTrackModel) _then) = __$PlaylistTrackModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? albumName, String? img, int duration, String? filePath, String? previewPath, int viewCount, List<TrackArtistInfoModel> artists
});




}
/// @nodoc
class __$PlaylistTrackModelCopyWithImpl<$Res>
    implements _$PlaylistTrackModelCopyWith<$Res> {
  __$PlaylistTrackModelCopyWithImpl(this._self, this._then);

  final _PlaylistTrackModel _self;
  final $Res Function(_PlaylistTrackModel) _then;

/// Create a copy of PlaylistTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? albumName = freezed,Object? img = freezed,Object? duration = null,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = null,Object? artists = null,}) {
  return _then(_PlaylistTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfoModel>,
  ));
}


}

// dart format on
