// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_suggest_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrackSuggestModel {

 int get id; String get name; String? get img; int? get duration; String? get previewPath; int get viewCount; double? get matchScore; List<TrackArtistInfo> get artists;
/// Create a copy of TrackSuggestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackSuggestModelCopyWith<TrackSuggestModel> get copyWith => _$TrackSuggestModelCopyWithImpl<TrackSuggestModel>(this as TrackSuggestModel, _$identity);

  /// Serializes this TrackSuggestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TrackSuggestModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackSuggestModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.previewPath, _this.previewPath) || other.previewPath == _this.previewPath)&&(identical(other.viewCount, _this.viewCount) || other.viewCount == _this.viewCount)&&(identical(other.matchScore, _this.matchScore) || other.matchScore == _this.matchScore)&&const DeepCollectionEquality().equals(other.artists, _this.artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TrackSuggestModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.duration,_this.previewPath,_this.viewCount,_this.matchScore,const DeepCollectionEquality().hash(_this.artists));
}

@override
String toString() {
  final _this = this as TrackSuggestModel;
  return 'TrackSuggestModel(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, duration: ${_this.duration}, previewPath: ${_this.previewPath}, viewCount: ${_this.viewCount}, matchScore: ${_this.matchScore}, artists: ${_this.artists})';
}


}

/// @nodoc
abstract mixin class $TrackSuggestModelCopyWith<$Res>  {
  factory $TrackSuggestModelCopyWith(TrackSuggestModel value, $Res Function(TrackSuggestModel) _then) = _$TrackSuggestModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, int? duration, String? previewPath, int viewCount, double? matchScore, List<TrackArtistInfo> artists
});




}
/// @nodoc
class _$TrackSuggestModelCopyWithImpl<$Res>
    implements $TrackSuggestModelCopyWith<$Res> {
  _$TrackSuggestModelCopyWithImpl(this._self, this._then);

  final TrackSuggestModel _self;
  final $Res Function(TrackSuggestModel) _then;

/// Create a copy of TrackSuggestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? duration = freezed,Object? previewPath = freezed,Object? viewCount = null,Object? matchScore = freezed,Object? artists = null,}) {
  return _then(TrackSuggestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,matchScore: freezed == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as double?,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackSuggestModel].
extension TrackSuggestModelPatterns on TrackSuggestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackSuggestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackSuggestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackSuggestModel value)  $default,){
final _that = this;
switch (_that) {
case _TrackSuggestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackSuggestModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrackSuggestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  int? duration,  String? previewPath,  int viewCount,  double? matchScore,  List<TrackArtistInfo> artists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackSuggestModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.duration,_that.previewPath,_that.viewCount,_that.matchScore,_that.artists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  int? duration,  String? previewPath,  int viewCount,  double? matchScore,  List<TrackArtistInfo> artists)  $default,) {final _that = this;
switch (_that) {
case _TrackSuggestModel():
return $default(_that.id,_that.name,_that.img,_that.duration,_that.previewPath,_that.viewCount,_that.matchScore,_that.artists);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  int? duration,  String? previewPath,  int viewCount,  double? matchScore,  List<TrackArtistInfo> artists)?  $default,) {final _that = this;
switch (_that) {
case _TrackSuggestModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.duration,_that.previewPath,_that.viewCount,_that.matchScore,_that.artists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrackSuggestModel implements TrackSuggestModel {
  const _TrackSuggestModel({required this.id, required this.name, this.img, this.duration, this.previewPath, this.viewCount = 0, this.matchScore,  List<TrackArtistInfo> artists = const []}): _artists = artists;
  factory _TrackSuggestModel.fromJson(Map<String, dynamic> json) => _$TrackSuggestModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  int? duration;
@override final  String? previewPath;
@override@JsonKey() final  int viewCount;
@override final  double? matchScore;
 final  List<TrackArtistInfo> _artists;
@override@JsonKey() List<TrackArtistInfo> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}


/// Create a copy of TrackSuggestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackSuggestModelCopyWith<_TrackSuggestModel> get copyWith => __$TrackSuggestModelCopyWithImpl<_TrackSuggestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackSuggestModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackSuggestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.previewPath, previewPath) || other.previewPath == previewPath)&&(identical(other.viewCount, viewCount) || other.viewCount == viewCount)&&(identical(other.matchScore, matchScore) || other.matchScore == matchScore)&&const DeepCollectionEquality().equals(other.artists, _artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,duration,previewPath,viewCount,matchScore,const DeepCollectionEquality().hash(_artists));
}

@override
String toString() {
    return 'TrackSuggestModel(id: $id, name: $name, img: $img, duration: $duration, previewPath: $previewPath, viewCount: $viewCount, matchScore: $matchScore, artists: $artists)';
}


}

/// @nodoc
abstract mixin class _$TrackSuggestModelCopyWith<$Res> implements $TrackSuggestModelCopyWith<$Res> {
  factory _$TrackSuggestModelCopyWith(_TrackSuggestModel value, $Res Function(_TrackSuggestModel) _then) = __$TrackSuggestModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, int? duration, String? previewPath, int viewCount, double? matchScore, List<TrackArtistInfo> artists
});




}
/// @nodoc
class __$TrackSuggestModelCopyWithImpl<$Res>
    implements _$TrackSuggestModelCopyWith<$Res> {
  __$TrackSuggestModelCopyWithImpl(this._self, this._then);

  final _TrackSuggestModel _self;
  final $Res Function(_TrackSuggestModel) _then;

/// Create a copy of TrackSuggestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? duration = freezed,Object? previewPath = freezed,Object? viewCount = null,Object? matchScore = freezed,Object? artists = null,}) {
  return _then(_TrackSuggestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,previewPath: freezed == previewPath ? _self.previewPath : previewPath // ignore: cast_nullable_to_non_nullable
as String?,viewCount: null == viewCount ? _self.viewCount : viewCount // ignore: cast_nullable_to_non_nullable
as int,matchScore: freezed == matchScore ? _self.matchScore : matchScore // ignore: cast_nullable_to_non_nullable
as double?,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<TrackArtistInfo>,
  ));
}


}

// dart format on
