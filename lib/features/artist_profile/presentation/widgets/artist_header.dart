import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/artist.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;
  final bool isFollowing;
  final bool showFollowButton;
  final VoidCallback onToggleFollow;

  const ArtistHeader({
    super.key,
    required this.artist,
    required this.isFollowing,
    this.showFollowButton = true,
    required this.onToggleFollow,
  });

  String _formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _avatarFallback() {
    return const SizedBox(
      width: 92,
      height: 92,
      child: Icon(Icons.person, size: 40, color: AppColors.textMuted),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cover & Avatar
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 160,
              width: double.infinity,
              color: AppColors.card,
              // Solid colour when the artist has no cover or it fails to load.
              child: artist.coverUrl == null
                  ? Container(color: AppColors.surface)
                  : Image.network(
                      artist.coverUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(color: AppColors.surface),
                    ),
            ),
            Positioned(
              bottom: -50,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.background,
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: AppColors.card,
                  child: ClipOval(
                    child: artist.avatarUrl == null
                        ? _avatarFallback()
                        : Image.network(
                            artist.avatarUrl!,
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _avatarFallback(),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 60),
        
        // Info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Text(
                artist.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                textAlign: TextAlign.center,
              ),
              if (artist.followersCount != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${_formatFollowers(artist.followersCount!)} Người theo dõi',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
              const SizedBox(height: 16),
              
              // Follow Button
              if (showFollowButton)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: isFollowing ? AppColors.surface : AppColors.primary,
                      foregroundColor: isFollowing ? AppColors.textPrimary : Colors.black,
                    ),
                    onPressed: onToggleFollow,
                    icon: Icon(isFollowing ? Icons.check : Icons.person_add),
                    label: Text(isFollowing ? 'Đang theo dõi' : 'Theo dõi'),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
