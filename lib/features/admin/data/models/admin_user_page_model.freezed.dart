// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserPageModel {

 List<AdminUserModel> get content; int get pageNumber; int get size; int get totalElements; int get totalPages; bool get last;
/// Create a copy of AdminUserPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserPageModelCopyWith<AdminUserPageModel> get copyWith => _$AdminUserPageModelCopyWithImpl<AdminUserPageModel>(this as AdminUserPageModel, _$identity);

  /// Serializes this AdminUserPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUserPageModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserPageModel&&const DeepCollectionEquality().equals(other.content, _this.content)&&(identical(other.pageNumber, _this.pageNumber) || other.pageNumber == _this.pageNumber)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.last, _this.last) || other.last == _this.last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUserPageModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.content),_this.pageNumber,_this.size,_this.totalElements,_this.totalPages,_this.last);
}

@override
String toString() {
  final _this = this as AdminUserPageModel;
  return 'AdminUserPageModel(content: ${_this.content}, pageNumber: ${_this.pageNumber}, size: ${_this.size}, totalElements: ${_this.totalElements}, totalPages: ${_this.totalPages}, last: ${_this.last})';
}


}

/// @nodoc
abstract mixin class $AdminUserPageModelCopyWith<$Res>  {
  factory $AdminUserPageModelCopyWith(AdminUserPageModel value, $Res Function(AdminUserPageModel) _then) = _$AdminUserPageModelCopyWithImpl;
@useResult
$Res call({
 List<AdminUserModel> content, int pageNumber, int size, int totalElements, int totalPages, bool last
});




}
/// @nodoc
class _$AdminUserPageModelCopyWithImpl<$Res>
    implements $AdminUserPageModelCopyWith<$Res> {
  _$AdminUserPageModelCopyWithImpl(this._self, this._then);

  final AdminUserPageModel _self;
  final $Res Function(AdminUserPageModel) _then;

/// Create a copy of AdminUserPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? pageNumber = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(AdminUserPageModel(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<AdminUserModel>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserPageModel].
extension AdminUserPageModelPatterns on AdminUserPageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserPageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserPageModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserPageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserPageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminUserModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserPageModel() when $default != null:
return $default(_that.content,_that.pageNumber,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminUserModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)  $default,) {final _that = this;
switch (_that) {
case _AdminUserPageModel():
return $default(_that.content,_that.pageNumber,_that.size,_that.totalElements,_that.totalPages,_that.last);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminUserModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserPageModel() when $default != null:
return $default(_that.content,_that.pageNumber,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserPageModel implements AdminUserPageModel {
  const _AdminUserPageModel({ List<AdminUserModel> content = const [], this.pageNumber = 0, this.size = 20, this.totalElements = 0, this.totalPages = 0, this.last = true}): _content = content;
  factory _AdminUserPageModel.fromJson(Map<String, dynamic> json) => _$AdminUserPageModelFromJson(json);

 final  List<AdminUserModel> _content;
@override@JsonKey() List<AdminUserModel> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  int size;
@override@JsonKey() final  int totalElements;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  bool last;

/// Create a copy of AdminUserPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserPageModelCopyWith<_AdminUserPageModel> get copyWith => __$AdminUserPageModelCopyWithImpl<_AdminUserPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserPageModel&&const DeepCollectionEquality().equals(other.content, _content)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.last, last) || other.last == last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),pageNumber,size,totalElements,totalPages,last);
}

@override
String toString() {
    return 'AdminUserPageModel(content: $content, pageNumber: $pageNumber, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
}


}

/// @nodoc
abstract mixin class _$AdminUserPageModelCopyWith<$Res> implements $AdminUserPageModelCopyWith<$Res> {
  factory _$AdminUserPageModelCopyWith(_AdminUserPageModel value, $Res Function(_AdminUserPageModel) _then) = __$AdminUserPageModelCopyWithImpl;
@override @useResult
$Res call({
 List<AdminUserModel> content, int pageNumber, int size, int totalElements, int totalPages, bool last
});




}
/// @nodoc
class __$AdminUserPageModelCopyWithImpl<$Res>
    implements _$AdminUserPageModelCopyWith<$Res> {
  __$AdminUserPageModelCopyWithImpl(this._self, this._then);

  final _AdminUserPageModel _self;
  final $Res Function(_AdminUserPageModel) _then;

/// Create a copy of AdminUserPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? pageNumber = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(_AdminUserPageModel(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<AdminUserModel>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
