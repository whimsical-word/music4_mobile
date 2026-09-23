import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo (Notifications)')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.card,
              child: Icon(Icons.notifications, color: AppColors.primary),
            ),
            title: Text('Nghệ sĩ yêu thích vừa phát hành bài hát mới #${index + 1}'),
            subtitle: const Text('20 phút trước'),
            trailing: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }
}
