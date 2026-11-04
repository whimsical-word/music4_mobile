import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../album/data/models/album_model.dart';
import '../../../search/data/models/search_models.dart';
import '../../data/models/category_model.dart';
import 'collab_artist_search_field.dart';

class UploadFormFields extends StatelessWidget {
  final TextEditingController titleController;
  final bool isUploading;
  final CategoryModel? selectedCategory;
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel?> onCategoryChanged;
  final int? selectedAlbumId;
  final List<AlbumModel> albums;
  final ValueChanged<int?> onAlbumChanged;
  final List<SearchItem> selectedCollabArtists;
  final ValueChanged<SearchItem> onCollabArtistAdded;
  final ValueChanged<SearchItem> onCollabArtistRemoved;
  final int? currentArtistId;

  const UploadFormFields({
    super.key,
    required this.titleController,
    required this.isUploading,
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
    required this.selectedAlbumId,
    required this.albums,
    required this.onAlbumChanged,
    required this.selectedCollabArtists,
    required this.onCollabArtistAdded,
    required this.onCollabArtistRemoved,
    this.currentArtistId,
  });

  @override
  Widget build(BuildContext context) {
    // Xây dựng danh sách dropdown các Album của riêng người nghệ sĩ
    final List<DropdownMenuItem<int?>> albumDropdownItems = [
      const DropdownMenuItem<int?>(
        value: null,
        child: Row(
          children: [
            Icon(Icons.music_note, size: 18, color: AppColors.textMuted),
            SizedBox(width: 8),
            Text('Single (Không thuộc Album nào)'),
          ],
        ),
      ),
      ...albums.map((alb) {
        final albId = int.tryParse(alb.id);
        return DropdownMenuItem<int?>(
          value: albId,
          child: Row(
            children: [
              const Icon(Icons.album_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  alb.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (alb.trackCount > 0)
                Text(
                  ' (${alb.trackCount} bài)',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
            ],
          ),
        );
      }),
    ];

    // Tránh lỗi assert của DropdownButton nếu selectedAlbumId chưa kịp nạp vào danh sách albums
    if (selectedAlbumId != null &&
        !albumDropdownItems.any((item) => item.value == selectedAlbumId)) {
      albumDropdownItems.add(
        DropdownMenuItem<int?>(
          value: selectedAlbumId,
          child: Row(
            children: [
              const Icon(Icons.album_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Album #$selectedAlbumId'),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tên bài hát (Title)
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

        // Thể loại (Category)
        DropdownButtonFormField<CategoryModel>(
          initialValue: selectedCategory,
          decoration: InputDecoration(
            labelText: 'Thể loại (Category)',
            hintText: 'Chọn thể loại nhạc',
            prefixIcon: const Icon(Icons.category),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
          items: categories
              .map((cat) => DropdownMenuItem<CategoryModel>(
                    value: cat,
                    child: Text('${cat.name} (ID: ${cat.id})'),
                  ))
              .toList(),
          onChanged: isUploading ? null : onCategoryChanged,
        ),
        const SizedBox(height: 16),

        // Ca sĩ hợp tác (Tìm theo tên nghệ sĩ & chọn từ gợi ý Elasticsearch)
        CollabArtistSearchField(
          selectedArtists: selectedCollabArtists,
          onArtistAdded: onCollabArtistAdded,
          onArtistRemoved: onCollabArtistRemoved,
          currentArtistId: currentArtistId,
          enabled: !isUploading,
        ),
        const SizedBox(height: 16),

        // Gán vào Album (Dropdown chọn Album khả dụng của riêng nghệ sĩ sở hữu)
        DropdownButtonFormField<int?>(
          key: ValueKey(selectedAlbumId),
          initialValue: selectedAlbumId,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Gán vào Album (Tùy chọn)',
            hintText: 'Chọn Album của bạn',
            prefixIcon: const Icon(Icons.album),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
          items: albumDropdownItems,
          onChanged: isUploading ? null : onAlbumChanged,
        ),
      ],
    );
  }
}
