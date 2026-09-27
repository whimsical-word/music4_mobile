import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  bool _isPlaying = false, _isShuffle = false, _isRepeat = false;
  double _currentValue = 30.0;

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

  void _togglePlayPause() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPlaying = !_isPlaying;
      _isPlaying ? _spinController.repeat() : _spinController.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => context.pop(), // Thu nhỏ player
        ),
        title: const Text('Đang phát'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Xem chi tiết bài hát',
            onPressed: () => context.push('/track/1'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VinylDiscWidget(animation: _spinController, imageUrl: 'https://picsum.photos/300'),
            const TrackInfoWidget(),
            ProgressBarWidget(currentValue: _currentValue, onChanged: (val) => setState(() => _currentValue = val)),
            PlayerControlsWidget(
              isPlaying: _isPlaying, isShuffle: _isShuffle, isRepeat: _isRepeat,
              onPlayPause: _togglePlayPause,
              onShuffle: () => setState(() => _isShuffle = !_isShuffle),
              onRepeat: () => setState(() => _isRepeat = !_isRepeat),
            ),
          ],
        ),
      ),
    );
  }
}
