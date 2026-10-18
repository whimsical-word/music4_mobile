// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchArtistInfo {

 int get id; String get name; String? get role;
/// Create a copy of SearchArtistInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchArtistInfoCopyWith<SearchArtistInfo> get copyWith => _$SearchArtistInfoCopyWithImpl<SearchArtistInfo>(this as SearchArtistInfo, _$identity);

  /// Serializes this SearchArtistInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchArtistInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchArtistInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.role, _this.role) || other.role == _this.role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchArtistInfo;
  return Object.hash(runtimeType,_this.id,_this.name,_this.role);
}

@override
String toString() {
  final _this = this as SearchArtistInfo;
  return 'SearchArtistInfo(id: ${_this.id}, name: ${_this.name}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $SearchArtistInfoCopyWith<$Res>  {
  factory $SearchArtistInfoCopyWith(SearchArtistInfo value, $Res Function(SearchArtistInfo) _then) = _$SearchArtistInfoCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class _$SearchArtistInfoCopyWithImpl<$Res>
    implements $SearchArtistInfoCopyWith<$Res> {
  _$SearchArtistInfoCopyWithImpl(this._self, this._then);

  final SearchArtistInfo _self;
  final $Res Function(SearchArtistInfo) _then;

/// Create a copy of SearchArtistInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(SearchArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchArtistInfo].
extension SearchArtistInfoPatterns on SearchArtistInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchArtistInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchArtistInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchArtistInfo value)  $default,){
final _that = this;
switch (_that) {
case _SearchArtistInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchArtistInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SearchArtistInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchArtistInfo() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? role)  $default,) {final _that = this;
switch (_that) {
case _SearchArtistInfo():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? role)?  $default,) {final _that = this;
switch (_that) {
case _SearchArtistInfo() when $default != null:
return $default(_that.id,_that.name,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchArtistInfo implements SearchArtistInfo {
  const _SearchArtistInfo({required this.id, required this.name, this.role});
  factory _SearchArtistInfo.fromJson(Map<String, dynamic> json) => _$SearchArtistInfoFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? role;

/// Create a copy of SearchArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchArtistInfoCopyWith<_SearchArtistInfo> get copyWith => __$SearchArtistInfoCopyWithImpl<_SearchArtistInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchArtistInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchArtistInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,role);
}

@override
String toString() {
    return 'SearchArtistInfo(id: $id, name: $name, role: $role)';
}


}

/// @nodoc
abstract mixin class _$SearchArtistInfoCopyWith<$Res> implements $SearchArtistInfoCopyWith<$Res> {
  factory _$SearchArtistInfoCopyWith(_SearchArtistInfo value, $Res Function(_SearchArtistInfo) _then) = __$SearchArtistInfoCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? role
});




}
/// @nodoc
class __$SearchArtistInfoCopyWithImpl<$Res>
    implements _$SearchArtistInfoCopyWith<$Res> {
  __$SearchArtistInfoCopyWithImpl(this._self, this._then);

  final _SearchArtistInfo _self;
  final $Res Function(_SearchArtistInfo) _then;

/// Create a copy of SearchArtistInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = freezed,}) {
  return _then(_SearchArtistInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SearchItem {

 int get id; String get name; String? get img; String? get albumName; int? get duration; List<SearchArtistInfo> get artists;
/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchItemCopyWith<SearchItem> get copyWith => _$SearchItemCopyWithImpl<SearchItem>(this as SearchItem, _$identity);

  /// Serializes this SearchItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.img, _this.img) || other.img == _this.img)&&(identical(other.albumName, _this.albumName) || other.albumName == _this.albumName)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&const DeepCollectionEquality().equals(other.artists, _this.artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.img,_this.albumName,_this.duration,const DeepCollectionEquality().hash(_this.artists));
}

@override
String toString() {
  final _this = this as SearchItem;
  return 'SearchItem(id: ${_this.id}, name: ${_this.name}, img: ${_this.img}, albumName: ${_this.albumName}, duration: ${_this.duration}, artists: ${_this.artists})';
}


}

/// @nodoc
abstract mixin class $SearchItemCopyWith<$Res>  {
  factory $SearchItemCopyWith(SearchItem value, $Res Function(SearchItem) _then) = _$SearchItemCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? img, String? albumName, int? duration, List<SearchArtistInfo> artists
});




}
/// @nodoc
class _$SearchItemCopyWithImpl<$Res>
    implements $SearchItemCopyWith<$Res> {
  _$SearchItemCopyWithImpl(this._self, this._then);

  final SearchItem _self;
  final $Res Function(SearchItem) _then;

/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? albumName = freezed,Object? duration = freezed,Object? artists = null,}) {
  return _then(SearchItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,artists: null == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<SearchArtistInfo>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchItem].
extension SearchItemPatterns on SearchItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchItem value)  $default,){
final _that = this;
switch (_that) {
case _SearchItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchItem value)?  $default,){
final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? albumName,  int? duration,  List<SearchArtistInfo> artists)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.albumName,_that.duration,_that.artists);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? img,  String? albumName,  int? duration,  List<SearchArtistInfo> artists)  $default,) {final _that = this;
switch (_that) {
case _SearchItem():
return $default(_that.id,_that.name,_that.img,_that.albumName,_that.duration,_that.artists);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? img,  String? albumName,  int? duration,  List<SearchArtistInfo> artists)?  $default,) {final _that = this;
switch (_that) {
case _SearchItem() when $default != null:
return $default(_that.id,_that.name,_that.img,_that.albumName,_that.duration,_that.artists);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchItem implements SearchItem {
  const _SearchItem({required this.id, required this.name, this.img, this.albumName, this.duration,  List<SearchArtistInfo> artists = const <SearchArtistInfo>[]}): _artists = artists;
  factory _SearchItem.fromJson(Map<String, dynamic> json) => _$SearchItemFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? img;
@override final  String? albumName;
@override final  int? duration;
 final  List<SearchArtistInfo> _artists;
@override@JsonKey() List<SearchArtistInfo> get artists {
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_artists);
}


/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchItemCopyWith<_SearchItem> get copyWith => __$SearchItemCopyWithImpl<_SearchItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.img, img) || other.img == img)&&(identical(other.albumName, albumName) || other.albumName == albumName)&&(identical(other.duration, duration) || other.duration == duration)&&const DeepCollectionEquality().equals(other.artists, _artists));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,img,albumName,duration,const DeepCollectionEquality().hash(_artists));
}

