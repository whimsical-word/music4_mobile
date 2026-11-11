// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_page_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryPageResponse {

 List<HistoryTrackResponse> get content; int get totalElements; int get totalPages; int get size; int get number;
/// Create a copy of HistoryPageResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryPageResponseCopyWith<HistoryPageResponse> get copyWith => _$HistoryPageResponseCopyWithImpl<HistoryPageResponse>(this as HistoryPageResponse, _$identity);

  /// Serializes this HistoryPageResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as HistoryPageResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryPageResponse&&const DeepCollectionEquality().equals(other.content, _this.content)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.size, _this.size) || other.size == _this.size)&&(identical(other.number, _this.number) || other.number == _this.number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as HistoryPageResponse;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.content),_this.totalElements,_this.totalPages,_this.size,_this.number);
}

@override
String toString() {
  final _this = this as HistoryPageResponse;
  return 'HistoryPageResponse(content: ${_this.content}, totalElements: ${_this.totalElements}, totalPages: ${_this.totalPages}, size: ${_this.size}, number: ${_this.number})';
}


}

/// @nodoc
abstract mixin class $HistoryPageResponseCopyWith<$Res>  {
  factory $HistoryPageResponseCopyWith(HistoryPageResponse value, $Res Function(HistoryPageResponse) _then) = _$HistoryPageResponseCopyWithImpl;
@useResult
$Res call({
 List<HistoryTrackResponse> content, int totalElements, int totalPages, int size, int number
});




}
/// @nodoc
class _$HistoryPageResponseCopyWithImpl<$Res>
    implements $HistoryPageResponseCopyWith<$Res> {
  _$HistoryPageResponseCopyWithImpl(this._self, this._then);

  final HistoryPageResponse _self;
  final $Res Function(HistoryPageResponse) _then;

/// Create a copy of HistoryPageResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? totalElements = null,Object? totalPages = null,Object? size = null,Object? number = null,}) {
  return _then(HistoryPageResponse(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<HistoryTrackResponse>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryPageResponse].
extension HistoryPageResponsePatterns on HistoryPageResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryPageResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryPageResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryPageResponse value)  $default,){
final _that = this;
switch (_that) {
case _HistoryPageResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryPageResponse value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryPageResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<HistoryTrackResponse> content,  int totalElements,  int totalPages,  int size,  int number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryPageResponse() when $default != null:
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<HistoryTrackResponse> content,  int totalElements,  int totalPages,  int size,  int number)  $default,) {final _that = this;
switch (_that) {
case _HistoryPageResponse():
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<HistoryTrackResponse> content,  int totalElements,  int totalPages,  int size,  int number)?  $default,) {final _that = this;
switch (_that) {
case _HistoryPageResponse() when $default != null:
return $default(_that.content,_that.totalElements,_that.totalPages,_that.size,_that.number);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryPageResponse implements HistoryPageResponse {
  const _HistoryPageResponse({ List<HistoryTrackResponse> content = const [], this.totalElements = 0, this.totalPages = 0, this.size = 10, this.number = 0}): _content = content;
  factory _HistoryPageResponse.fromJson(Map<String, dynamic> json) => _$HistoryPageResponseFromJson(json);

 final  List<HistoryTrackResponse> _content;
@override@JsonKey() List<HistoryTrackResponse> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int totalElements;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int size;
@override@JsonKey() final  int number;

/// Create a copy of HistoryPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryPageResponseCopyWith<_HistoryPageResponse> get copyWith => __$HistoryPageResponseCopyWithImpl<_HistoryPageResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryPageResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryPageResponse&&const DeepCollectionEquality().equals(other.content, _content)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.size, size) || other.size == size)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),totalElements,totalPages,size,number);
}

@override
String toString() {
    return 'HistoryPageResponse(content: $content, totalElements: $totalElements, totalPages: $totalPages, size: $size, number: $number)';
}


}

/// @nodoc
abstract mixin class _$HistoryPageResponseCopyWith<$Res> implements $HistoryPageResponseCopyWith<$Res> {
  factory _$HistoryPageResponseCopyWith(_HistoryPageResponse value, $Res Function(_HistoryPageResponse) _then) = __$HistoryPageResponseCopyWithImpl;
@override @useResult
$Res call({
 List<HistoryTrackResponse> content, int totalElements, int totalPages, int size, int number
});




}
/// @nodoc
class __$HistoryPageResponseCopyWithImpl<$Res>
    implements _$HistoryPageResponseCopyWith<$Res> {
  __$HistoryPageResponseCopyWithImpl(this._self, this._then);

  final _HistoryPageResponse _self;
  final $Res Function(_HistoryPageResponse) _then;

/// Create a copy of HistoryPageResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? totalElements = null,Object? totalPages = null,Object? size = null,Object? number = null,}) {
  return _then(_HistoryPageResponse(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<HistoryTrackResponse>,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
