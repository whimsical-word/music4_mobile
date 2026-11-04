// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CategoryDetailModel {

 int get id; String get name; List<CategoryTrackModel> get tracks;
/// Create a copy of CategoryDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryDetailModelCopyWith<CategoryDetailModel> get copyWith => _$CategoryDetailModelCopyWithImpl<CategoryDetailModel>(this as CategoryDetailModel, _$identity);

  /// Serializes this CategoryDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryDetailModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryDetailModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.tracks, _this.tracks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryDetailModel;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.tracks));
}

@override
String toString() {
  final _this = this as CategoryDetailModel;
  return 'CategoryDetailModel(id: ${_this.id}, name: ${_this.name}, tracks: ${_this.tracks})';
}


}

/// @nodoc
abstract mixin class $CategoryDetailModelCopyWith<$Res>  {
  factory $CategoryDetailModelCopyWith(CategoryDetailModel value, $Res Function(CategoryDetailModel) _then) = _$CategoryDetailModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, List<CategoryTrackModel> tracks
});




}
/// @nodoc
class _$CategoryDetailModelCopyWithImpl<$Res>
    implements $CategoryDetailModelCopyWith<$Res> {
  _$CategoryDetailModelCopyWithImpl(this._self, this._then);

  final CategoryDetailModel _self;
  final $Res Function(CategoryDetailModel) _then;

/// Create a copy of CategoryDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? tracks = null,}) {
  return _then(CategoryDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<CategoryTrackModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryDetailModel].
extension CategoryDetailModelPatterns on CategoryDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  List<CategoryTrackModel> tracks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.tracks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  List<CategoryTrackModel> tracks)  $default,) {final _that = this;
switch (_that) {
case _CategoryDetailModel():
return $default(_that.id,_that.name,_that.tracks);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  List<CategoryTrackModel> tracks)?  $default,) {final _that = this;
switch (_that) {
case _CategoryDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.tracks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryDetailModel implements CategoryDetailModel {
  const _CategoryDetailModel({required this.id, required this.name,  List<CategoryTrackModel> tracks = const []}): _tracks = tracks;
  factory _CategoryDetailModel.fromJson(Map<String, dynamic> json) => _$CategoryDetailModelFromJson(json);

@override final  int id;
@override final  String name;
 final  List<CategoryTrackModel> _tracks;
@override@JsonKey() List<CategoryTrackModel> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}


/// Create a copy of CategoryDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryDetailModelCopyWith<_CategoryDetailModel> get copyWith => __$CategoryDetailModelCopyWithImpl<_CategoryDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.tracks, _tracks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_tracks));
}

@override
String toString() {
    return 'CategoryDetailModel(id: $id, name: $name, tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class _$CategoryDetailModelCopyWith<$Res> implements $CategoryDetailModelCopyWith<$Res> {
  factory _$CategoryDetailModelCopyWith(_CategoryDetailModel value, $Res Function(_CategoryDetailModel) _then) = __$CategoryDetailModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, List<CategoryTrackModel> tracks
});




}
/// @nodoc
class __$CategoryDetailModelCopyWithImpl<$Res>
    implements _$CategoryDetailModelCopyWith<$Res> {
  __$CategoryDetailModelCopyWithImpl(this._self, this._then);

  final _CategoryDetailModel _self;
  final $Res Function(_CategoryDetailModel) _then;

/// Create a copy of CategoryDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? tracks = null,}) {
  return _then(_CategoryDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<CategoryTrackModel>,
  ));
}


}


/// @nodoc
mixin _$CategoryTrackModel {

 int get id; String get name; String? get albumName; String? get img; int? get duration; String? get filePath; String? get previewPath; int? get viewCount; String? get uploadDate; int? get playbackPosition; List<CategoryTrackArtistInfo> get artists;
/// Create a copy of CategoryTrackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryTrackModelCopyWith<CategoryTrackModel> get copyWith => _$CategoryTrackModelCopyWithImpl<CategoryTrackModel>(this as CategoryTrackModel, _$identity);

  /// Serializes this CategoryTrackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryTrackModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryTrackModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.albumName, _this.albumName) || other.albumName == _this.albumName)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.filePath, _this.filePath) || other.filePath == _this.filePath)&&(identical(other.previewPath, _this.previewPath) || other.previewPath == _this.previewPath)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&(identical(other.uploadDate, _this.uploadDate) || other.uploadDate == _this.uploadDate)&&(identical(other.playbackPosition, _this.playbackPosition) || other.playbackPosition == _this.playbackPosition)&&const DeepCollectionEquality().equals(other.artists, _this.artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryTrackModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.albumName,_this.img,_this.duration,_this.filePath,_this.previewPath,_this.viewCount,_this.uploadDate,_this.playbackPosition,const DeepCollectionEquality().hash(_this.artists));
}

