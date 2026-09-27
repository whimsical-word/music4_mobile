import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if(mounted) setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              HapticFeedback.lightImpact(); 
              // TODO: Tuần 2 Voice Search
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading ? _buildShimmer(constraints) : const Center(child: Text('Data loaded (Empty State)')),
          );
        }
      ),
    );
  }

  Widget _buildShimmer(BoxConstraints constraints) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.grey[600]!,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          child: SizedBox(height: 80, width: constraints.maxWidth),
        ),
      ),
    );
  }
}