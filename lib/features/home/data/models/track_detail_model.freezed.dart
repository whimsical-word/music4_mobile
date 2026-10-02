// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackDetailModel {

 int get id; String get name; String? get img; int? get duration; String? get filePath; String? get previewPath; String? get uploadDate; int get viewCount; AlbumInfo? get album; List<TrackArtistInfo> get artists; List<TrackCategoryInfo> get categories;
/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackDetailModelCopyWith<TrackDetailModel> get copyWith => _$TrackDetailModelCopyWithImpl<TrackDetailModel>(this as TrackDetailModel, _$identity);

  /// Serializes this TrackDetailModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackDetailModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackDetailModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.filePath, _this.filePath) || other.filePath == _this.filePath)&&(identical(other.previewPath, _this.previewPath) || other.previewPath == _this.previewPath)&&(identical(other.uploadDate, _this.uploadDate) || other.uploadDate == _this.uploadDate)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&(identical(other.album, _this.album) || other.album == _this.album)&&const DeepCollectionEquality().equals(other.artists, _this.artists)&&const DeepCollectionEquality().equals(other.categories, _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackDetailModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.duration,_this.filePath,_this.previewPath,_this.uploadDate,_this.viewCount,_this.album,const DeepCollectionEquality().hash(_this.artists),const DeepCollectionEquality().hash(_this.categories));
}

@override
String toString() {
  final _this = this as TrackDetailModel;
  return 'TrackDetailModel(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, duration: ${_this.duration}, filePath: ${_this.filePath}, previewPath: ${_this.previewPath}, uploadDate: ${_this.uploadDate}, viewCount: ${_this.viewCount}, album: ${_this.album}, artists: ${_this.artists}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $TrackDetailModelCopyWith<$Res>  {
  factory $TrackDetailModelCopyWith(TrackDetailModel value, $Res Function(TrackDetailModel) _then) = _$TrackDetailModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, int? duration, String? filePath, String? previewPath, String? uploadDate, int viewCount, AlbumInfo? album, List<TrackArtistInfo> artists, List<TrackCategoryInfo> categories
});


$AlbumInfoCopyWith<$Res>? get album;

}
/// @nodoc
class _$TrackDetailModelCopyWithImpl<$Res>
    implements $TrackDetailModelCopyWith<$Res> {
  _$TrackDetailModelCopyWithImpl(this._self, this._then);

  final TrackDetailModel _self;
  final $Res Function(TrackDetailModel) _then;

/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? duration = freezed,Object? filePath = freezed,Object? previewPath = freezed,Object? uploadDate = freezed,Object? viewCount = null,Object? album = freezed,Object? artists = null,Object? categories = null,}) {
  return _then(TrackDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as AlbumInfo?,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<TrackCategoryInfo>,
  ));
}
/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumInfoCopyWith<$Res>? get album {
    if (_self.album == null) {
    return null;
  }

  return $AlbumInfoCopyWith<$Res>(_self.album!, (value) {
    return _then(_self.copyWith(album: value));
  });
}
}


