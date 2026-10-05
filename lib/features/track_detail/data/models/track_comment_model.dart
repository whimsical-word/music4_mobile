class TrackCommentModel {
  final int commentId;
  final int? userId;
  final String commenterName;
  final String? commenterImg;
  final String? commenterRole;
  final String content;
  final String? createdAt;

  const TrackCommentModel({
    required this.commentId,
    this.userId,
    required this.commenterName,
    this.commenterImg,
    this.commenterRole,
    required this.content,
    this.createdAt,
  });

  factory TrackCommentModel.fromJson(Map<String, dynamic> json) {
    return TrackCommentModel(
      commentId: json['commentId'] as int? ?? 0,
      userId: json['userId'] as int?,
      commenterName: json['commenterName'] as String? ?? 'Người dùng',
      commenterImg: json['commenterImg'] as String?,
      commenterRole: json['commenterRole'] as String?,
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      if (userId != null) 'userId': userId,
      'commenterName': commenterName,
      if (commenterImg != null) 'commenterImg': commenterImg,
      if (commenterRole != null) 'commenterRole': commenterRole,
      'content': content,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  String get formattedTimeAgo {
    if (createdAt == null || createdAt!.isEmpty) return 'Vừa xong';
    try {
      final dateTime = DateTime.parse(createdAt!).toLocal();
      final diff = DateTime.now().difference(dateTime);
      if (diff.inSeconds < 60) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      if (diff.inDays < 7) return '${diff.inDays} ngày trước';
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    } catch (_) {
      return 'Gần đây';
    }
  }
}
