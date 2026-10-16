import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';

/// Các loại sự kiện SSE từ Backend
sealed class NotificationSseEvent {
  const NotificationSseEvent();
}

/// Sự kiện thông báo mới (NEW_TRACK, NEW_ALBUM, NOTIFICATION)
class NotificationReceivedEvent extends NotificationSseEvent {
  final NotificationModel notification;
  const NotificationReceivedEvent(this.notification);
}

/// Sự kiện bài hát bị xóa (TRACK_DELETED)
class TrackDeletedEvent extends NotificationSseEvent {
  final int trackId;
  const TrackDeletedEvent(this.trackId);
}

/// Kết nối SSE (`text/event-stream`) tới `GET /api/notifications/subscribe/{userId}`.
///
/// - Dùng chung `Dio` của `DioClient` (baseUrl + AuthInterceptor gắn JWT).
/// - Tự động reconnect (backoff 2s → 30s) khi rớt mạng / server restart.
/// - Hủy subscription (`cancel`) sẽ đóng luôn HTTP stream qua `CancelToken`.
class NotificationSseService {
  /// Tên các event Backend bắn kèm payload `NotificationResponseDTO`.
  static const _notificationEvents = {'NOTIFICATION', 'NEW_TRACK', 'NEW_ALBUM'};

  final Dio _dio;

  NotificationSseService(this._dio);

  Stream<NotificationSseEvent> subscribe(int userId) {
    late final StreamController<NotificationSseEvent> controller;
    CancelToken? cancelToken;
    var closed = false;

    Future<void> run() async {
      var attempt = 0;
      while (!closed) {
        try {
          cancelToken = CancelToken();
          final response = await _dio.get<ResponseBody>(
            '${ApiEndpoints.subscribeNotification}/$userId',
            cancelToken: cancelToken,
            options: Options(
              responseType: ResponseType.stream,
              receiveTimeout: Duration.zero, // kết nối sống lâu, không timeout
              headers: {
                'Accept': 'text/event-stream',
                'Cache-Control': 'no-cache',
              },
            ),
          );
          attempt = 0;
          debugPrint('[SSE] Connected for userId=$userId');
          await _consume(response.data!.stream, controller);
          debugPrint('[SSE] Stream closed by server');
        } catch (e) {
          if (closed) break;
          debugPrint('[SSE] Connection error: $e');
        }
        if (closed) break;
        final delaySeconds = min(30, 2 << min(attempt++, 4));
        debugPrint('[SSE] Reconnecting in ${delaySeconds}s...');
        await Future<void>.delayed(Duration(seconds: delaySeconds));
      }
    }

    controller = StreamController<NotificationSseEvent>(
      onListen: run,
      onCancel: () {
        closed = true;
        cancelToken?.cancel('NotificationSseService cancelled');
        debugPrint('[SSE] Disconnected for userId=$userId');
      },
    );
    return controller.stream;
  }

  /// Parse khung SSE: `event:<name>` + `data:<json>` + dòng trống kết thúc event.
  Future<void> _consume(
    Stream<Uint8List> body,
    StreamController<NotificationSseEvent> sink,
  ) async {
    final lines = body
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    String? event;
    final data = StringBuffer();

    await for (final line in lines) {
      if (line.isEmpty) {
        _dispatch(event, data.toString(), sink);
        event = null;
        data.clear();
        continue;
      }
      if (line.startsWith(':')) continue; // comment / heartbeat

      final sep = line.indexOf(':');
      final field = sep == -1 ? line : line.substring(0, sep);
      var value = sep == -1 ? '' : line.substring(sep + 1);
      if (value.startsWith(' ')) value = value.substring(1);

      if (field == 'event') {
        event = value;
      } else if (field == 'data') {
        if (data.isNotEmpty) data.write('\n');
        data.write(value);
      }
    }
  }

  void _dispatch(
    String? event,
    String payload,
    StreamController<NotificationSseEvent> sink,
  ) {
    if (event == null && payload.isEmpty) return;
    debugPrint('[SSE] event=$event data=$payload');
    if (sink.isClosed) return;

    if (event == 'TRACK_DELETED') {
      try {
        final json = jsonDecode(payload) as Map<String, dynamic>;
        final trackId =
            json['trackId'] as int? ?? int.tryParse('${json['trackId']}');
        if (trackId != null) {
          sink.add(TrackDeletedEvent(trackId));
        }
      } catch (e) {
        debugPrint('[SSE] Cannot parse TRACK_DELETED payload: $e');
      }
      return;
    }

    if (!_notificationEvents.contains(event)) return;
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      sink.add(NotificationReceivedEvent(NotificationModel.fromJson(json)));
    } catch (e) {
      debugPrint('[SSE] Cannot parse notification payload: $e');
    }
  }
}