/// Adds pattern-matching-related methods to [TrackDetailModel].
extension TrackDetailModelPatterns on TrackDetailModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackDetailModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackDetailModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackDetailModel value)  $default,){
final _that = this;
switch (_that) {
case _TrackDetailModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackDetailModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrackDetailModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  int? duration,  String? filePath,  String? previewPath,  String? uploadDate,  int viewCount,  AlbumInfo? album,  List<TrackArtistInfo> artists,  List<TrackCategoryInfo> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.uploadDate,_that.viewCount,_that.album,_that.artists,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  int? duration,  String? filePath,  String? previewPath,  String? uploadDate,  int viewCount,  AlbumInfo? album,  List<TrackArtistInfo> artists,  List<TrackCategoryInfo> categories)  $default,) {final _that = this;
switch (_that) {
case _TrackDetailModel():
return $default(_that.id,_that.name,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.uploadDate,_that.viewCount,_that.album,_that.artists,_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  int? duration,  String? filePath,  String? previewPath,  String? uploadDate,  int viewCount,  AlbumInfo? album,  List<TrackArtistInfo> artists,  List<TrackCategoryInfo> categories)?  $default,) {final _that = this;
switch (_that) {
case _TrackDetailModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.uploadDate,_that.viewCount,_that.album,_that.artists,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackDetailModel implements TrackDetailModel {
  const _TrackDetailModel({required this.id, required this.name, this.img, this.duration, this.filePath, this.previewPath, this.uploadDate, this.viewCount = 0, this.album,  List<TrackArtistInfo> artists = const [],  List<TrackCategoryInfo> categories = const []}): _artists = artists,_categories = categories;
  factory _TrackDetailModel.fromJson(Map<String, dynamic> json) => _$TrackDetailModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  int? duration;
@override final  String? filePath;
@override final  String? previewPath;
@override final  String? uploadDate;
@override@JsonKey() final  int viewCount;
@override final  AlbumInfo? album;
 final  List<TrackArtistInfo> _artists;
@override@JsonKey() List<TrackArtistInfo> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}

 final  List<TrackCategoryInfo> _categories;
@override@JsonKey() List<TrackCategoryInfo> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackDetailModelCopyWith<_TrackDetailModel> get copyWith => __$TrackDetailModelCopyWithImpl<_TrackDetailModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackDetailModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackDetailModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.album, album) || other.album == album)&&const DeepCollectionEquality().equals(other.artists, _artists)&&const DeepCollectionEquality().equals(other.categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,duration,filePath,previewPath,uploadDate,viewCount,album,const DeepCollectionEquality().hash(_artists),const DeepCollectionEquality().hash(_categories));
}

@override
String toString() {
    return 'TrackDetailModel(id: $id, name: $name, img: $img, duration: $duration, filePath: $filePath, previewPath: $previewPath, uploadDate: $uploadDate, viewCount: $viewCount, album: $album, artists: $artists, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$TrackDetailModelCopyWith<$Res> implements $TrackDetailModelCopyWith<$Res> {
  factory _$TrackDetailModelCopyWith(_TrackDetailModel value, $Res Function(_TrackDetailModel) _then) = __$TrackDetailModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, int? duration, String? filePath, String? previewPath, String? uploadDate, int viewCount, AlbumInfo? album, List<TrackArtistInfo> artists, List<TrackCategoryInfo> categories
});


@override $AlbumInfoCopyWith<$Res>? get album;

}
/// @nodoc
class __$TrackDetailModelCopyWithImpl<$Res>
    implements _$TrackDetailModelCopyWith<$Res> {
  __$TrackDetailModelCopyWithImpl(this._self, this._then);

  final _TrackDetailModel _self;
  final $Res Function(_TrackDetailModel) _then;

/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? duration = freezed,Object? filePath = freezed,Object? previewPath = freezed,Object? uploadDate = freezed,Object? viewCount = null,Object? album = freezed,Object? artists = null,Object? categories = null,}) {
  return _then(_TrackDetailModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as AlbumInfo?,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<TrackCategoryInfo>,
  ));
}

/// Create a copy of TrackDetailModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumInfoCopyWith<$Res>? get album {
    if (_self.album == null) {
    return null;
  }

  return $AlbumInfoCopyWith<$Res>(_self.album!, (value) {
    return _then(_self.copyWith(album: value));
  });
}
}


