import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceState {
  final bool isListening;
  final String recognizedWords;
  final String errorMessage;
  final bool isEnglishMode;

  VoiceState({
    this.isListening = false,
    this.recognizedWords = '',
    this.errorMessage = '',
    this.isEnglishMode = false,
  });

  VoiceState copyWith({
    bool? isListening,
    String? recognizedWords,
    String? errorMessage,
    bool? isEnglishMode,
  }) {
    return VoiceState(
      isListening: isListening ?? this.isListening,
      recognizedWords: recognizedWords ?? this.recognizedWords,
      errorMessage: errorMessage ?? this.errorMessage,
      isEnglishMode: isEnglishMode ?? this.isEnglishMode,
    );
  }
}

class VoiceSearchNotifier extends StateNotifier<VoiceState> {
  VoiceSearchNotifier() : super(VoiceState());

  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  Timer? _silenceTimer;

  // FIX RACE CONDITION: Cờ chặn trạng thái chuyển tiếp
  bool _isCancelling = false;

  Future<bool> checkAndRequestPermission() async {
    if (kIsWeb) return true;

    var status = await Permission.microphone.status;
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status == PermissionStatus.granted;
  }

  Future<String?> _resolveTargetLocale() async {
    if (kIsWeb) return state.isEnglishMode ? 'en-US' : 'vi-VN';

    String targetLangCode = state.isEnglishMode ? 'en' : 'vi';
    List<LocaleName> locales = await _speechToText.locales();
    for (var locale in locales) {
      if (locale.localeId.toLowerCase().contains(targetLangCode)) {
        return locale.localeId;
      }
    }
    return null;
  }

  Future<void> _initSpeech() async {
    if (_isInitialized) return;
    _isInitialized = await _speechToText.initialize(
      onStatus: (status) {
        // FIX RACE CONDITION: Chặn tín hiệu 'notListening' trễ từ session cũ
        if (_isCancelling) return;

        if (status == 'done' || status == 'notListening') {
          state = state.copyWith(isListening: false);
        }
      },
      onError: (errorNotification) {
        state = state.copyWith(
          isListening: false,
          errorMessage: 'Lỗi nhận diện: ${errorNotification.errorMsg}',
        );
      },
    );
  }

  Future<void> toggleLanguage() async {
    final wasListening = state.isListening;

    if (wasListening) {
      _silenceTimer?.cancel();
      // FIX RACE CONDITION: Bật cờ để UI không bị đóng oan uổng khi đang switch ngôn ngữ
      _isCancelling = true;
      await _speechToText.cancel();
      await Future.delayed(const Duration(milliseconds: 200));
      _isCancelling = false;
    }

    state = state.copyWith(
      isEnglishMode: !state.isEnglishMode,
      recognizedWords: '',
    );

    if (wasListening) {
      await startListening();
    }
  }

    Future<void> startListening() async {
    try {
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) {
        state = state.copyWith(errorMessage: 'Vui lòng cấp quyền Micro trong Cài đặt');
        return;
      }

      await _initSpeech();
      if (!_isInitialized) {
        state = state.copyWith(errorMessage: 'Không thể khởi tạo Engine nhận diện giọng nói');
        return;
      }

      String? targetLocaleId = await _resolveTargetLocale();
      if (targetLocaleId == null) {
        String langName = state.isEnglishMode ? 'Tiếng Anh' : 'Tiếng Việt';
        state = state.copyWith(isListening: false, errorMessage: 'Thiết bị chưa cài gói nhận diện $langName.');
        return;
      }

      state = state.copyWith(errorMessage: '', recognizedWords: '', isListening: true);

      void resetSilenceTimer() {
        _silenceTimer?.cancel();
        _silenceTimer = Timer(const Duration(seconds: 3), () {
          if (state.isListening) stopListening();
        });
      }

      // FIX MERGE CONFLICT: Bọc thép Safe Start ngắt luồng cũ an toàn trên Web
      if (_speechToText.isListening || _speechToText.isAvailable) {
        _isCancelling = true;
        await _speechToText.cancel();
        await Future.delayed(const Duration(milliseconds: 100)); // Trình duyệt cần 100ms để dọn rác
        _isCancelling = false;
      }

      // FIX MERGE CONFLICT: Dập lỗi InvalidStateError bằng try-catch cục bộ
      try {
        await _speechToText.listen(
          onResult: (result) {
            state = state.copyWith(recognizedWords: result.recognizedWords);
            resetSilenceTimer();
          },
          listenOptions: SpeechListenOptions(localeId: targetLocaleId),
        );
      } catch (e) {
        if (e.toString().contains('InvalidStateError')) {
          // Nếu vẫn bị Webkit bắt bẻ, force tắt và kết thúc im lặng
          stopListening();
          return;
        }
        rethrow;
      }

      resetSilenceTimer();
    } catch (e) {
      state = state.copyWith(isListening: false, errorMessage: 'Lỗi hệ thống: ${e.toString()}');
    }
  }
  Future<void> stopListening() async {
    _silenceTimer?.cancel();
    await _speechToText.stop();
    state = state.copyWith(isListening: false);
  }

  // BỔ SUNG: Hàm Hủy bỏ hoàn toàn (Xóa text để không tự động gọi API)
  Future<void> cancelSearch() async {
    _silenceTimer?.cancel();
    await _speechToText.cancel();
    state = state.copyWith(isListening: false, recognizedWords: '');
  }

  @override
  void dispose() {
    _silenceTimer?.cancel();
    _speechToText.cancel();
    super.dispose();
  }
}

final voiceSearchProvider =
    StateNotifierProvider<VoiceSearchNotifier, VoiceState>((ref) {
      return VoiceSearchNotifier();
    });