@override
String toString() {
    return 'SearchItem(id: $id, name: $name, img: $img, albumName: $albumName, duration: $duration, artists: $artists)';
}


}

/// @nodoc
abstract mixin class _$SearchItemCopyWith<$Res> implements $SearchItemCopyWith<$Res> {
  factory _$SearchItemCopyWith(_SearchItem value, $Res Function(_SearchItem) _then) = __$SearchItemCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? img, String? albumName, int? duration, List<SearchArtistInfo> artists
});




}
/// @nodoc
class __$SearchItemCopyWithImpl<$Res>
    implements _$SearchItemCopyWith<$Res> {
  __$SearchItemCopyWithImpl(this._self, this._then);

  final _SearchItem _self;
  final $Res Function(_SearchItem) _then;

/// Create a copy of SearchItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? img = freezed,Object? albumName = freezed,Object? duration = freezed,Object? artists = null,}) {
  return _then(_SearchItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,img: freezed == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String?,albumName: freezed == albumName ? _self.albumName : albumName // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,artists: null == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<SearchArtistInfo>,
  ));
}


}


/// @nodoc
mixin _$SearchPage {

 List<SearchItem> get content; int get totalPages; int get totalElements;
/// Create a copy of SearchPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchPageCopyWith<SearchPage> get copyWith => _$SearchPageCopyWithImpl<SearchPage>(this as SearchPage, _$identity);

  /// Serializes this SearchPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchPage&&const DeepCollectionEquality().equals(other.content, _this.content)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.content),_this.totalPages,_this.totalElements);
}

@override
String toString() {
  final _this = this as SearchPage;
  return 'SearchPage(content: ${_this.content}, totalPages: ${_this.totalPages}, totalElements: ${_this.totalElements})';
}


}

