import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';

class TrackCommentItem {
  final String username;
  final String content;
  final String timeAgo;

  const TrackCommentItem({
    required this.username,
    required this.content,
    required this.timeAgo,
  });
}

class TrackCommentSection extends StatefulWidget {
  final List<TrackCommentItem> comments;
  final ValueChanged<String> onAddComment;

  const TrackCommentSection({
    super.key,
    required this.comments,
    required this.onAddComment,
  });

  @override
  State<TrackCommentSection> createState() => _TrackCommentSectionState();
}

class _TrackCommentSectionState extends State<TrackCommentSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      HapticFeedback.lightImpact();
      widget.onAddComment(text);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'Bình luận (${widget.comments.length})',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: AppColors.surface, child: Icon(Icons.person, size: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Thêm bình luận...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                      onPressed: _submit,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (context, index) {
            final comment = widget.comments[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.card,
                child: Text(comment.username[0].toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              title: Text(comment.username, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              subtitle: Text(comment.content, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              trailing: Text(comment.timeAgo, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            );
          },
        ),
      ],
    );
  }
}
