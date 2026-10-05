import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'features/player/data/services/app_audio_handler.dart';
import 'features/player/presentation/providers/player_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo AudioPlayer toàn cục để đưa vào AudioHandler
  final audioPlayer = AudioPlayer();
  
  final audioHandler = await AudioService.init<AppAudioHandler>(
    builder: () => AppAudioHandler(audioPlayer),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.music4.app.channel.audio',
      androidNotificationChannelName: 'Music4 Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  runApp(
    ProviderScope(
      overrides: [
        audioPlayerProvider.overrideWithValue(audioPlayer),
        audioHandlerProvider.overrideWithValue(audioHandler),
      ],
      child: const Music4App(),
    ),
  );
}

class Music4App extends StatelessWidget {
  const Music4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Music4',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
