import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [TextButton(onPressed: () {}, child: const Text('Đánh dấu đã đọc'))],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading) return _buildShimmer(constraints);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                const SizedBox(height: 16),
                const Text('Bạn không có thông báo nào.'),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildShimmer(BoxConstraints constraints) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: 8,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!, highlightColor: Colors.grey[600]!,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: const CircleAvatar(backgroundColor: Colors.white, radius: 24),
          title: Container(width: double.infinity, height: 14, color: Colors.white, margin: const EdgeInsets.only(bottom: 8)),
          subtitle: Container(width: constraints.maxWidth * 0.6, height: 12, color: Colors.white),
        ),
      ),
    );
  }
}