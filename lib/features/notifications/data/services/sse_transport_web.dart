// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'sse_raw_event.dart';

/// Transport SSE cho trình duyệt Web (Flutter Web).
/// Sử dụng trực tiếp API HTML5 `EventSource` của trình duyệt để khắc phục
/// hạn chế của XMLHttpRequest/Dio trên web khi giữ stream sống lâu.
Stream<SseRawEvent> openSseStream(
  String url, {
  required Dio dio,
  CancelToken? cancelToken,
}) {
  late final StreamController<SseRawEvent> controller;
  html.EventSource? eventSource;

  void closeEventSource() {
    try {
      eventSource?.close();
    } catch (e) {
      debugPrint('[SSE Web] Error closing EventSource: $e');
    }
    eventSource = null;
  }

  controller = StreamController<SseRawEvent>(
    onListen: () {
      debugPrint('[SSE Web] Opening EventSource: $url');
      final es = html.EventSource(url);
      eventSource = es;

      void emit(String? event, dynamic rawData) {
        if (!controller.isClosed) {
          controller.add(
            SseRawEvent(
              event: event,
              data: rawData?.toString() ?? '',
            ),
          );
        }
      }

      es.onMessage.listen((html.MessageEvent e) {
        emit(null, e.data);
      });

      // Lắng nghe các event tùy chỉnh được phát bởi backend Spring Boot
      const namedEvents = [
        'NOTIFICATION',
        'NEW_TRACK',
        'NEW_ALBUM',
        'TRACK_DELETED',
        'INIT',
      ];
      for (final name in namedEvents) {
        es.addEventListener(name, (html.Event event) {
          dynamic data;
          if (event is html.MessageEvent) {
            data = event.data;
          } else {
            try {
              data = (event as dynamic).data;
            } catch (_) {}
          }
          emit(name, data);
        });
      }

      es.onError.listen((_) {
        // Native EventSource tự động reconnect theo chuẩn W3C/HTML5.
        if (!controller.isClosed) {
          debugPrint('[SSE Web] EventSource connection state: ${es.readyState}');
        }
      });

      cancelToken?.whenCancel.then((_) {
        closeEventSource();
        if (!controller.isClosed) {
          controller.close();
        }
      });
    },
    onCancel: () {
      debugPrint('[SSE Web] Stream cancelled');
      closeEventSource();
    },
  );

  return controller.stream;
}
