import 'package:flutter/material.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String? categoryId;
  const CategoryDetailScreen({super.key, this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thể loại #${categoryId ?? "Pop"}')),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text('Bài hát thuộc thể loại #${index + 1}'),
            subtitle: const Text('Nghệ sĩ thể hiện'),
            trailing: const Icon(Icons.play_arrow),
          );
        },
      ),
    );
  }
}
