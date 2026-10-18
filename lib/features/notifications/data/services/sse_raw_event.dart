/// Frame dữ liệu SSE thô nhận được từ server (`event` và `data`).
class SseRawEvent {
  final String? event;
  final String data;

  const SseRawEvent({this.event, required this.data});
}