/// @nodoc
mixin _$AlbumInfo {

 int get id;@JsonKey(name: 'name') String get title;@JsonKey(name: 'img') String? get coverUrl; String? get uploadDate; int? get trackTotal; int? get artistId;
/// Create a copy of AlbumInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumInfoCopyWith<AlbumInfo> get copyWith => _$AlbumInfoCopyWithImpl<AlbumInfo>(this as AlbumInfo, _$identity);

  /// Serializes this AlbumInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AlbumInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl)&&(identical(other.uploadDate, _this.uploadDate) || other.uploadDate == _this.uploadDate)&&(identical(other.trackTotal, _this.trackTotal) || other.trackTotal == _this.trackTotal)&&(identical(other.artistId, _this.artistId) || other.artistId == _this.artistId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AlbumInfo;
  return Object.hash(runtimeType,_this.id,_this.title,_this.coverUrl,_this.uploadDate,_this.trackTotal,_this.artistId);
}

@override
String toString() {
  final _this = this as AlbumInfo;
  return 'AlbumInfo(id: ${_this.id}, title: ${_this.title}, coverUrl: ${_this.coverUrl}, uploadDate: ${_this.uploadDate}, trackTotal: ${_this.trackTotal}, artistId: ${_this.artistId})';
}


}

