import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../search/data/models/search_models.dart';
import '../../../search/presentation/providers/search_provider.dart';

class CollabArtistSearchField extends ConsumerStatefulWidget {
  final List<SearchItem> selectedArtists;
  final ValueChanged<SearchItem> onArtistAdded;
  final ValueChanged<SearchItem> onArtistRemoved;
  final int? currentArtistId;
  final bool enabled;

  const CollabArtistSearchField({
    super.key,
    required this.selectedArtists,
    required this.onArtistAdded,
    required this.onArtistRemoved,
    this.currentArtistId,
    this.enabled = true,
  });

  @override
  ConsumerState<CollabArtistSearchField> createState() =>
      _CollabArtistSearchFieldState();
}

class _CollabArtistSearchFieldState
    extends ConsumerState<CollabArtistSearchField> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  List<SearchItem> _suggestions = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _suggestions = [];
        _isSearching = false;
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        final repo = ref.read(searchRepositoryProvider);
        final response = await repo.search(
          trimmed,
          type: 'artist',
          page: 0,
          size: 10,
        );

        if (!mounted) return;

        final rawList = response.artists?.content ?? [];
        final filtered = rawList.where((item) {
          // Loại bỏ chính ca sĩ hiện tại (chủ bài hát)
          if (widget.currentArtistId != null &&
              item.id == widget.currentArtistId) {
            return false;
          }
          // Loại bỏ các ca sĩ đã được chọn trước đó
          if (widget.selectedArtists.any((a) => a.id == item.id)) {
            return false;
          }
          return true;
        }).toList();

        setState(() {
          _suggestions = filtered;
          _isSearching = false;
          _hasSearched = true;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _suggestions = [];
          _isSearching = false;
          _hasSearched = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Danh sách các ca sĩ hợp tác đã chọn
        if (widget.selectedArtists.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedArtists.map((artist) {
              final resolvedImg = ImageUrlHelper.resolve(artist.img);
              return Chip(
                avatar: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  backgroundImage:
                      resolvedImg != null ? NetworkImage(resolvedImg) : null,
                  child: resolvedImg == null
                      ? Text(
                          artist.name.isNotEmpty
                              ? artist.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                label: Text(
                  artist.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                deleteIcon: const Icon(
                  Icons.close,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                onDeleted: widget.enabled
                    ? () => widget.onArtistRemoved(artist)
                    : null,
                backgroundColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
        ],

        // Ô tìm kiếm ca sĩ hợp tác từ hệ thống
        TextField(
          controller: _searchController,
          focusNode: _focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: 'Ca sĩ hợp tác (Tìm theo tên nghệ sĩ)',
            hintText: 'Nhập tên nghệ sĩ để tìm kiếm...',
            prefixIcon: const Icon(Icons.person_search),
            suffixIcon: _isSearching
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : (_searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 18,
                          color: AppColors.textMuted,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _suggestions = [];
                            _hasSearched = false;
                          });
                        },
                      )
                    : null),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: AppColors.card,
          ),
          onChanged: _onQueryChanged,
        ),

        // Danh sách gợi ý từ Elasticsearch
        if (_suggestions.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _suggestions.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: AppColors.divider),
                itemBuilder: (context, index) {
                  final artist = _suggestions[index];
                  final resolvedImg = ImageUrlHelper.resolve(artist.img);
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.surface,
                      backgroundImage:
                          resolvedImg != null ? NetworkImage(resolvedImg) : null,
                      child: resolvedImg == null
                          ? const Icon(
                              Icons.person,
                              size: 18,
                              color: AppColors.textMuted,
                            )
                          : null,
                    ),
                    title: Text(
                      artist.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'ID: #${artist.id}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.add_circle_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    onTap: () {
                      widget.onArtistAdded(artist);
                      _searchController.clear();
                      setState(() {
                        _suggestions = [];
                        _hasSearched = false;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ] else if (_hasSearched &&
            _searchController.text.trim().isNotEmpty &&
            !_isSearching) ...[
          Container(
            margin: const EdgeInsets.only(top: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Không tìm thấy nghệ sĩ "${_searchController.text.trim()}" trên hệ thống.',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
