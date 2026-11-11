import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_play_request.freezed.dart';
part 'track_play_request.g.dart';

@freezed
abstract class TrackPlayRequest with _$TrackPlayRequest {
  const factory TrackPlayRequest({
    required String trackId,
    String? userId,
  }) = _TrackPlayRequest;

  factory TrackPlayRequest.fromJson(Map<String, dynamic> json) =>
      _$TrackPlayRequestFromJson(json);
}
