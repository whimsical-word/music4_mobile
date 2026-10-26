import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/track_comment_model.dart';

class ReportCommentBottomSheet extends StatefulWidget {
  final TrackCommentModel comment;
  final void Function(String reason, String? description) onSubmit;

  const ReportCommentBottomSheet({
    super.key,
    required this.comment,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required TrackCommentModel comment,
    required void Function(String reason, String? description) onSubmit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          ReportCommentBottomSheet(comment: comment, onSubmit: onSubmit),
    );
  }

  @override
  State<ReportCommentBottomSheet> createState() =>
      _ReportCommentBottomSheetState();
}

class _ReportCommentBottomSheetState extends State<ReportCommentBottomSheet> {
  static const List<String> _reasons = [
    'Spam hoặc quảng cáo rác',
    'Ngôn từ thù ghét, xúc phạm',
    'Quấy rối hoặc bắt nạt',
    'Nội dung phản cảm, không phù hợp',
    'Thông tin sai lệch, lừa đảo',
    'Lý do khác',
  ];

  String _selectedReason = _reasons.first;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _handleSend() {
    HapticFeedback.mediumImpact();
    final note = _noteController.text.trim();
    Navigator.of(context).pop();
    widget.onSubmit(_selectedReason, note.isEmpty ? null : note);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thanh kéo (Drag handle)
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tiêu đề
            const Row(
              children: [
                Icon(Icons.flag_rounded, color: AppColors.error, size: 22),
                SizedBox(width: 8),
                Text(
                  'Báo cáo bình luận vi phạm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Bình luận của "${widget.comment.commenterName}": "${widget.comment.content}"',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: AppColors.divider),

            // Danh sách lý do
            ..._reasons.map((reason) {
              final isSelected = _selectedReason == reason;
              return RadioListTile<String>(
                value: reason,
                groupValue: _selectedReason,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                dense: true,
                title: Text(
                  reason,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedReason = val);
                  }
                },
              );
            }),

            // Ô nhập chi tiết nếu chọn "Lý do khác"
            if (_selectedReason == 'Lý do khác') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  hintText: 'Mô tả chi tiết hành vi vi phạm...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Nút hành động
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Gửi báo cáo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
