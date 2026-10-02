import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/player_provider.dart';
import '../widgets/music_player_body.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  bool _isShuffle = false;
  bool _isRepeat = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  void _onPlayPause(bool isPlaying) {
    HapticFeedback.lightImpact();
    final notifier = ref.read(playerNotifierProvider.notifier);
    isPlaying ? notifier.pause() : notifier.play();
  }

  @override
  Widget build(BuildContext context) {
    final playerStateAsync = ref.watch(playerNotifierProvider);

    ref.listen(playerNotifierProvider, (prev, next) {
      if (next is AsyncData) {
        next.value!.isPlaying ? _spinController.repeat() : _spinController.stop();

      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => context.pop(),
        ),
        title: const Text('Đang phát'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => context.push('/track/1'),
          ),
        ],
      ),
      body: playerStateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (state) => MusicPlayerBody(
          state: state,
          spinController: _spinController,
          isShuffle: _isShuffle,
          isRepeat: _isRepeat,
          onPlayPause: () => _onPlayPause(state.isPlaying),
          onShuffle: () => setState(() => _isShuffle = !_isShuffle),
          onRepeat: () => setState(() => _isRepeat = !_isRepeat),
          onNext: () => ref.read(playerNotifierProvider.notifier).next(),
          onPrevious: () => ref.read(playerNotifierProvider.notifier).previous(),
          onSeek: (val) {
            ref.read(playerNotifierProvider.notifier).seek(Duration(seconds: val.toInt()));
          },
        ),
      ),
    );
  }
}
