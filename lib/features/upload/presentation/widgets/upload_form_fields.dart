import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UploadFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController collabArtistsController;
  final TextEditingController albumController;
  final bool isUploading;
  final String? selectedCategory;
  final List<String> categories;
  final ValueChanged<String?> onCategoryChanged;

  const UploadFormFields({
    super.key,
    required this.titleController,
    required this.collabArtistsController,
    required this.albumController,
    required this.isUploading,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        TextField(
          controller: titleController,
          enabled: !isUploading,
          decoration: InputDecoration(
            labelText: 'Tên bài hát (Title)',
            prefixIcon: const Icon(Icons.title),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
        ),
        const SizedBox(height: 16),
        // Category
        DropdownButtonFormField<String>(
          initialValue: selectedCategory,
          decoration: InputDecoration(
            labelText: 'Thể loại (Category IDs)',
            prefixIcon: const Icon(Icons.category),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
          items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
          onChanged: isUploading ? null : onCategoryChanged,
        ),
        const SizedBox(height: 16),
        // Collab Artists
        TextField(
          controller: collabArtistsController,
          enabled: !isUploading,
          decoration: InputDecoration(
            labelText: 'Ca sĩ hợp tác (Artist IDs - Tùy chọn)',
            prefixIcon: const Icon(Icons.people),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
        ),
        const SizedBox(height: 16),
        // Album
        TextField(
          controller: albumController,
          enabled: !isUploading,
          decoration: InputDecoration(
            labelText: 'Gán vào Album (Album ID - Tùy chọn)',
            prefixIcon: const Icon(Icons.album),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
        ),
      ],
    );
  }
}
