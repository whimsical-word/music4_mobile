// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist_overview_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArtistOverviewResponse _$ArtistOverviewResponseFromJson(
  Map<String, dynamic> json,
) => _ArtistOverviewResponse(
  totalViews: (json['totalViews'] as num?)?.toInt() ?? 0,
  totalFavorites: (json['totalFavorites'] as num?)?.toInt() ?? 0,
  totalFollowers: (json['totalFollowers'] as num?)?.toInt() ?? 0,
  totalComments: (json['totalComments'] as num?)?.toInt() ?? 0,
  chartData:
      (json['chartData'] as List<dynamic>?)
          ?.map(
            (e) => DailyAnalyticsResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$ArtistOverviewResponseToJson(
  _ArtistOverviewResponse instance,
) => <String, dynamic>{
  'totalViews': instance.totalViews,
  'totalFavorites': instance.totalFavorites,
  'totalFollowers': instance.totalFollowers,
  'totalComments': instance.totalComments,
  'chartData': instance.chartData,
};

_DailyAnalyticsResponse _$DailyAnalyticsResponseFromJson(
  Map<String, dynamic> json,
) => _DailyAnalyticsResponse(
  day: json['day'] as String?,
  views: (json['views'] as num?)?.toInt() ?? 0,
  likes: (json['likes'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DailyAnalyticsResponseToJson(
  _DailyAnalyticsResponse instance,
) => <String, dynamic>{
  'day': instance.day,
  'views': instance.views,
  'likes': instance.likes,
};
