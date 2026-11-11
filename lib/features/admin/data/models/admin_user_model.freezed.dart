// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserModel {

 int get id; String get name; String? get img; String get email; bool? get gender; String get role; String get username; bool get isDeleted; bool get enabled;
/// Create a copy of AdminUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserModelCopyWith<AdminUserModel> get copyWith => _$AdminUserModelCopyWithImpl<AdminUserModel>(this as AdminUserModel, _$identity);

  /// Serializes this AdminUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUserModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.username, _this.username) || other.username == _this.username)&&(identical(other.isDeleted, _this.isDeleted) || other.isDeleted == _this.isDeleted)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUserModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.email,_this.gender,_this.role,_this.username,_this.isDeleted,_this.enabled);
}

@override
String toString() {
  final _this = this as AdminUserModel;
  return 'AdminUserModel(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, email: ${_this.email}, gender: ${_this.gender}, role: ${_this.role}, username: ${_this.username}, isDeleted: ${_this.isDeleted}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $AdminUserModelCopyWith<$Res>  {
  factory $AdminUserModelCopyWith(AdminUserModel value, $Res Function(AdminUserModel) _then) = _$AdminUserModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, String email, bool? gender, String role, String username, bool isDeleted, bool enabled
});




}
/// @nodoc
class _$AdminUserModelCopyWithImpl<$Res>
    implements $AdminUserModelCopyWith<$Res> {
  _$AdminUserModelCopyWithImpl(this._self, this._then);

  final AdminUserModel _self;
  final $Res Function(AdminUserModel) _then;

/// Create a copy of AdminUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? email = null,Object? gender = freezed,Object? role = null,Object? username = null,Object? isDeleted = null,Object? enabled = null,}) {
  return _then(AdminUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as bool?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserModel].
extension AdminUserModelPatterns on AdminUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String email,  bool? gender,  String role,  String username,  bool isDeleted,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.email,_that.gender,_that.role,_that.username,_that.isDeleted,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String email,  bool? gender,  String role,  String username,  bool isDeleted,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _AdminUserModel():
return $default(_that.id,_that.name,_that.img,_that.email,_that.gender,_that.role,_that.username,_that.isDeleted,_that.enabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  String email,  bool? gender,  String role,  String username,  bool isDeleted,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserModel() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.email,_that.gender,_that.role,_that.username,_that.isDeleted,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserModel implements AdminUserModel {
  const _AdminUserModel({required this.id, required this.name, this.img, required this.email, this.gender, required this.role, required this.username, this.isDeleted = false, this.enabled = true});
  factory _AdminUserModel.fromJson(Map<String, dynamic> json) => _$AdminUserModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  String email;
@override final  bool? gender;
@override final  String role;
@override final  String username;
@override@JsonKey() final  bool isDeleted;
@override@JsonKey() final  bool enabled;

/// Create a copy of AdminUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserModelCopyWith<_AdminUserModel> get copyWith => __$AdminUserModelCopyWithImpl<_AdminUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.email, email) || other.email == email)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.role, role) || other.role == role)&&(identical(other.username, username) || other.username == username)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,email,gender,role,username,isDeleted,enabled);
}

@override
String toString() {
    return 'AdminUserModel(id: $id, name: $name, img: $img, email: $email, gender: $gender, role: $role, username: $username, isDeleted: $isDeleted, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AdminUserModelCopyWith<$Res> implements $AdminUserModelCopyWith<$Res> {
  factory _$AdminUserModelCopyWith(_AdminUserModel value, $Res Function(_AdminUserModel) _then) = __$AdminUserModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, String email, bool? gender, String role, String username, bool isDeleted, bool enabled
});




}
/// @nodoc
class __$AdminUserModelCopyWithImpl<$Res>
    implements _$AdminUserModelCopyWith<$Res> {
  __$AdminUserModelCopyWithImpl(this._self, this._then);

  final _AdminUserModel _self;
  final $Res Function(_AdminUserModel) _then;

/// Create a copy of AdminUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? email = null,Object? gender = freezed,Object? role = null,Object? username = null,Object? isDeleted = null,Object? enabled = null,}) {
  return _then(_AdminUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as bool?,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
