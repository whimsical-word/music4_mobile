import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/history_item.dart';

final historyNotifierProvider = AsyncNotifierProvider<HistoryNotifier, List<HistoryItem>>(() {
  return HistoryNotifier();
});

class HistoryNotifier extends AsyncNotifier<List<HistoryItem>> {
  @override
  FutureOr<List<HistoryItem>> build() async {
    return _fetchMockData();
  }

  Future<List<HistoryItem>> _fetchMockData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    return [
      HistoryItem(
        id: '1',
        trackId: 't1',
        trackTitle: 'Lạc Trôi',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      HistoryItem(
        id: '2',
        trackId: 't2',
        trackTitle: 'Em Gái Mưa',
        artistName: 'Hương Tràm',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      HistoryItem(
        id: '3',
        trackId: 't3',
        trackTitle: 'Có Chắc Yêu Là Đây',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      HistoryItem(
        id: '4',
        trackId: 't4',
        trackTitle: 'Nắng Ấm Xa Dần',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      HistoryItem(
        id: '5',
        trackId: 't5',
        trackTitle: 'Buồn Của Anh',
        artistName: 'K-ICM, Đạt G, Masew',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      HistoryItem(
        id: '6',
        trackId: 't6',
        trackTitle: 'Chạy Ngay Đi',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      HistoryItem(
        id: '7',
        trackId: 't7',
        trackTitle: 'Nơi Này Có Anh',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
      HistoryItem(
        id: '8',
        trackId: 't8',
        trackTitle: 'Hãy Trao Cho Anh',
        artistName: 'Sơn Tùng M-TP',
        artworkUrl: 'https://via.placeholder.com/150',
        playedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<void> refreshHistory() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchMockData());
  }

  // Helper method for testing the error state
  Future<void> simulateError() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    state = AsyncValue.error('Không thể tải lịch sử nghe nhạc. Vui lòng thử lại.', StackTrace.current);
  }

  // Helper method for testing empty state
  Future<void> simulateEmpty() async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    state = const AsyncValue.data([]);
  }
}
