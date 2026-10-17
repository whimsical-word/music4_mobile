import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import 'sse_raw_event.dart';

/// Transport SSE cho các nền tảng native (Android, iOS, macOS, Windows, Linux).
/// Sử dụng `Dio` với `ResponseType.stream` để parse luồng byte `text/event-stream`.
Stream<SseRawEvent> openSseStream(
  String url, {
  required Dio dio,
  CancelToken? cancelToken,
}) async* {
  final response = await dio.get<ResponseBody>(
    url,
    cancelToken: cancelToken,
    options: Options(
      responseType: ResponseType.stream,
      receiveTimeout: Duration.zero,
      headers: {
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
      },
    ),
  );

  final lines = response.data!.stream
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter());

  String? event;
  final data = StringBuffer();

  await for (final line in lines) {
    if (line.isEmpty) {
      if (event != null || data.isNotEmpty) {
        yield SseRawEvent(event: event, data: data.toString());
      }
      event = null;
      data.clear();
      continue;
    }
    if (line.startsWith(':')) continue; // Heartbeat / comment

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

  if (event != null || data.isNotEmpty) {
    yield SseRawEvent(event: event, data: data.toString());
  }
}
