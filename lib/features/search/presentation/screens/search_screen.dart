import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../../player/domain/models/player_state_data.dart';
import '../../../player/presentation/providers/player_provider.dart';
import '../../../player/presentation/widgets/mini_player_widget.dart';
import '../providers/search_provider.dart';
import '../providers/voice_search_provider.dart';
import '../../data/models/search_models.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isVoiceSheetOpen = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openVoiceSearchBottomSheet() async {
    HapticFeedback.lightImpact();
    final hasPermission = await ref.read(voiceSearchProvider.notifier).checkAndRequestPermission();

    if (!hasPermission) return;

    ref.read(voiceSearchProvider.notifier).startListening();
    _isVoiceSheetOpen = true;

    if (mounted) {
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) => const VoiceSearchBottomSheet(),
      ).then((_) {
        _isVoiceSheetOpen = false;
        
        // FIX MERGE CONFLICT: Ép buộc dọn dẹp luồng Mic ngay khi đóng BottomSheet
        ref.read(voiceSearchProvider.notifier).stopListening();

        final text = ref.read(voiceSearchProvider).recognizedWords;
        if (text.trim().isNotEmpty) {
          _searchController.text = text;
          ref.read(searchProvider.notifier).onSearchChanged(text);
        }
      });
    }
  }
  Widget _buildSectionTitle(
    String title,
    List<SearchItem>? items,
    IconData icon, {
    void Function(SearchItem item, int index)? onItemTap,
  }) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();

    final isArtist = title == 'Nghệ sĩ';
    final isTrack = title == 'Bài hát';
    final isAlbum = title == 'Album';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final item = entry.value;
            final resolvedImg = ImageUrlHelper.resolve(item.img);

            Widget leadingWidget;
            if (isArtist) {
              leadingWidget = resolvedImg != null && resolvedImg.isNotEmpty
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(resolvedImg),
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Icon(
                        icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
            } else if (isTrack || isAlbum) {
              leadingWidget = resolvedImg != null && resolvedImg.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: resolvedImg,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 48,
                          height: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Icon(icon, size: 24),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 48,
                          height: 48,
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: Icon(icon, size: 24),
                        ),
                      ),
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(icon, size: 24),
                    );
            } else {
              leadingWidget = Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 24),
              );
            }

            String? subtitleText;
            if (isTrack) {
              subtitleText = item.artistNames;
            } else if (isAlbum) {
              subtitleText = 'Album';
            } else if (isArtist) {
              subtitleText = 'Nghệ sĩ';
            }

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: ListTile(
                leading: leadingWidget,
                title: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: subtitleText != null
                    ? Text(
                        subtitleText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: onItemTap != null ? () => onItemTap(item, index) : null,
              ),
            );
          },
        ),
        const Divider(height: 24),
      ],
    );
  }

  final Map<String, String> _filterTypes = const {
    'all': 'Tất cả',
    'track': 'Bài hát',
    'artist': 'Nghệ sĩ',
    'album': 'Album',
    'category': 'Thể loại',
  };

  Widget _buildFilterChips(WidgetRef ref) {
    final currentType = ref.watch(searchTypeProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: _filterTypes.entries.map((entry) {
          final isSelected = currentType == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected && !isSelected) {
                  ref.read(searchTypeProvider.notifier).state = entry.key;
                  ref.read(searchProvider.notifier).refreshSearch();
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final currentType = ref.watch(searchTypeProvider);

    ref.listen<VoiceState>(voiceSearchProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty &&
          next.errorMessage != previous?.errorMessage) {
        
        // 1. BẮT BUỘC: Đóng ngay Dialog/BottomSheet bị kẹt
        if (_isVoiceSheetOpen && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }

        // 2. BẮT BUỘC: Sau đó mới gọi ScaffoldMessenger hiển thị lỗi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 3. BẮT BUỘC: Reset State ngay lập tức để tránh vòng lặp Spam SnackBar ở lần build sau
        Future.microtask(() => ref.read(voiceSearchProvider.notifier).clearError());
      }
    });

    ref.listen<VoiceState>(voiceSearchProvider, (previous, next) {
      if (previous?.isListening == true && next.isListening == false && next.errorMessage.isEmpty) {
        if (_isVoiceSheetOpen && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) =>
                  ref.read(searchProvider.notifier).onSearchChanged(value),
              decoration: InputDecoration(
                hintText: 'Bài hát, nghệ sĩ, lời bài hát...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.mic,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: _openVoiceSearchBottomSheet,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest,
              ),
            ),
            _buildFilterChips(ref),
            Expanded(
              child: searchState.when(
                loading: () => _buildShimmerLoading(),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => ref
                            .read(searchProvider.notifier)
                            .onSearchChanged(_searchController.text),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
                data: (response) {
                  if (response == null) {
                    return const Center(
                      child: Text('Nhập từ khóa hoặc dùng Voice Search...'),
                    );
                  }

                  final bool isEmpty =
                      (response.tracks?.content.isEmpty ?? true) &&
                      (response.albums?.content.isEmpty ?? true) &&
                      (response.artists?.content.isEmpty ?? true) &&
                      (response.categories?.content.isEmpty ?? true);

                  if (isEmpty) {
                    return const Center(
                      child: Text('Không tìm thấy kết quả phù hợp.'),
                    );
                  }

                  return ListView(
                    children: [
                      if (currentType == 'all' || currentType == 'track')
                        _buildSectionTitle(
                          'Bài hát',
                          response.tracks?.content,
                          Icons.music_note,
                          onItemTap: (item, index) {
                            HapticFeedback.lightImpact();
                            final tracks = response.tracks?.content ?? [];
                            final queue = tracks
                                .map(
                                  (t) => TrackQueueItem(
                                    id: t.id.toString(),
                                    title: t.name,
                                    artist: t.artistNames,
                                    coverUrl: ImageUrlHelper.resolve(t.img),
                                    duration:
                                        Duration(seconds: t.duration ?? 0),
                                  ),
                                )
                                .toList();

                            ref
                                .read(playerNotifierProvider.notifier)
                                .playPlaylist(queue, index);
                            context.push(RouteNames.player);
                          },
                        ),
                      if (currentType == 'all' || currentType == 'album')
                        _buildSectionTitle(
                          'Album',
                          response.albums?.content,
                          Icons.album,
                          onItemTap: (item, index) {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tính năng chi tiết Album đang được phát triển.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      if (currentType == 'all' || currentType == 'artist')
                        _buildSectionTitle(
                          'Nghệ sĩ',
                          response.artists?.content,
                          Icons.person,
                          onItemTap: (item, index) {
                            HapticFeedback.lightImpact();
                            context.push('/artist/${item.id}');
                          },
                        ),
                      if (currentType == 'all' || currentType == 'category')
                        _buildSectionTitle(
                          'Thể loại',
                          response.categories?.content,
                          Icons.category,
                          onItemTap: (item, index) {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Tính năng chi tiết Thể loại đang được phát triển.',
                                ),
                                behavior: SnackBarBehavior.floating,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
    const MiniPlayerWidget(),
  ],
),
);
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}

class VoiceSearchBottomSheet extends ConsumerWidget {
  const VoiceSearchBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final voiceState = ref.watch(voiceSearchProvider);

    return Container(
      padding: const EdgeInsets.all(32),
      height: 380,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ActionChip(
            avatar: Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.primary,
              size: 18,
            ),
            label: Text(
              voiceState.isEnglishMode
                  ? 'Đang nghe: Tiếng Anh'
                  : 'Đang nghe: Tiếng Việt',
            ),
            onPressed: () {
              ref.read(voiceSearchProvider.notifier).toggleLanguage();
            },
          ),
          const SizedBox(height: 16),
          IconButton(
            iconSize: 80,
            icon: Icon(
              voiceState.isListening ? Icons.mic : Icons.mic_none,
              color: voiceState.isListening ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (voiceState.isListening) {
                ref.read(voiceSearchProvider.notifier).stopListening();
              } else {
                ref.read(voiceSearchProvider.notifier).startListening();
              }
            },
          ),
          const SizedBox(height: 16),
          Text(
            voiceState.isListening ? 'Hãy nói tên bài hát...' : 'Đã xử lý xong',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            voiceState.recognizedWords.isEmpty
                ? '(Hệ thống tự ngắt sau 3 giây)'
                : voiceState.recognizedWords,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: voiceState.recognizedWords.isEmpty
                  ? Colors.grey
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () {
              ref.read(voiceSearchProvider.notifier).cancelSearch();
            },
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }
}