/// @nodoc
abstract mixin class $SearchPageCopyWith<$Res>  {
  factory $SearchPageCopyWith(SearchPage value, $Res Function(SearchPage) _then) = _$SearchPageCopyWithImpl;
@useResult
$Res call({
 List<SearchItem> content, int totalPages, int totalElements
});




}
/// @nodoc
class _$SearchPageCopyWithImpl<$Res>
    implements $SearchPageCopyWith<$Res> {
  _$SearchPageCopyWithImpl(this._self, this._then);

  final SearchPage _self;
  final $Res Function(SearchPage) _then;

/// Create a copy of SearchPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? totalPages = null,Object? totalElements = null,}) {
  return _then(SearchPage(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as List<SearchItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchPage].
extension SearchPagePatterns on SearchPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchPage value)  $default,){
final _that = this;
switch (_that) {
case _SearchPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchPage value)?  $default,){
final _that = this;
switch (_that) {
case _SearchPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SearchItem> content,  int totalPages,  int totalElements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchPage() when $default != null:
return $default(_that.content,_that.totalPages,_that.totalElements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SearchItem> content,  int totalPages,  int totalElements)  $default,) {final _that = this;
switch (_that) {
case _SearchPage():
return $default(_that.content,_that.totalPages,_that.totalElements);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SearchItem> content,  int totalPages,  int totalElements)?  $default,) {final _that = this;
switch (_that) {
case _SearchPage() when $default != null:
return $default(_that.content,_that.totalPages,_that.totalElements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchPage implements SearchPage {
  const _SearchPage({ List<SearchItem> content = const <SearchItem>[], this.totalPages = 0, this.totalElements = 0}): _content = content;
  factory _SearchPage.fromJson(Map<String, dynamic> json) => _$SearchPageFromJson(json);

 final  List<SearchItem> _content;
@override@JsonKey() List<SearchItem> get content {
  if (_content is EqualUnmodifiableListView) return _content;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_content);
}

@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int totalElements;

/// Create a copy of SearchPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchPageCopyWith<_SearchPage> get copyWith => __$SearchPageCopyWithImpl<_SearchPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchPage&&const DeepCollectionEquality().equals(other.content, _content)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_content),totalPages,totalElements);
}

@override
String toString() {
    return 'SearchPage(content: $content, totalPages: $totalPages, totalElements: $totalElements)';
}


}

/// @nodoc
abstract mixin class _$SearchPageCopyWith<$Res> implements $SearchPageCopyWith<$Res> {
  factory _$SearchPageCopyWith(_SearchPage value, $Res Function(_SearchPage) _then) = __$SearchPageCopyWithImpl;
@override @useResult
$Res call({
 List<SearchItem> content, int totalPages, int totalElements
});




}
/// @nodoc
class __$SearchPageCopyWithImpl<$Res>
    implements _$SearchPageCopyWith<$Res> {
  __$SearchPageCopyWithImpl(this._self, this._then);

  final _SearchPage _self;
  final $Res Function(_SearchPage) _then;

/// Create a copy of SearchPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? totalPages = null,Object? totalElements = null,}) {
  return _then(_SearchPage(
content: null == content ? _self._content : content // ignore: cast_nullable_to_non_nullable
as List<SearchItem>,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$SearchResponse {

 SearchPage? get tracks; SearchPage? get albums; SearchPage? get artists; SearchPage? get categories;
/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResponseCopyWith<SearchResponse> get copyWith => _$SearchResponseCopyWithImpl<SearchResponse>(this as SearchResponse, _$identity);

  /// Serializes this SearchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SearchResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResponse&&(identical(other.tracks, _this.tracks) || other.tracks == _this.tracks)&&(identical(other.albums, _this.albums) || other.albums == _this.albums)&&(identical(other.artists, _this.artists) || other.artists == _this.artists)&&(identical(other.categories, _this.categories) || other.categories == _this.categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SearchResponse;
  return Object.hash(runtimeType,_this.tracks,_this.albums,_this.artists,_this.categories);
}

@override
String toString() {
  final _this = this as SearchResponse;
  return 'SearchResponse(tracks: ${_this.tracks}, albums: ${_this.albums}, artists: ${_this.artists}, categories: ${_this.categories})';
}


}

/// @nodoc
abstract mixin class $SearchResponseCopyWith<$Res>  {
  factory $SearchResponseCopyWith(SearchResponse value, $Res Function(SearchResponse) _then) = _$SearchResponseCopyWithImpl;
@useResult
$Res call({
 SearchPage? tracks, SearchPage? albums, SearchPage? artists, SearchPage? categories
});


$SearchPageCopyWith<$Res>? get tracks;$SearchPageCopyWith<$Res>? get albums;$SearchPageCopyWith<$Res>? get artists;$SearchPageCopyWith<$Res>? get categories;

}
/// @nodoc
class _$SearchResponseCopyWithImpl<$Res>
    implements $SearchResponseCopyWith<$Res> {
  _$SearchResponseCopyWithImpl(this._self, this._then);

  final SearchResponse _self;
  final $Res Function(SearchResponse) _then;

/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tracks = freezed,Object? albums = freezed,Object? artists = freezed,Object? categories = freezed,}) {
  return _then(SearchResponse(
tracks: freezed == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as SearchPage?,albums: freezed == albums ? _self.albums : albums // ignore: cast_nullable_to_non_nullable
as SearchPage?,artists: freezed == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as SearchPage?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as SearchPage?,
  ));
}
/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get tracks {
    if (_self.tracks == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.tracks!, (value) {
    return _then(_self.copyWith(tracks: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get albums {
    if (_self.albums == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.albums!, (value) {
    return _then(_self.copyWith(albums: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get artists {
    if (_self.artists == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.artists!, (value) {
    return _then(_self.copyWith(artists: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get categories {
    if (_self.categories == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.categories!, (value) {
    return _then(_self.copyWith(categories: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchResponse].
extension SearchResponsePatterns on SearchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResponse value)  $default,){
final _that = this;
switch (_that) {
case _SearchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SearchPage? tracks,  SearchPage? albums,  SearchPage? artists,  SearchPage? categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResponse() when $default != null:
return $default(_that.tracks,_that.albums,_that.artists,_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SearchPage? tracks,  SearchPage? albums,  SearchPage? artists,  SearchPage? categories)  $default,) {final _that = this;
switch (_that) {
case _SearchResponse():
return $default(_that.tracks,_that.albums,_that.artists,_that.categories);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SearchPage? tracks,  SearchPage? albums,  SearchPage? artists,  SearchPage? categories)?  $default,) {final _that = this;
switch (_that) {
case _SearchResponse() when $default != null:
return $default(_that.tracks,_that.albums,_that.artists,_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResponse implements SearchResponse {
  const _SearchResponse({this.tracks, this.albums, this.artists, this.categories});
  factory _SearchResponse.fromJson(Map<String, dynamic> json) => _$SearchResponseFromJson(json);

@override final  SearchPage? tracks;
@override final  SearchPage? albums;
@override final  SearchPage? artists;
@override final  SearchPage? categories;

/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResponseCopyWith<_SearchResponse> get copyWith => __$SearchResponseCopyWithImpl<_SearchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResponse&&(identical(other.tracks, tracks) || other.tracks == tracks)&&(identical(other.albums, albums) || other.albums == albums)&&(identical(other.artists, artists) || other.artists == artists)&&(identical(other.categories, categories) || other.categories == categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tracks,albums,artists,categories);
}

@override
String toString() {
    return 'SearchResponse(tracks: $tracks, albums: $albums, artists: $artists, categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$SearchResponseCopyWith<$Res> implements $SearchResponseCopyWith<$Res> {
  factory _$SearchResponseCopyWith(_SearchResponse value, $Res Function(_SearchResponse) _then) = __$SearchResponseCopyWithImpl;
@override @useResult
$Res call({
 SearchPage? tracks, SearchPage? albums, SearchPage? artists, SearchPage? categories
});


@override $SearchPageCopyWith<$Res>? get tracks;@override $SearchPageCopyWith<$Res>? get albums;@override $SearchPageCopyWith<$Res>? get artists;@override $SearchPageCopyWith<$Res>? get categories;

}
/// @nodoc
class __$SearchResponseCopyWithImpl<$Res>
    implements _$SearchResponseCopyWith<$Res> {
  __$SearchResponseCopyWithImpl(this._self, this._then);

  final _SearchResponse _self;
  final $Res Function(_SearchResponse) _then;

/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tracks = freezed,Object? albums = freezed,Object? artists = freezed,Object? categories = freezed,}) {
  return _then(_SearchResponse(
tracks: freezed == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as SearchPage?,albums: freezed == albums ? _self.albums : albums // ignore: cast_nullable_to_non_nullable
as SearchPage?,artists: freezed == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as SearchPage?,categories: freezed == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as SearchPage?,
  ));
}

/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get tracks {
    if (_self.tracks == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.tracks!, (value) {
    return _then(_self.copyWith(tracks: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get albums {
    if (_self.albums == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.albums!, (value) {
    return _then(_self.copyWith(albums: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get artists {
    if (_self.artists == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.artists!, (value) {
    return _then(_self.copyWith(artists: value));
  });
}/// Create a copy of SearchResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchPageCopyWith<$Res>? get categories {
    if (_self.categories == null) {
    return null;
  }

  return $SearchPageCopyWith<$Res>(_self.categories!, (value) {
    return _then(_self.copyWith(categories: value));
  });
}
}

// dart format on
