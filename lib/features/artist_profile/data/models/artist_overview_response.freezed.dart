// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_overview_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtistOverviewResponse {

 int get totalViews; int get totalFavorites; int get totalFollowers; int get totalComments; List<DailyAnalyticsResponse> get chartData;
/// Create a copy of ArtistOverviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistOverviewResponseCopyWith<ArtistOverviewResponse> get copyWith => _$ArtistOverviewResponseCopyWithImpl<ArtistOverviewResponse>(this as ArtistOverviewResponse, _$identity);

  /// Serializes this ArtistOverviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ArtistOverviewResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistOverviewResponse&&(identical(other.totalViews, _this.totalViews) || other.totalViews == _this.totalViews)&&(identical(other.totalFavorites, _this.totalFavorites) || other.totalFavorites == _this.totalFavorites)&&(identical(other.totalFollowers, _this.totalFollowers) || other.totalFollowers == _this.totalFollowers)&&(identical(other.totalComments, _this.totalComments) || other.totalComments == _this.totalComments)&&const DeepCollectionEquality().equals(other.chartData, _this.chartData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ArtistOverviewResponse;
  return Object.hash(runtimeType,_this.totalViews,_this.totalFavorites,_this.totalFollowers,_this.totalComments,const DeepCollectionEquality().hash(_this.chartData));
}

@override
String toString() {
  final _this = this as ArtistOverviewResponse;
  return 'ArtistOverviewResponse(totalViews: ${_this.totalViews}, totalFavorites: ${_this.totalFavorites}, totalFollowers: ${_this.totalFollowers}, totalComments: ${_this.totalComments}, chartData: ${_this.chartData})';
}


}

