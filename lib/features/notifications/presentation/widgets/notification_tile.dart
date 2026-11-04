import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData get _icon => switch (notification.type) {
    NotificationType.newTrack => Icons.music_note_rounded,
    NotificationType.newAlbum => Icons.album_rounded,
    NotificationType.system => Icons.notifications_active_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isRead = notification.isRead;
    final timeStr = DateFormat('dd/MM/yyyy HH:mm').format(
      notification.createdAt,
    );

    return Material(
      // Chưa đọc: nền nổi bật. Đã đọc: trong suốt.
      color: isRead
          ? Colors.transparent
          : colorScheme.primary.withValues(alpha: 0.12),
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: isRead ? 0.6 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(_icon, color: colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(child: _buildBody(theme, timeStr)),
                if (!isRead) _buildUnreadDot(colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, String timeStr) {
    final isRead = notification.isRead;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          notification.content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          timeStr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }

  Widget _buildUnreadDot(ColorScheme colorScheme) => Container(
    margin: const EdgeInsets.only(top: 8, left: 8),
    width: 12,
    height: 12,
    decoration: BoxDecoration(
      color: colorScheme.primary,
      shape: BoxShape.circle,
    ),
  );
}
