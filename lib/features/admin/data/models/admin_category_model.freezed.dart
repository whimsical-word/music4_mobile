// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminCategoryModel {

 int get id; String get name; int? get trackCount;
/// Create a copy of AdminCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminCategoryModelCopyWith<AdminCategoryModel> get copyWith => _$AdminCategoryModelCopyWithImpl<AdminCategoryModel>(this as AdminCategoryModel, _$identity);

  /// Serializes this AdminCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminCategoryModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminCategoryModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.trackCount, _this.trackCount) || other.trackCount == _this.trackCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminCategoryModel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.trackCount);
}

@override
String toString() {
  final _this = this as AdminCategoryModel;
  return 'AdminCategoryModel(id: ${_this.id}, name: ${_this.name}, trackCount: ${_this.trackCount})';
}


}

/// @nodoc
abstract mixin class $AdminCategoryModelCopyWith<$Res>  {
  factory $AdminCategoryModelCopyWith(AdminCategoryModel value, $Res Function(AdminCategoryModel) _then) = _$AdminCategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, int? trackCount
});




}
/// @nodoc
class _$AdminCategoryModelCopyWithImpl<$Res>
    implements $AdminCategoryModelCopyWith<$Res> {
  _$AdminCategoryModelCopyWithImpl(this._self, this._then);

  final AdminCategoryModel _self;
  final $Res Function(AdminCategoryModel) _then;

/// Create a copy of AdminCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? trackCount = freezed,}) {
  return _then(AdminCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: freezed == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminCategoryModel].
extension AdminCategoryModelPatterns on AdminCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  int? trackCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.trackCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  int? trackCount)  $default,) {final _that = this;
switch (_that) {
case _AdminCategoryModel():
return $default(_that.id,_that.name,_that.trackCount);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  int? trackCount)?  $default,) {final _that = this;
switch (_that) {
case _AdminCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.trackCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminCategoryModel implements AdminCategoryModel {
  const _AdminCategoryModel({required this.id, required this.name, this.trackCount});
  factory _AdminCategoryModel.fromJson(Map<String, dynamic> json) => _$AdminCategoryModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  int? trackCount;

/// Create a copy of AdminCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminCategoryModelCopyWith<_AdminCategoryModel> get copyWith => __$AdminCategoryModelCopyWithImpl<_AdminCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,trackCount);
}

@override
String toString() {
    return 'AdminCategoryModel(id: $id, name: $name, trackCount: $trackCount)';
}


}

/// @nodoc
abstract mixin class _$AdminCategoryModelCopyWith<$Res> implements $AdminCategoryModelCopyWith<$Res> {
  factory _$AdminCategoryModelCopyWith(_AdminCategoryModel value, $Res Function(_AdminCategoryModel) _then) = __$AdminCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, int? trackCount
});




}
/// @nodoc
class __$AdminCategoryModelCopyWithImpl<$Res>
    implements _$AdminCategoryModelCopyWith<$Res> {
  __$AdminCategoryModelCopyWithImpl(this._self, this._then);

  final _AdminCategoryModel _self;
  final $Res Function(_AdminCategoryModel) _then;

/// Create a copy of AdminCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? trackCount = freezed,}) {
  return _then(_AdminCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,trackCount: freezed == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
