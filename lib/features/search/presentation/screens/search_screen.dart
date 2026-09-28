import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/search_provider.dart';
import '../providers/voice_search_provider.dart';
import '../../data/models/search_models.dart'; // Bắt buộc phải import model

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
    final hasPermission = await ref
        .read(voiceSearchProvider.notifier)
        .checkAndRequestPermission();

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
        final text = ref.read(voiceSearchProvider).recognizedWords;
        if (text.trim().isNotEmpty) {
          _searchController.text = text;
          ref.read(searchProvider.notifier).onSearchChanged(text);
        }
      });
    }
  }

  // Đã di chuyển _buildSectionTitle vào ĐÚNG VỊ TRÍ (bên trong _SearchScreenState)
  Widget _buildSectionTitle(
    String title,
    List<SearchItem>? items,
    IconData icon,
  ) {
    if (items == null || items.isEmpty) return const SizedBox.shrink();

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
        ...items.map(
          (item) => Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: ListTile(
              leading: Icon(icon),
              title: Text(item.name),
              trailing: const Icon(Icons.chevron_right, size: 20),
            ),
          ),
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.errorMessage)));
      }
    });

    ref.listen<VoiceState>(voiceSearchProvider, (previous, next) {
      if (previous?.isListening == true && next.isListening == false) {
        if (_isVoiceSheetOpen && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm'), centerTitle: true),
      body: Padding(
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
                        ),
                      if (currentType == 'all' || currentType == 'album')
                        _buildSectionTitle(
                          'Album',
                          response.albums?.content,
                          Icons.album,
                        ),
                      if (currentType == 'all' || currentType == 'artist')
                        _buildSectionTitle(
                          'Nghệ sĩ',
                          response.artists?.content,
                          Icons.person,
                        ),
                      if (currentType == 'all' || currentType == 'category')
                        _buildSectionTitle(
                          'Thể loại',
                          response.categories?.content,
                          Icons.category,
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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