/// @nodoc
abstract mixin class $ArtistOverviewResponseCopyWith<$Res>  {
  factory $ArtistOverviewResponseCopyWith(ArtistOverviewResponse value, $Res Function(ArtistOverviewResponse) _then) = _$ArtistOverviewResponseCopyWithImpl;
@useResult
$Res call({
 int totalViews, int totalFavorites, int totalFollowers, int totalComments, List<DailyAnalyticsResponse> chartData
});




}
/// @nodoc
class _$ArtistOverviewResponseCopyWithImpl<$Res>
    implements $ArtistOverviewResponseCopyWith<$Res> {
  _$ArtistOverviewResponseCopyWithImpl(this._self, this._then);

  final ArtistOverviewResponse _self;
  final $Res Function(ArtistOverviewResponse) _then;

/// Create a copy of ArtistOverviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalViews = null,Object? totalFavorites = null,Object? totalFollowers = null,Object? totalComments = null,Object? chartData = null,}) {
  return _then(ArtistOverviewResponse(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalFavorites: null == totalFavorites ? _self.totalFavorites : totalFavorites // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,totalComments: null == totalComments ? _self.totalComments : totalComments // ignore: cast_nullable_to_non_nullable
as int,chartData: null == chartData ? _self.chartData : chartData // ignore: cast_nullable_to_non_nullable
as List<DailyAnalyticsResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistOverviewResponse].
extension ArtistOverviewResponsePatterns on ArtistOverviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistOverviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistOverviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistOverviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ArtistOverviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistOverviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistOverviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalViews,  int totalFavorites,  int totalFollowers,  int totalComments,  List<DailyAnalyticsResponse> chartData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistOverviewResponse() when $default != null:
return $default(_that.totalViews,_that.totalFavorites,_that.totalFollowers,_that.totalComments,_that.chartData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalViews,  int totalFavorites,  int totalFollowers,  int totalComments,  List<DailyAnalyticsResponse> chartData)  $default,) {final _that = this;
switch (_that) {
case _ArtistOverviewResponse():
return $default(_that.totalViews,_that.totalFavorites,_that.totalFollowers,_that.totalComments,_that.chartData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalViews,  int totalFavorites,  int totalFollowers,  int totalComments,  List<DailyAnalyticsResponse> chartData)?  $default,) {final _that = this;
switch (_that) {
case _ArtistOverviewResponse() when $default != null:
return $default(_that.totalViews,_that.totalFavorites,_that.totalFollowers,_that.totalComments,_that.chartData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistOverviewResponse implements ArtistOverviewResponse {
  const _ArtistOverviewResponse({this.totalViews = 0, this.totalFavorites = 0, this.totalFollowers = 0, this.totalComments = 0,  List<DailyAnalyticsResponse> chartData = const []}): _chartData = chartData;
  factory _ArtistOverviewResponse.fromJson(Map<String, dynamic> json) => _$ArtistOverviewResponseFromJson(json);

@override@JsonKey() final  int totalViews;
@override@JsonKey() final  int totalFavorites;
@override@JsonKey() final  int totalFollowers;
@override@JsonKey() final  int totalComments;
 final  List<DailyAnalyticsResponse> _chartData;
@override@JsonKey() List<DailyAnalyticsResponse> get chartData {
  if (_chartData is EqualUnmodifiableListView) return _chartData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chartData);
}


/// Create a copy of ArtistOverviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistOverviewResponseCopyWith<_ArtistOverviewResponse> get copyWith => __$ArtistOverviewResponseCopyWithImpl<_ArtistOverviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistOverviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistOverviewResponse&&(identical(other.totalViews, totalViews) || other.totalViews == totalViews)&&(identical(other.totalFavorites, totalFavorites) || other.totalFavorites == totalFavorites)&&(identical(other.totalFollowers, totalFollowers) || other.totalFollowers == totalFollowers)&&(identical(other.totalComments, totalComments) || other.totalComments == totalComments)&&const DeepCollectionEquality().equals(other.chartData, _chartData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,totalViews,totalFavorites,totalFollowers,totalComments,const DeepCollectionEquality().hash(_chartData));
}

@override
String toString() {
    return 'ArtistOverviewResponse(totalViews: $totalViews, totalFavorites: $totalFavorites, totalFollowers: $totalFollowers, totalComments: $totalComments, chartData: $chartData)';
}


}

/// @nodoc
abstract mixin class _$ArtistOverviewResponseCopyWith<$Res> implements $ArtistOverviewResponseCopyWith<$Res> {
  factory _$ArtistOverviewResponseCopyWith(_ArtistOverviewResponse value, $Res Function(_ArtistOverviewResponse) _then) = __$ArtistOverviewResponseCopyWithImpl;
@override @useResult
$Res call({
 int totalViews, int totalFavorites, int totalFollowers, int totalComments, List<DailyAnalyticsResponse> chartData
});




}
/// @nodoc
class __$ArtistOverviewResponseCopyWithImpl<$Res>
    implements _$ArtistOverviewResponseCopyWith<$Res> {
  __$ArtistOverviewResponseCopyWithImpl(this._self, this._then);

  final _ArtistOverviewResponse _self;
  final $Res Function(_ArtistOverviewResponse) _then;

/// Create a copy of ArtistOverviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalViews = null,Object? totalFavorites = null,Object? totalFollowers = null,Object? totalComments = null,Object? chartData = null,}) {
  return _then(_ArtistOverviewResponse(
totalViews: null == totalViews ? _self.totalViews : totalViews // ignore: cast_nullable_to_non_nullable
as int,totalFavorites: null == totalFavorites ? _self.totalFavorites : totalFavorites // ignore: cast_nullable_to_non_nullable
as int,totalFollowers: null == totalFollowers ? _self.totalFollowers : totalFollowers // ignore: cast_nullable_to_non_nullable
as int,totalComments: null == totalComments ? _self.totalComments : totalComments // ignore: cast_nullable_to_non_nullable
as int,chartData: null == chartData ? _self._chartData : chartData // ignore: cast_nullable_to_non_nullable
as List<DailyAnalyticsResponse>,
  ));
}


}


/// @nodoc
mixin _$DailyAnalyticsResponse {

 String? get day; int get views; int get likes;
/// Create a copy of DailyAnalyticsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyAnalyticsResponseCopyWith<DailyAnalyticsResponse> get copyWith => _$DailyAnalyticsResponseCopyWithImpl<DailyAnalyticsResponse>(this as DailyAnalyticsResponse, _$identity);

  /// Serializes this DailyAnalyticsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DailyAnalyticsResponse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyAnalyticsResponse&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.views, _this.views) || other.views == _this.views)&&(identical(other.likes, _this.likes) || other.likes == _this.likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DailyAnalyticsResponse;
  return Object.hash(runtimeType,_this.day,_this.views,_this.likes);
}

@override
String toString() {
  final _this = this as DailyAnalyticsResponse;
  return 'DailyAnalyticsResponse(day: ${_this.day}, views: ${_this.views}, likes: ${_this.likes})';
}


}

/// @nodoc
abstract mixin class $DailyAnalyticsResponseCopyWith<$Res>  {
  factory $DailyAnalyticsResponseCopyWith(DailyAnalyticsResponse value, $Res Function(DailyAnalyticsResponse) _then) = _$DailyAnalyticsResponseCopyWithImpl;
@useResult
$Res call({
 String? day, int views, int likes
});




}
/// @nodoc
class _$DailyAnalyticsResponseCopyWithImpl<$Res>
    implements $DailyAnalyticsResponseCopyWith<$Res> {
  _$DailyAnalyticsResponseCopyWithImpl(this._self, this._then);

  final DailyAnalyticsResponse _self;
  final $Res Function(DailyAnalyticsResponse) _then;

/// Create a copy of DailyAnalyticsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = freezed,Object? views = null,Object? likes = null,}) {
  return _then(DailyAnalyticsResponse(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyAnalyticsResponse].
extension DailyAnalyticsResponsePatterns on DailyAnalyticsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyAnalyticsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyAnalyticsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyAnalyticsResponse value)  $default,){
final _that = this;
switch (_that) {
case _DailyAnalyticsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyAnalyticsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DailyAnalyticsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? day,  int views,  int likes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyAnalyticsResponse() when $default != null:
return $default(_that.day,_that.views,_that.likes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? day,  int views,  int likes)  $default,) {final _that = this;
switch (_that) {
case _DailyAnalyticsResponse():
return $default(_that.day,_that.views,_that.likes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? day,  int views,  int likes)?  $default,) {final _that = this;
switch (_that) {
case _DailyAnalyticsResponse() when $default != null:
return $default(_that.day,_that.views,_that.likes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyAnalyticsResponse implements DailyAnalyticsResponse {
  const _DailyAnalyticsResponse({this.day, this.views = 0, this.likes = 0});
  factory _DailyAnalyticsResponse.fromJson(Map<String, dynamic> json) => _$DailyAnalyticsResponseFromJson(json);

@override final  String? day;
@override@JsonKey() final  int views;
@override@JsonKey() final  int likes;

/// Create a copy of DailyAnalyticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyAnalyticsResponseCopyWith<_DailyAnalyticsResponse> get copyWith => __$DailyAnalyticsResponseCopyWithImpl<_DailyAnalyticsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyAnalyticsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyAnalyticsResponse&&(identical(other.day, day) || other.day == day)&&(identical(other.views, views) || other.views == views)&&(identical(other.likes, likes) || other.likes == likes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,day,views,likes);
}

@override
String toString() {
    return 'DailyAnalyticsResponse(day: $day, views: $views, likes: $likes)';
}


}

/// @nodoc
abstract mixin class _$DailyAnalyticsResponseCopyWith<$Res> implements $DailyAnalyticsResponseCopyWith<$Res> {
  factory _$DailyAnalyticsResponseCopyWith(_DailyAnalyticsResponse value, $Res Function(_DailyAnalyticsResponse) _then) = __$DailyAnalyticsResponseCopyWithImpl;
@override @useResult
$Res call({
 String? day, int views, int likes
});




}
/// @nodoc
class __$DailyAnalyticsResponseCopyWithImpl<$Res>
    implements _$DailyAnalyticsResponseCopyWith<$Res> {
  __$DailyAnalyticsResponseCopyWithImpl(this._self, this._then);

  final _DailyAnalyticsResponse _self;
  final $Res Function(_DailyAnalyticsResponse) _then;

/// Create a copy of DailyAnalyticsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = freezed,Object? views = null,Object? likes = null,}) {
  return _then(_DailyAnalyticsResponse(
day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,likes: null == likes ? _self.likes : likes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
