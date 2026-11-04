import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';
import 'sse_transport.dart';

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
/// - Đa nền tảng (Cross-platform):
///   - Native (Android, iOS, Desktop): dùng Dio `ResponseType.stream` tự parse byte chunks.
///   - Web: dùng HTML5 `EventSource` của browser để nhận stream real-time liên tục.
/// - Tự động reconnect (backoff 2s → 30s) khi rớt mạng / server restart.
/// - Hủy subscription (`cancel`) sẽ đóng HTTP stream qua `CancelToken` / `EventSource.close()`.
class NotificationSseService {
  /// Tên các event Backend bắn kèm payload `NotificationResponseDTO`.
  static const _notificationEvents = {'NOTIFICATION', 'NEW_TRACK', 'NEW_ALBUM'};

  final Dio _dio;

  NotificationSseService(this._dio);

  String _buildFullUrl(int userId) {
    final path = '${ApiEndpoints.subscribeNotification}/$userId';
    final base = _dio.options.baseUrl.isNotEmpty
        ? _dio.options.baseUrl
        : ApiEndpoints.baseUrl;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final cleanBase =
        base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return '$cleanBase$cleanPath';
  }

  Stream<NotificationSseEvent> subscribe(int userId) {
    late final StreamController<NotificationSseEvent> controller;
    CancelToken? cancelToken;
    var closed = false;

    Future<void> run() async {
      var attempt = 0;
      final url = _buildFullUrl(userId);

      while (!closed) {
        try {
          cancelToken = CancelToken();
          debugPrint('[SSE] Connecting for userId=$userId: $url');
          final rawStream = openSseStream(
            url,
            dio: _dio,
            cancelToken: cancelToken,
          );
          attempt = 0;
          await for (final rawEvent in rawStream) {
            if (closed) break;
            _dispatch(rawEvent.event, rawEvent.data, controller);
          }
          debugPrint('[SSE] Stream ended');
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
