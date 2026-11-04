import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music4_mobile/features/notifications/data/services/sse_raw_event.dart';
import 'package:music4_mobile/features/notifications/data/services/sse_transport_io.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(
      BaseOptions(baseUrl: 'http://localhost:8080'),
    );
  });

  test('openSseStream parse đúng chuỗi SSE từ ResponseBody trên IO', () async {
    final streamController = StreamController<Uint8List>();
    final responseBody = ResponseBody(
      streamController.stream,
      200,
      headers: {
        'content-type': ['text/event-stream'],
      },
    );

    when(
      () => mockDio.get<ResponseBody>(
        any(),
        cancelToken: any(named: 'cancelToken'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response<ResponseBody>(
        data: responseBody,
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/notifications/subscribe/9'),
      ),
    );

    final events = <SseRawEvent>[];
    final sub = openSseStream(
      'http://localhost:8080/api/notifications/subscribe/9',
      dio: mockDio,
    ).listen(events.add);

    // Bơm SSE frames
    streamController.add(
      utf8.encode(
        ':heartbeat\n\n'
        'event: NOTIFICATION\n'
        'data: {"id":1,"trackId":10,"trackName":"Test","isRead":false}\n\n'
        'event: TRACK_DELETED\n'
        'data: {"trackId":10}\n\n',
      ),
    );

    await streamController.close();
    await Future<void>.delayed(const Duration(milliseconds: 50));
    await sub.cancel();

    expect(events.length, 2);
    expect(events[0].event, 'NOTIFICATION');
    expect(events[0].data, contains('"id":1'));
    expect(events[1].event, 'TRACK_DELETED');
    expect(events[1].data, '{"trackId":10}');
  });
}
