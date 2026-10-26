// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_artist_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminArtistPageModel {

 List<AdminArtistModel> get content; int get pageNumber; int get size; int get totalElements; int get totalPages; bool get last;
/// Create a copy of AdminArtistPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminArtistPageModelCopyWith<AdminArtistPageModel> get copyWith => _$AdminArtistPageModelCopyWithImpl<AdminArtistPageModel>(this as AdminArtistPageModel, _$identity);

  /// Serializes this AdminArtistPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminArtistPageModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminArtistPageModel&&const DeepCollectionEquality().equals(other.content, _this.content)&&(identical(other.pageNumber, _this.pageNumber) || other.pageNumber == _this.pageNumber)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.last, _this.last) || other.last == _this.last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminArtistPageModel;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.content),_this.pageNumber,_this.size,_this.totalElements,_this.totalPages,_this.last);
}

@override
String toString() {
  final _this = this as AdminArtistPageModel;
  return 'AdminArtistPageModel(content: ${_this.content}, pageNumber: ${_this.pageNumber}, size: ${_this.size}, totalElements: ${_this.totalElements}, totalPages: ${_this.totalPages}, last: ${_this.last})';
}


}

/// @nodoc
abstract mixin class $AdminArtistPageModelCopyWith<$Res>  {
  factory $AdminArtistPageModelCopyWith(AdminArtistPageModel value, $Res Function(AdminArtistPageModel) _then) = _$AdminArtistPageModelCopyWithImpl;
@useResult
$Res call({
 List<AdminArtistModel> content, int pageNumber, int size, int totalElements, int totalPages, bool last
});




}
/// @nodoc
class _$AdminArtistPageModelCopyWithImpl<$Res>
    implements $AdminArtistPageModelCopyWith<$Res> {
  _$AdminArtistPageModelCopyWithImpl(this._self, this._then);

  final AdminArtistPageModel _self;
  final $Res Function(AdminArtistPageModel) _then;

/// Create a copy of AdminArtistPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? pageNumber = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(AdminArtistPageModel(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<AdminArtistModel>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminArtistPageModel].
extension AdminArtistPageModelPatterns on AdminArtistPageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminArtistPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminArtistPageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminArtistPageModel value)  $default,){
final _that = this;
switch (_that) {
case _AdminArtistPageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminArtistPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _AdminArtistPageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminArtistModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminArtistPageModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminArtistModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)  $default,) {final _that = this;
switch (_that) {
case _AdminArtistPageModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminArtistModel> content,  int pageNumber,  int size,  int totalElements,  int totalPages,  bool last)?  $default,) {final _that = this;
switch (_that) {
case _AdminArtistPageModel() when $default != null:
return $default(_that.content,_that.pageNumber,_that.size,_that.totalElements,_that.totalPages,_that.last);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminArtistPageModel implements AdminArtistPageModel {
  const _AdminArtistPageModel({ List<AdminArtistModel> content = const [], this.pageNumber = 0, this.size = 20, this.totalElements = 0, this.totalPages = 0, this.last = true}): _content = content;
  factory _AdminArtistPageModel.fromJson(Map<String, dynamic> json) => _$AdminArtistPageModelFromJson(json);

 final  List<AdminArtistModel> _content;
@override@JsonKey() List<AdminArtistModel> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int pageNumber;
@override@JsonKey() final  int size;
@override@JsonKey() final  int totalElements;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  bool last;

/// Create a copy of AdminArtistPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminArtistPageModelCopyWith<_AdminArtistPageModel> get copyWith => __$AdminArtistPageModelCopyWithImpl<_AdminArtistPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminArtistPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminArtistPageModel&&const DeepCollectionEquality().equals(other.content, _content)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.size, size) || other.size == size)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.last, last) || other.last == last));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),pageNumber,size,totalElements,totalPages,last);
}

@override
String toString() {
    return 'AdminArtistPageModel(content: $content, pageNumber: $pageNumber, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
}


}

/// @nodoc
abstract mixin class _$AdminArtistPageModelCopyWith<$Res> implements $AdminArtistPageModelCopyWith<$Res> {
  factory _$AdminArtistPageModelCopyWith(_AdminArtistPageModel value, $Res Function(_AdminArtistPageModel) _then) = __$AdminArtistPageModelCopyWithImpl;
@override @useResult
$Res call({
 List<AdminArtistModel> content, int pageNumber, int size, int totalElements, int totalPages, bool last
});




}
/// @nodoc
class __$AdminArtistPageModelCopyWithImpl<$Res>
    implements _$AdminArtistPageModelCopyWith<$Res> {
  __$AdminArtistPageModelCopyWithImpl(this._self, this._then);

  final _AdminArtistPageModel _self;
  final $Res Function(_AdminArtistPageModel) _then;

/// Create a copy of AdminArtistPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? pageNumber = null,Object? size = null,Object? totalElements = null,Object? totalPages = null,Object? last = null,}) {
  return _then(_AdminArtistPageModel(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<AdminArtistModel>,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,last: null == last ? _self.last : last // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
