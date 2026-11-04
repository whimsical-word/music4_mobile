import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/route_names.dart';
import '../providers/player_provider.dart';

bool _isPreviewDialogShowing = false;

/// Hiển thị popup thông báo đăng nhập khi hết 30s nghe thử bài hát.
void showPreviewEndedDialog(BuildContext context, WidgetRef ref) {
  if (_isPreviewDialogShowing) return;
  _isPreviewDialogShowing = true;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) {
      _isPreviewDialogShowing = false;
      return;
    }

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
              Navigator.of(dialogContext, rootNavigator: true).pop();
              ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
            },
            child: const Text('Để sau', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
              appRouter.push(RouteNames.login);
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
      _isPreviewDialogShowing = false;
      ref.read(playerNotifierProvider.notifier).dismissLoginPrompt();
    });
  });
}
