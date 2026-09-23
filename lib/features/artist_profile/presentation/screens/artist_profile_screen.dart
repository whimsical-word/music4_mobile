import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ArtistProfileScreen extends StatelessWidget {
  final String? artistId;
  const ArtistProfileScreen({super.key, this.artistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang Nghệ Sĩ')),
      body: ListView(
        children: [
          Container(
            height: 200,
            color: AppColors.card,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 50, backgroundColor: AppColors.primary, child: Icon(Icons.person, size: 50, color: Colors.black)),
                  const SizedBox(height: 12),
                  Text('Nghệ sĩ #${artistId ?? "1"}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: const Text('Theo dõi (Follow)'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Bài hát phổ biến', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text('Track #${index + 1} của nghệ sĩ'),
                trailing: const Icon(Icons.play_arrow),
              );
            },
          ),
        ],
      ),
    );
  }
}
