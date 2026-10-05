import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/models/history_track_response.dart';
import '../../data/repositories/history_repository.dart';

final historyDioProvider = Provider<Dio>((ref) {
  return DioClient().dio;
});

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dio = ref.watch(historyDioProvider);
  return HistoryRepository(dio);
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<HistoryTrackResponse>>> {
  final HistoryRepository _repository;

  HistoryNotifier(this._repository) : super(const AsyncValue.loading());

  Future<void> fetchHistory() async {
    state = const AsyncValue.loading();
    try {
      // Temporary mock user ID until Auth is fully integrated
      const int userId = 1;

      final pageResponse = await _repository.getListeningHistory(userId);
      state = AsyncValue.data(pageResponse.content);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshHistory() async {
    await fetchHistory();
  }
}

final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<HistoryTrackResponse>>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return HistoryNotifier(repository)..fetchHistory();
});