@override
String toString() {
  final _this = this as CategoryTrackModel;
  return 'CategoryTrackModel(id: ${_this.id}, name: ${_this.name}, albumName: ${_this.albumName}, img: ${_this.img}, duration: ${_this.duration}, filePath: ${_this.filePath}, previewPath: ${_this.previewPath}, viewCount: ${_this.viewCount}, uploadDate: ${_this.uploadDate}, playbackPosition: ${_this.playbackPosition}, artists: ${_this.artists})';
}


}

/// @nodoc
abstract mixin class $CategoryTrackModelCopyWith<$Res>  {
  factory $CategoryTrackModelCopyWith(CategoryTrackModel value, $Res Function(CategoryTrackModel) _then) = _$CategoryTrackModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? albumName, String? img, int? duration, String? filePath, String? previewPath, int? viewCount, String? uploadDate, int? playbackPosition, List<CategoryTrackArtistInfo> artists
});




}
/// @nodoc
class _$CategoryTrackModelCopyWithImpl<$Res>
    implements $CategoryTrackModelCopyWith<$Res> {
  _$CategoryTrackModelCopyWithImpl(this._self, this._then);

  final CategoryTrackModel _self;
  final $Res Function(CategoryTrackModel) _then;

/// Create a copy of CategoryTrackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? albumName = freezed,Object? img = freezed,Object? duration = freezed,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = freezed,Object? uploadDate = freezed,Object? playbackPosition = freezed,Object? artists = null,}) {
  return _then(CategoryTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,playbackPosition: freezed == playbackPosition ? _self.playbackPosition : playbackPosition // ignore: cast_nullable_to_non_nullable
as int?,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<CategoryTrackArtistInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryTrackModel].
extension CategoryTrackModelPatterns on CategoryTrackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryTrackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryTrackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryTrackModel value)  $default,){
final _that = this;
switch (_that) {
case _CategoryTrackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryTrackModel value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryTrackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? albumName,  String? img,  int? duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int? playbackPosition,  List<CategoryTrackArtistInfo> artists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.uploadDate,_that.playbackPosition,_that.artists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? albumName,  String? img,  int? duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int? playbackPosition,  List<CategoryTrackArtistInfo> artists)  $default,) {final _that = this;
switch (_that) {
case _CategoryTrackModel():
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.uploadDate,_that.playbackPosition,_that.artists);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? albumName,  String? img,  int? duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int? playbackPosition,  List<CategoryTrackArtistInfo> artists)?  $default,) {final _that = this;
switch (_that) {
case _CategoryTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.uploadDate,_that.playbackPosition,_that.artists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryTrackModel implements CategoryTrackModel {
  const _CategoryTrackModel({required this.id, required this.name, this.albumName, this.img, this.duration, this.filePath, this.previewPath, this.viewCount, this.uploadDate, this.playbackPosition,  List<CategoryTrackArtistInfo> artists = const []}): _artists = artists;
  factory _CategoryTrackModel.fromJson(Map<String, dynamic> json) => _$CategoryTrackModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? albumName;
@override final  String? img;
@override final  int? duration;
@override final  String? filePath;
@override final  String? previewPath;
@override final  int? viewCount;
@override final  String? uploadDate;
@override final  int? playbackPosition;
 final  List<CategoryTrackArtistInfo> _artists;
@override@JsonKey() List<CategoryTrackArtistInfo> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}


/// Create a copy of CategoryTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryTrackModelCopyWith<_CategoryTrackModel> get copyWith => __$CategoryTrackModelCopyWithImpl<_CategoryTrackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryTrackModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.img, img) || other.img == img)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.playbackPosition, playbackPosition) || other.playbackPosition == playbackPosition)&&const DeepCollectionEquality().equals(other.artists, _artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,albumName,img,duration,filePath,previewPath,viewCount,uploadDate,playbackPosition,const DeepCollectionEquality().hash(_artists));
}

@override
String toString() {
    return 'CategoryTrackModel(id: $id, name: $name, albumName: $albumName, img: $img, duration: $duration, filePath: $filePath, previewPath: $previewPath, viewCount: $viewCount, uploadDate: $uploadDate, playbackPosition: $playbackPosition, artists: $artists)';
}


}

