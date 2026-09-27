import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDetailScreen extends StatefulWidget {
  final String categoryId;
  
  const CategoryDetailScreen({super.key, required this.categoryId});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
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
      appBar: AppBar(title: const Text('Chi tiết Thể loại')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading) return _buildShimmer(constraints);
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: 0, 
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) => const SizedBox.shrink(),
          );
        }
      ),
      bottomSheet: isLoading ? null : const Padding(
        padding: EdgeInsets.all(32.0),
        child: Text('Chưa có bài hát nào trong thể loại này.'),
      ),
    );
  }

  Widget _buildShimmer(BoxConstraints constraints) {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!, highlightColor: Colors.grey[600]!,
        child: Row(
          children: [
            Container(width: 56, height: 56, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: constraints.maxWidth * 0.5, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: constraints.maxWidth * 0.3, height: 12, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}