/// @nodoc
abstract mixin class $AlbumInfoCopyWith<$Res>  {
  factory $AlbumInfoCopyWith(AlbumInfo value, $Res Function(AlbumInfo) _then) = _$AlbumInfoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'name') String title,@JsonKey(name: 'img') String? coverUrl, String? uploadDate, int? trackTotal, int? artistId
});




}
/// @nodoc
class _$AlbumInfoCopyWithImpl<$Res>
    implements $AlbumInfoCopyWith<$Res> {
  _$AlbumInfoCopyWithImpl(this._self, this._then);

  final AlbumInfo _self;
  final $Res Function(AlbumInfo) _then;

/// Create a copy of AlbumInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? coverUrl = freezed,Object? uploadDate = freezed,Object? trackTotal = freezed,Object? artistId = freezed,}) {
  return _then(AlbumInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: freezed == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AlbumInfo].
extension AlbumInfoPatterns on AlbumInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumInfo value)  $default,){
final _that = this;
switch (_that) {
case _AlbumInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'name')  String title, @JsonKey(name: 'img')  String? coverUrl,  String? uploadDate,  int? trackTotal,  int? artistId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlbumInfo() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.uploadDate,_that.trackTotal,_that.artistId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'name')  String title, @JsonKey(name: 'img')  String? coverUrl,  String? uploadDate,  int? trackTotal,  int? artistId)  $default,) {final _that = this;
switch (_that) {
case _AlbumInfo():
return $default(_that.id,_that.title,_that.coverUrl,_that.uploadDate,_that.trackTotal,_that.artistId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'name')  String title, @JsonKey(name: 'img')  String? coverUrl,  String? uploadDate,  int? trackTotal,  int? artistId)?  $default,) {final _that = this;
switch (_that) {
case _AlbumInfo() when $default != null:
return $default(_that.id,_that.title,_that.coverUrl,_that.uploadDate,_that.trackTotal,_that.artistId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AlbumInfo implements AlbumInfo {
  const _AlbumInfo({required this.id, @JsonKey(name: 'name') required this.title, @JsonKey(name: 'img') this.coverUrl, this.uploadDate, this.trackTotal, this.artistId});
  factory _AlbumInfo.fromJson(Map<String, dynamic> json) => _$AlbumInfoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'name') final  String title;
@override@JsonKey(name: 'img') final  String? coverUrl;
@override final  String? uploadDate;
@override final  int? trackTotal;
@override final  int? artistId;

/// Create a copy of AlbumInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumInfoCopyWith<_AlbumInfo> get copyWith => __$AlbumInfoCopyWithImpl<_AlbumInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.trackTotal, trackTotal) || other.trackTotal == trackTotal)&&(identical(other.artistId, artistId) || other.artistId == artistId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,coverUrl,uploadDate,trackTotal,artistId);
}

@override
String toString() {
    return 'AlbumInfo(id: $id, title: $title, coverUrl: $coverUrl, uploadDate: $uploadDate, trackTotal: $trackTotal, artistId: $artistId)';
}


}

/// @nodoc
abstract mixin class _$AlbumInfoCopyWith<$Res> implements $AlbumInfoCopyWith<$Res> {
  factory _$AlbumInfoCopyWith(_AlbumInfo value, $Res Function(_AlbumInfo) _then) = __$AlbumInfoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'name') String title,@JsonKey(name: 'img') String? coverUrl, String? uploadDate, int? trackTotal, int? artistId
});




}
/// @nodoc
class __$AlbumInfoCopyWithImpl<$Res>
    implements _$AlbumInfoCopyWith<$Res> {
  __$AlbumInfoCopyWithImpl(this._self, this._then);

  final _AlbumInfo _self;
  final $Res Function(_AlbumInfo) _then;

/// Create a copy of AlbumInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? coverUrl = freezed,Object? uploadDate = freezed,Object? trackTotal = freezed,Object? artistId = freezed,}) {
  return _then(_AlbumInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: freezed == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TrackCategoryInfo {

 int get id; String get name;
/// Create a copy of TrackCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCategoryInfoCopyWith<TrackCategoryInfo> get copyWith => _$TrackCategoryInfoCopyWithImpl<TrackCategoryInfo>(this as TrackCategoryInfo, _$identity);

  /// Serializes this TrackCategoryInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackCategoryInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackCategoryInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackCategoryInfo;
  return Object.hash(runtimeType,_this.id,_this.name);
}

@override
String toString() {
  final _this = this as TrackCategoryInfo;
  return 'TrackCategoryInfo(id: ${_this.id}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $TrackCategoryInfoCopyWith<$Res>  {
  factory $TrackCategoryInfoCopyWith(TrackCategoryInfo value, $Res Function(TrackCategoryInfo) _then) = _$TrackCategoryInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class _$TrackCategoryInfoCopyWithImpl<$Res>
    implements $TrackCategoryInfoCopyWith<$Res> {
  _$TrackCategoryInfoCopyWithImpl(this._self, this._then);

  final TrackCategoryInfo _self;
  final $Res Function(TrackCategoryInfo) _then;

/// Create a copy of TrackCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(TrackCategoryInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackCategoryInfo].
extension TrackCategoryInfoPatterns on TrackCategoryInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackCategoryInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackCategoryInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackCategoryInfo value)  $default,){
final _that = this;
switch (_that) {
case _TrackCategoryInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackCategoryInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TrackCategoryInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackCategoryInfo() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name)  $default,) {final _that = this;
switch (_that) {
case _TrackCategoryInfo():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _TrackCategoryInfo() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackCategoryInfo implements TrackCategoryInfo {
  const _TrackCategoryInfo({required this.id, required this.name});
  factory _TrackCategoryInfo.fromJson(Map<String, dynamic> json) => _$TrackCategoryInfoFromJson(json);

@override final  int id;
@override final  String name;

/// Create a copy of TrackCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCategoryInfoCopyWith<_TrackCategoryInfo> get copyWith => __$TrackCategoryInfoCopyWithImpl<_TrackCategoryInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackCategoryInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackCategoryInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name);
}

@override
String toString() {
    return 'TrackCategoryInfo(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$TrackCategoryInfoCopyWith<$Res> implements $TrackCategoryInfoCopyWith<$Res> {
  factory _$TrackCategoryInfoCopyWith(_TrackCategoryInfo value, $Res Function(_TrackCategoryInfo) _then) = __$TrackCategoryInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name
});




}
/// @nodoc
class __$TrackCategoryInfoCopyWithImpl<$Res>
    implements _$TrackCategoryInfoCopyWith<$Res> {
  __$TrackCategoryInfoCopyWithImpl(this._self, this._then);

  final _TrackCategoryInfo _self;
  final $Res Function(_TrackCategoryInfo) _then;

/// Create a copy of TrackCategoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_TrackCategoryInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