/// @nodoc
abstract mixin class _$CategoryTrackModelCopyWith<$Res> implements $CategoryTrackModelCopyWith<$Res> {
  factory _$CategoryTrackModelCopyWith(_CategoryTrackModel value, $Res Function(_CategoryTrackModel) _then) = __$CategoryTrackModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? albumName, String? img, int? duration, String? filePath, String? previewPath, int? viewCount, String? uploadDate, int? playbackPosition, List<CategoryTrackArtistInfo> artists
});




}
/// @nodoc
class __$CategoryTrackModelCopyWithImpl<$Res>
    implements _$CategoryTrackModelCopyWith<$Res> {
  __$CategoryTrackModelCopyWithImpl(this._self, this._then);

  final _CategoryTrackModel _self;
  final $Res Function(_CategoryTrackModel) _then;

/// Create a copy of CategoryTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? albumName = freezed,Object? img = freezed,Object? duration = freezed,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = freezed,Object? uploadDate = freezed,Object? playbackPosition = freezed,Object? artists = null,}) {
  return _then(_CategoryTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,playbackPosition: freezed == playbackPosition ? _self.playbackPosition : playbackPosition // ignore: cast_nullable_to_non_nullable
as int?,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<CategoryTrackArtistInfo>,
  ));
}


}


/// @nodoc
mixin _$CategoryTrackArtistInfo {

 int get id; String get name; String? get role;
/// Create a copy of CategoryTrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryTrackArtistInfoCopyWith<CategoryTrackArtistInfo> get copyWith => _$CategoryTrackArtistInfoCopyWithImpl<CategoryTrackArtistInfo>(this as CategoryTrackArtistInfo, _$identity);

  /// Serializes this CategoryTrackArtistInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CategoryTrackArtistInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryTrackArtistInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CategoryTrackArtistInfo;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as CategoryTrackArtistInfo;
  return 'CategoryTrackArtistInfo(id: ${_this.id}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $CategoryTrackArtistInfoCopyWith<$Res>  {
  factory $CategoryTrackArtistInfoCopyWith(CategoryTrackArtistInfo value, $Res Function(CategoryTrackArtistInfo) _then) = _$CategoryTrackArtistInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class _$CategoryTrackArtistInfoCopyWithImpl<$Res>
    implements $CategoryTrackArtistInfoCopyWith<$Res> {
  _$CategoryTrackArtistInfoCopyWithImpl(this._self, this._then);

  final CategoryTrackArtistInfo _self;
  final $Res Function(CategoryTrackArtistInfo) _then;

/// Create a copy of CategoryTrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(CategoryTrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CategoryTrackArtistInfo].
extension CategoryTrackArtistInfoPatterns on CategoryTrackArtistInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryTrackArtistInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryTrackArtistInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryTrackArtistInfo value)  $default,){
final _that = this;
switch (_that) {
case _CategoryTrackArtistInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryTrackArtistInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryTrackArtistInfo() when $default != null:
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
case _CategoryTrackArtistInfo() when $default != null:
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
case _CategoryTrackArtistInfo():
return $default(_that.id,_that.name,_that.role);}
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
case _CategoryTrackArtistInfo() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CategoryTrackArtistInfo implements CategoryTrackArtistInfo {
  const _CategoryTrackArtistInfo({required this.id, required this.name, this.role});
  factory _CategoryTrackArtistInfo.fromJson(Map<String, dynamic> json) => _$CategoryTrackArtistInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? role;

/// Create a copy of CategoryTrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryTrackArtistInfoCopyWith<_CategoryTrackArtistInfo> get copyWith => __$CategoryTrackArtistInfoCopyWithImpl<_CategoryTrackArtistInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CategoryTrackArtistInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryTrackArtistInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role);
}

@override
String toString() {
    return 'CategoryTrackArtistInfo(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$CategoryTrackArtistInfoCopyWith<$Res> implements $CategoryTrackArtistInfoCopyWith<$Res> {
  factory _$CategoryTrackArtistInfoCopyWith(_CategoryTrackArtistInfo value, $Res Function(_CategoryTrackArtistInfo) _then) = __$CategoryTrackArtistInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class __$CategoryTrackArtistInfoCopyWithImpl<$Res>
    implements _$CategoryTrackArtistInfoCopyWith<$Res> {
  __$CategoryTrackArtistInfoCopyWithImpl(this._self, this._then);

  final _CategoryTrackArtistInfo _self;
  final $Res Function(_CategoryTrackArtistInfo) _then;

/// Create a copy of CategoryTrackArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(_CategoryTrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
