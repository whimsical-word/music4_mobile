// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationModel {

 int get id; int? get trackId; String? get trackName; int? get albumId; String? get albumName; String? get artistName; String get content; bool get isRead;@JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson) DateTime get createdAt;
/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationModelCopyWith<NotificationModel> get copyWith => _$NotificationModelCopyWithImpl<NotificationModel>(this as NotificationModel, _$identity);

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NotificationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.trackId, _this.trackId) || other.trackId == _this.trackId)&&(identical(other.trackName, _this.trackName) || other.trackName == _this.trackName)&&(identical(other.albumId, _this.albumId) || other.albumId == _this.albumId)&&(identical(other.albumName, _this.albumName) || other.albumName == _this.albumName)&&(identical(other.artistName, _this.artistName) || other.artistName == _this.artistName)&&(identical(other.content, _this.content) || other.content == _this.content)&&(identical(other.isRead, _this.isRead) || other.isRead == _this.isRead)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NotificationModel;
  return Object.hash(runtimeType,_this.id,_this.trackId,_this.trackName,_this.albumId,_this.albumName,_this.artistName,_this.content,_this.isRead,_this.createdAt);
}

@override
String toString() {
  final _this = this as NotificationModel;
  return 'NotificationModel(id: ${_this.id}, trackId: ${_this.trackId}, trackName: ${_this.trackName}, albumId: ${_this.albumId}, albumName: ${_this.albumName}, artistName: ${_this.artistName}, content: ${_this.content}, isRead: ${_this.isRead}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $NotificationModelCopyWith<$Res>  {
  factory $NotificationModelCopyWith(NotificationModel value, $Res Function(NotificationModel) _then) = _$NotificationModelCopyWithImpl;
@useResult
$Res call({
 int id, int? trackId, String? trackName, int? albumId, String? albumName, String? artistName, String content, bool isRead,@JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class _$NotificationModelCopyWithImpl<$Res>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._self, this._then);

  final NotificationModel _self;
  final $Res Function(NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackId = freezed,Object? trackName = freezed,Object? albumId = freezed,Object? albumName = freezed,Object? artistName = freezed,Object? content = null,Object? isRead = null,Object? createdAt = null,}) {
  return _then(NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int?,trackName: freezed == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String?,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as int?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationModel].
extension NotificationModelPatterns on NotificationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? trackId,  String? trackName,  int? albumId,  String? albumName,  String? artistName,  String content,  bool isRead, @JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.trackId,_that.trackName,_that.albumId,_that.albumName,_that.artistName,_that.content,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? trackId,  String? trackName,  int? albumId,  String? albumName,  String? artistName,  String content,  bool isRead, @JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _NotificationModel():
return $default(_that.id,_that.trackId,_that.trackName,_that.albumId,_that.albumName,_that.artistName,_that.content,_that.isRead,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? trackId,  String? trackName,  int? albumId,  String? albumName,  String? artistName,  String content,  bool isRead, @JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _NotificationModel() when $default != null:
return $default(_that.id,_that.trackId,_that.trackName,_that.albumId,_that.albumName,_that.artistName,_that.content,_that.isRead,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationModel extends NotificationModel {
  const _NotificationModel({required this.id, this.trackId, this.trackName, this.albumId, this.albumName, this.artistName, this.content = '', this.isRead = false, @JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson) required this.createdAt}): super._();
  factory _NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

@override final  int id;
@override final  int? trackId;
@override final  String? trackName;
@override final  int? albumId;
@override final  String? albumName;
@override final  String? artistName;
@override@JsonKey() final  String content;
@override@JsonKey() final  bool isRead;
@override@JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson) final  DateTime createdAt;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationModelCopyWith<_NotificationModel> get copyWith => __$NotificationModelCopyWithImpl<_NotificationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.trackName, trackName) || other.trackName == trackName)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.content, content) || other.content == content)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,trackId,trackName,albumId,albumName,artistName,content,isRead,createdAt);
}

@override
String toString() {
    return 'NotificationModel(id: $id, trackId: $trackId, trackName: $trackName, albumId: $albumId, albumName: $albumName, artistName: $artistName, content: $content, isRead: $isRead, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$NotificationModelCopyWith<$Res> implements $NotificationModelCopyWith<$Res> {
  factory _$NotificationModelCopyWith(_NotificationModel value, $Res Function(_NotificationModel) _then) = __$NotificationModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int? trackId, String? trackName, int? albumId, String? albumName, String? artistName, String content, bool isRead,@JsonKey(fromJson: parseNotificationDate, toJson: _dateToJson) DateTime createdAt
});




}
/// @nodoc
class __$NotificationModelCopyWithImpl<$Res>
    implements _$NotificationModelCopyWith<$Res> {
  __$NotificationModelCopyWithImpl(this._self, this._then);

  final _NotificationModel _self;
  final $Res Function(_NotificationModel) _then;

/// Create a copy of NotificationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = freezed,Object? trackName = freezed,Object? albumId = freezed,Object? albumName = freezed,Object? artistName = freezed,Object? content = null,Object? isRead = null,Object? createdAt = null,}) {
  return _then(_NotificationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as int?,trackName: freezed == trackName ? _self.trackName : trackName // ignore: cast_nullable_to_non_nullable
as String?,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as int?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
