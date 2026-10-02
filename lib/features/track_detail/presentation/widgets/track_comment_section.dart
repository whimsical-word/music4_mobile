import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/image_url_helper.dart';
import '../../data/models/track_comment_model.dart';

class TrackCommentSection extends StatefulWidget {
  final List<TrackCommentModel> comments;
  final int? currentUserId;
  final String? currentUsername;
  final String? currentDisplayName;
  final ValueChanged<String> onAddComment;
  final void Function(int commentId, String newContent)? onEditComment;
  final void Function(int commentId)? onDeleteComment;

  const TrackCommentSection({
    super.key,
    required this.comments,
    this.currentUserId,
    this.currentUsername,
    this.currentDisplayName,
    required this.onAddComment,
    this.onEditComment,
    this.onDeleteComment,
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

  bool _isMyComment(TrackCommentModel comment) {
    bool isMatch = false;
    String reason = 'Không khớp';

    // 1. So khớp theo ID nếu cả 2 bên đều có thông tin userId
    if (widget.currentUserId != null && comment.userId != null) {
      if (comment.userId == widget.currentUserId) {
        isMatch = true;
        reason = 'Trùng userId (${comment.userId} == ${widget.currentUserId})';
      }
    }

    // 2. So khớp theo tên hiển thị (Backend Commenter Name = user.getName())
    if (!isMatch) {
      final trimmedCommenter = comment.commenterName.trim().toLowerCase();
      if (widget.currentDisplayName != null &&
          widget.currentDisplayName!.trim().isNotEmpty) {
        if (trimmedCommenter == widget.currentDisplayName!.trim().toLowerCase()) {
          isMatch = true;
          reason = 'Trùng displayName ("${comment.commenterName}" == "${widget.currentDisplayName}")';
        }
      }

      // 3. So khớp theo username / login handle (JWT subject)
      if (!isMatch &&
          widget.currentUsername != null &&
          widget.currentUsername!.trim().isNotEmpty) {
        if (trimmedCommenter == widget.currentUsername!.trim().toLowerCase()) {
          isMatch = true;
          reason = 'Trùng username ("${comment.commenterName}" == "${widget.currentUsername}")';
        }
      }
    }

    // 4. Dự phòng khi chưa đồng bộ được state đăng nhập: nếu ID bình luận là 1
    if (!isMatch && widget.currentUserId == null && comment.userId == 1) {
      isMatch = true;
      reason = 'Dự phòng fallback: currentUserId đang null và comment.userId == 1';
    }

    debugPrint(
      '🔍 [SO SÁNH BÌNH LUẬN] '
      'ID bình luận: ${comment.commentId} | '
      'comment.userId: ${comment.userId} | '
      'currentUserId: ${widget.currentUserId} | '
      'Tên người bình luận: "${comment.commenterName}" | '
      'Tên tài khoản hiện tại: "${widget.currentDisplayName}" | '
      'KẾT QUẢ: ${isMatch ? "✅ CHÍNH CHỦ ($reason)" : "❌ KHÔNG PHẢI ($reason)"}',
    );

    return isMatch;
  }

  void _showEditDialog(TrackCommentModel comment) {
    final editController = TextEditingController(text: comment.content);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Chỉnh sửa bình luận',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: editController,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Nhập nội dung mới...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final newContent = editController.text.trim();
              if (newContent.isNotEmpty && newContent != comment.content) {
                widget.onEditComment?.call(comment.commentId, newContent);
              }
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(TrackCommentModel comment) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: const Text('Bạn có chắc chắn muốn xóa bình luận này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              widget.onDeleteComment?.call(comment.commentId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.surface,
                child: Icon(Icons.person, size: 20, color: AppColors.textSecondary),
              ),
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
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ],
          ),
        ),
        if (widget.comments.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Center(
              child: Text(
                'Chưa có bình luận nào. Hãy là người đầu tiên chia sẻ cảm nghĩ!',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              final hasAvatar = comment.commenterImg != null &&
                  comment.commenterImg!.isNotEmpty;
              final avatarUrl = hasAvatar
                  ? ImageUrlHelper.resolve(comment.commenterImg)
                  : null;
              final isMine = _isMyComment(comment);

              return ListTile(
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.card,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null
                      ? Text(
                          comment.commenterName.isNotEmpty
                              ? comment.commenterName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.commenterName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isMine) ...[
                      InkWell(
                        onTap: () => _showEditDialog(comment),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            'Sửa',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '•',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                      InkWell(
                        onTap: () => _showDeleteDialog(comment),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            'Xóa',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      comment.formattedTimeAgo,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    comment.content,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
