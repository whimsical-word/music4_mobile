import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử nghe nhạc')),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text('Bài hát đã nghe gần đây #${index + 1}'),
            subtitle: const Text('Đã nghe 2 giờ trước'),
            trailing: const Icon(Icons.more_vert),
          );
        },
      ),
    );
  }
}
