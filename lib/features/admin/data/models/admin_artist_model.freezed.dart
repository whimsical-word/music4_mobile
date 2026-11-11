// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_artist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminArtistModel {

 int get id; String get name; String? get img; String? get cover; String? get email; String? get userName; int get trackTotal; int get albumTotal; bool get isDeleted; bool get enabled;
/// Create a copy of AdminArtistModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminArtistModelCopyWith<AdminArtistModel> get copyWith => _$AdminArtistModelCopyWithImpl<AdminArtistModel>(this as AdminArtistModel, _$identity);

  /// Serializes this AdminArtistModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminArtistModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminArtistModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.cover, _this.cover) || other.cover == _this.cover)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.trackTotal, _this.trackTotal) || other.trackTotal == _this.trackTotal)&&(identical(other.albumTotal, _this.albumTotal) || other.albumTotal == _this.albumTotal)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminArtistModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.cover,_this.email,_this.userName,_this.trackTotal,_this.albumTotal,_this.isDeleted,_this.enabled);
}

@override
String toString() {
  final _this = this as AdminArtistModel;
  return 'AdminArtistModel(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, cover: ${_this.cover}, email: ${_this.email}, userName: ${_this.userName}, trackTotal: ${_this.trackTotal}, albumTotal: ${_this.albumTotal}, isDeleted: ${_this.isDeleted}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $AdminArtistModelCopyWith<$Res>  {
  factory $AdminArtistModelCopyWith(AdminArtistModel value, $Res Function(AdminArtistModel) _then) = _$AdminArtistModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, String? cover, String? email, String? userName, int trackTotal, int albumTotal, bool isDeleted, bool enabled
});




}
/// @nodoc
class _$AdminArtistModelCopyWithImpl<$Res>
    implements $AdminArtistModelCopyWith<$Res> {
  _$AdminArtistModelCopyWithImpl(this._self, this._then);

  final AdminArtistModel _self;
  final $Res Function(AdminArtistModel) _then;

/// Create a copy of AdminArtistModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? cover = freezed,Object? email = freezed,Object? userName = freezed,Object? trackTotal = null,Object? albumTotal = null,Object? isDeleted = null,Object? enabled = null,}) {
  return _then(AdminArtistModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: null == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int,albumTotal: null == albumTotal ? _self.albumTotal : albumTotal // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminArtistModel].
extension AdminArtistModelPatterns on AdminArtistModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminArtistModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminArtistModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminArtistModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminArtistModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminArtistModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminArtistModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? cover,  String? email,  String? userName,  int trackTotal,  int albumTotal,  bool isDeleted,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminArtistModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.cover,_that.email,_that.userName,_that.trackTotal,_that.albumTotal,_that.isDeleted,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? cover,  String? email,  String? userName,  int trackTotal,  int albumTotal,  bool isDeleted,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AdminArtistModel():
return $default(_that.id,_that.name,_that.img,_that.cover,_that.email,_that.userName,_that.trackTotal,_that.albumTotal,_that.isDeleted,_that.enabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  String? cover,  String? email,  String? userName,  int trackTotal,  int albumTotal,  bool isDeleted,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AdminArtistModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.cover,_that.email,_that.userName,_that.trackTotal,_that.albumTotal,_that.isDeleted,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminArtistModel implements AdminArtistModel {
  const _AdminArtistModel({required this.id, required this.name, this.img, this.cover, this.email, this.userName, this.trackTotal = 0, this.albumTotal = 0, this.isDeleted = false, this.enabled = true});
  factory _AdminArtistModel.fromJson(Map<String, dynamic> json) => _$AdminArtistModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  String? cover;
@override final  String? email;
@override final  String? userName;
@override@JsonKey() final  int trackTotal;
@override@JsonKey() final  int albumTotal;
@override@JsonKey() final  bool isDeleted;
@override@JsonKey() final  bool enabled;

/// Create a copy of AdminArtistModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminArtistModelCopyWith<_AdminArtistModel> get copyWith => __$AdminArtistModelCopyWithImpl<_AdminArtistModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminArtistModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminArtistModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.email, email) || other.email == email)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.trackTotal, trackTotal) || other.trackTotal == trackTotal)&&(identical(other.albumTotal, albumTotal) || other.albumTotal == albumTotal)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,cover,email,userName,trackTotal,albumTotal,isDeleted,enabled);
}

@override
String toString() {
    return 'AdminArtistModel(id: $id, name: $name, img: $img, cover: $cover, email: $email, userName: $userName, trackTotal: $trackTotal, albumTotal: $albumTotal, isDeleted: $isDeleted, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AdminArtistModelCopyWith<$Res> implements $AdminArtistModelCopyWith<$Res> {
  factory _$AdminArtistModelCopyWith(_AdminArtistModel value, $Res Function(_AdminArtistModel) _then) = __$AdminArtistModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, String? cover, String? email, String? userName, int trackTotal, int albumTotal, bool isDeleted, bool enabled
});




}
/// @nodoc
class __$AdminArtistModelCopyWithImpl<$Res>
    implements _$AdminArtistModelCopyWith<$Res> {
  __$AdminArtistModelCopyWithImpl(this._self, this._then);

  final _AdminArtistModel _self;
  final $Res Function(_AdminArtistModel) _then;

/// Create a copy of AdminArtistModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? cover = freezed,Object? email = freezed,Object? userName = freezed,Object? trackTotal = null,Object? albumTotal = null,Object? isDeleted = null,Object? enabled = null,}) {
  return _then(_AdminArtistModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,trackTotal: null == trackTotal ? _self.trackTotal : trackTotal // ignore: cast_nullable_to_non_nullable
as int,albumTotal: null == albumTotal ? _self.albumTotal : albumTotal // ignore: cast_nullable_to_non_nullable
as int,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
