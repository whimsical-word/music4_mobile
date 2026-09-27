import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/select_playlist_modal.dart';
import '../widgets/track_action_bar.dart';
import '../widgets/track_comment_section.dart';
import '../widgets/track_header_info.dart';

class TrackDetailScreen extends StatefulWidget {
  final String? trackId;

  const TrackDetailScreen({super.key, this.trackId});

  @override
  State<TrackDetailScreen> createState() => _TrackDetailScreenState();
}

class _TrackDetailScreenState extends State<TrackDetailScreen> {
  bool _isLiked = false;
  int _userRating = 5;
  late final List<TrackCommentItem> _comments;

  @override
  void initState() {
    super.initState();
    _comments = [
      const TrackCommentItem(
        username: 'Đan Quỳnh',
        content: 'Giai điệu cuốn thật sự, nghe đi nghe lại không chán!',
        timeAgo: '2 phút trước',
      ),
      const TrackCommentItem(
        username: 'Minh Nhựt',
        content: 'Bass đánh căng, mix & master đỉnh chóp.',
        timeAgo: '15 phút trước',
      ),
      const TrackCommentItem(
        username: 'Trung Kiên',
        content: 'Phần điệp khúc nghe rất cảm xúc.',
        timeAgo: '1 giờ trước',
      ),
      const TrackCommentItem(
        username: 'Hữu Tài',
        content: 'Bài này đưa vào playlist chill đêm là hết ý.',
        timeAgo: '3 giờ trước',
      ),
    ];
  }

  void _toggleLike() {
    setState(() => _isLiked = !_isLiked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isLiked
              ? '❤️ Đã thêm vào bài hát yêu thích'
              : 'Đã xóa khỏi bài hát yêu thích',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addToPlaylist() {
    SelectPlaylistModal.show(context, (playlistName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Đã thêm bài hát vào "$playlistName"'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _shareTrack() {
    final trackId = widget.trackId ?? '1';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🔗 Đã sao chép link chia sẻ bài hát (music4://track/$trackId)',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _addComment(String text) {
    setState(() {
      _comments.insert(
        0,
        TrackCommentItem(
          username: 'Bạn (Người nghe)',
          content: text,
          timeAgo: 'Vừa xong',
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đăng bình luận thành công!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trackId = widget.trackId ?? '1';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bài hát #$trackId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Chia sẻ',
            onPressed: () {
              HapticFeedback.lightImpact();
              _shareTrack();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          TrackHeaderInfo(
            title: 'Chúng Ta Của Hiện Tại #$trackId',
            artist: 'Sơn Tùng M-TP',
            genre: 'Pop / R&B',
            duration: '05:01',
            views: '12.5M lượt nghe',
            onPlay: () => context.push(RouteNames.player),
          ),
          const SizedBox(height: 16),
          TrackActionBar(
            isLiked: _isLiked,
            rating: _userRating,
            onLikeToggle: _toggleLike,
            onAddToPlaylist: _addToPlaylist,
            onShare: _shareTrack,
            onRatingChanged: (newRating) {
              setState(() => _userRating = newRating);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('⭐ Đã đánh giá $newRating sao'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.divider),
          TrackCommentSection(comments: _comments, onAddComment: _addComment),
        ],
      ),
    );
  }
}
