// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_track_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryTrackResponse {

 int get id; String get name; String get albumName; String? get img; int get duration; String? get filePath; String? get previewPath; int? get viewCount; String? get uploadDate; int get playbackPosition; List<TrackArtistInfo> get artists;
/// Create a copy of HistoryTrackResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryTrackResponseCopyWith<HistoryTrackResponse> get copyWith => _$HistoryTrackResponseCopyWithImpl<HistoryTrackResponse>(this as HistoryTrackResponse, _$identity);

  /// Serializes this HistoryTrackResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistoryTrackResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryTrackResponse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.albumName, _this.albumName) || other.albumName == _this.albumName)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.filePath, _this.filePath) || other.filePath == _this.filePath)&&(identical(other.previewPath, _this.previewPath) || other.previewPath == _this.previewPath)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&(identical(other.uploadDate, _this.uploadDate) || other.uploadDate == _this.uploadDate)&&(identical(other.playbackPosition, _this.playbackPosition) || other.playbackPosition == _this.playbackPosition)&&const DeepCollectionEquality().equals(other.artists, _this.artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistoryTrackResponse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.albumName,_this.img,_this.duration,_this.filePath,_this.previewPath,_this.viewCount,_this.uploadDate,_this.playbackPosition,const DeepCollectionEquality().hash(_this.artists));
}

@override
String toString() {
  final _this = this as HistoryTrackResponse;
  return 'HistoryTrackResponse(id: ${_this.id}, name: ${_this.name}, albumName: ${_this.albumName}, img: ${_this.img}, duration: ${_this.duration}, filePath: ${_this.filePath}, previewPath: ${_this.previewPath}, viewCount: ${_this.viewCount}, uploadDate: ${_this.uploadDate}, playbackPosition: ${_this.playbackPosition}, artists: ${_this.artists})';
}


}

/// @nodoc
abstract mixin class $HistoryTrackResponseCopyWith<$Res>  {
  factory $HistoryTrackResponseCopyWith(HistoryTrackResponse value, $Res Function(HistoryTrackResponse) _then) = _$HistoryTrackResponseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String albumName, String? img, int duration, String? filePath, String? previewPath, int? viewCount, String? uploadDate, int playbackPosition, List<TrackArtistInfo> artists
});




}
/// @nodoc
class _$HistoryTrackResponseCopyWithImpl<$Res>
    implements $HistoryTrackResponseCopyWith<$Res> {
  _$HistoryTrackResponseCopyWithImpl(this._self, this._then);

  final HistoryTrackResponse _self;
  final $Res Function(HistoryTrackResponse) _then;

/// Create a copy of HistoryTrackResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? albumName = null,Object? img = freezed,Object? duration = null,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = freezed,Object? uploadDate = freezed,Object? playbackPosition = null,Object? artists = null,}) {
  return _then(HistoryTrackResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: null == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,playbackPosition: null == playbackPosition ? _self.playbackPosition : playbackPosition // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryTrackResponse].
extension HistoryTrackResponsePatterns on HistoryTrackResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryTrackResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryTrackResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryTrackResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryTrackResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryTrackResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryTrackResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int playbackPosition,  List<TrackArtistInfo> artists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryTrackResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int playbackPosition,  List<TrackArtistInfo> artists)  $default,) {final _that = this;
switch (_that) {
case _HistoryTrackResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String albumName,  String? img,  int duration,  String? filePath,  String? previewPath,  int? viewCount,  String? uploadDate,  int playbackPosition,  List<TrackArtistInfo> artists)?  $default,) {final _that = this;
switch (_that) {
case _HistoryTrackResponse() when $default != null:
return $default(_that.id,_that.name,_that.albumName,_that.img,_that.duration,_that.filePath,_that.previewPath,_that.viewCount,_that.uploadDate,_that.playbackPosition,_that.artists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryTrackResponse implements HistoryTrackResponse {
  const _HistoryTrackResponse({required this.id, required this.name, required this.albumName, this.img, required this.duration, this.filePath, this.previewPath, this.viewCount, this.uploadDate, required this.playbackPosition,  List<TrackArtistInfo> artists = const []}): _artists = artists;
  factory _HistoryTrackResponse.fromJson(Map<String, dynamic> json) => _$HistoryTrackResponseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String albumName;
@override final  String? img;
@override final  int duration;
@override final  String? filePath;
@override final  String? previewPath;
@override final  int? viewCount;
@override final  String? uploadDate;
@override final  int playbackPosition;
 final  List<TrackArtistInfo> _artists;
@override@JsonKey() List<TrackArtistInfo> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}


/// Create a copy of HistoryTrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryTrackResponseCopyWith<_HistoryTrackResponse> get copyWith => __$HistoryTrackResponseCopyWithImpl<_HistoryTrackResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryTrackResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryTrackResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.img, img) || other.img == img)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.uploadDate, uploadDate) || other.uploadDate == uploadDate)&&(identical(other.playbackPosition, playbackPosition) || other.playbackPosition == playbackPosition)&&const DeepCollectionEquality().equals(other.artists, _artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,albumName,img,duration,filePath,previewPath,viewCount,uploadDate,playbackPosition,const DeepCollectionEquality().hash(_artists));
}

@override
String toString() {
    return 'HistoryTrackResponse(id: $id, name: $name, albumName: $albumName, img: $img, duration: $duration, filePath: $filePath, previewPath: $previewPath, viewCount: $viewCount, uploadDate: $uploadDate, playbackPosition: $playbackPosition, artists: $artists)';
}


}

/// @nodoc
abstract mixin class _$HistoryTrackResponseCopyWith<$Res> implements $HistoryTrackResponseCopyWith<$Res> {
  factory _$HistoryTrackResponseCopyWith(_HistoryTrackResponse value, $Res Function(_HistoryTrackResponse) _then) = __$HistoryTrackResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String albumName, String? img, int duration, String? filePath, String? previewPath, int? viewCount, String? uploadDate, int playbackPosition, List<TrackArtistInfo> artists
});




}
/// @nodoc
class __$HistoryTrackResponseCopyWithImpl<$Res>
    implements _$HistoryTrackResponseCopyWith<$Res> {
  __$HistoryTrackResponseCopyWithImpl(this._self, this._then);

  final _HistoryTrackResponse _self;
  final $Res Function(_HistoryTrackResponse) _then;

/// Create a copy of HistoryTrackResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? albumName = null,Object? img = freezed,Object? duration = null,Object? filePath = freezed,Object? previewPath = freezed,Object? viewCount = freezed,Object? uploadDate = freezed,Object? playbackPosition = null,Object? artists = null,}) {
  return _then(_HistoryTrackResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumName: null == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: freezed == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int?,uploadDate: freezed == uploadDate ? _self.uploadDate : uploadDate // ignore: cast_nullable_to_non_nullable
as String?,playbackPosition: null == playbackPosition ? _self.playbackPosition : playbackPosition // ignore: cast_nullable_to_non_nullable
as int,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,
  ));
}


}


/// @nodoc
mixin _$TrackArtistInfo {

 int get id; String get name; String get role;
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
 int id, String name, String role
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(TrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String role)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String role)  $default,) {final _that = this;
switch (_that) {
case _TrackArtistInfo():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String role)?  $default,) {final _that = this;
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
  const _TrackArtistInfo({required this.id, required this.name, required this.role});
  factory _TrackArtistInfo.fromJson(Map<String, dynamic> json) => _$TrackArtistInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String role;

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
 int id, String name, String role
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,}) {
  return _then(_TrackArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
