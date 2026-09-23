import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm bài hát, nghệ sĩ, album...',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Thể loại nổi bật (Categories)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              final titles = ['Pop', 'Rock', 'EDM', 'Hip-Hop', 'Ballad', 'Acoustic'];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(titles[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              );
            },
          ),
        ],
      ),
    );
  }
}
