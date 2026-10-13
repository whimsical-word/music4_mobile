import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../providers/player_provider.dart';
import '../widgets/music_player_body.dart';

class MusicPlayerScreen extends ConsumerStatefulWidget {
 const MusicPlayerScreen({super.key});

 @override
 ConsumerState<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends ConsumerState<MusicPlayerScreen> with SingleTickerProviderStateMixin {
 late AnimationController _spinController;

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

 bool _isDialogShowing = false;

 void _showPreviewEndedDialog(BuildContext context) {
   if (_isDialogShowing || !mounted) return;
   _isDialogShowing = true;
   showDialog(
     context: context,
     barrierDismissible: true,
     builder: (dialogContext) => AlertDialog(
       backgroundColor: const Color(0xFF1E1E1E),
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
       icon: const Icon(Icons.timer_off_outlined, color: Colors.amber, size: 48),
       title: const Text(
         'Hết thời gian nghe thử',
         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
         textAlign: TextAlign.center,
       ),
       content: const Text(
         'Bạn vừa trải nghiệm xong 30 giây nghe thử. Hãy đăng nhập tài khoản để thưởng thức toàn bộ bài hát với chất lượng âm thanh cao nhất!',
         style: TextStyle(color: Colors.white70),
         textAlign: TextAlign.center,
       ),
       actionsAlignment: MainAxisAlignment.center,
       actions: [
         TextButton(
           onPressed: () {
             Navigator.pop(dialogContext);
             ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
           },
           child: const Text('Để sau', style: TextStyle(color: Colors.grey)),
         ),
         ElevatedButton(
           onPressed: () {
             Navigator.pop(dialogContext);
             ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
             context.push(RouteNames.login);
           },
           style: ElevatedButton.styleFrom(
             backgroundColor: const Color(0xFF1DB954),
             foregroundColor: Colors.black,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           ),
           child: const Text('Đăng nhập ngay', style: TextStyle(fontWeight: FontWeight.bold)),
         ),
       ],
     ),
    ).then((_) {
      _isDialogShowing = false;
      if (mounted) {
        ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
      }
    });
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

  if (next.value!.showLoginPrompt && !(prev?.value?.showLoginPrompt ?? false)) {
    _showPreviewEndedDialog(context);
  }
 }
 });

 return Scaffold(
 appBar: AppBar(
  leading: IconButton(
  icon: const Icon(Icons.keyboard_arrow_down, size: 32),
  onPressed: () => context.pop(),
  ),
  title: const Text(
    'ĐANG PHÁT',
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 1.0,
    ),
  ),
  centerTitle: true,
  actions: [
  IconButton(
  icon: const Icon(Icons.info_outline),
  onPressed: () {
              final trackId = playerStateAsync.value?.currentTrackId;
              if (trackId != null) context.push('/track/$trackId');
            },
  ),
  ],
 ),
 body: playerStateAsync.when(
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (err, _) => Center(child: Text(err.toString())),
  data: (state) => MusicPlayerBody(
  state: state,
  spinController: _spinController,
  isShuffle: state.isShuffle,
  repeatMode: state.repeatMode,
  onPlayPause: () => _onPlayPause(state.isPlaying),
  onShuffle: () => ref.read(playerNotifierProvider.notifier).toggleShuffle(),
  onRepeat: () => ref.read(playerNotifierProvider.notifier).toggleRepeat(),
  onNext: () => ref.read(playerNotifierProvider.notifier).next(),
  onPrevious: () => ref.read(playerNotifierProvider.notifier).previous(),
  onFavoriteTap: () => ref.read(playerNotifierProvider.notifier).toggleFavorite(),
          onSeek: (val) {
  ref.read(playerNotifierProvider.notifier).seek(Duration(seconds: val.toInt()));
  },
  ),
 ),
 );
 }
}



