import 'package:freezed_annotation/freezed_annotation.dart';
import 'history_track_response.dart';

part 'history_page_response.freezed.dart';
part 'history_page_response.g.dart';

@freezed
sealed class HistoryPageResponse with _$HistoryPageResponse {
  const factory HistoryPageResponse({
    @Default([]) List<HistoryTrackResponse> content,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(10) int size,
    @Default(0) int number,
  }) = _HistoryPageResponse;

  factory HistoryPageResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryPageResponseFromJson(json);
}
