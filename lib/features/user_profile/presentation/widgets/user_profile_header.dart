import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/user_profile.dart';

/// Collapsible header with cover banner, avatar, name, bio and stats.
/// Mirrors the pattern of [ArtistHeader] from artist_profile feature.
class UserProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const UserProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Cover banner + floating avatar ──────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Gradient banner (replaces cover image — user has no cover)
            Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1DB954), Color(0xFF121212)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Avatar
            Positioned(
              bottom: -50,
              child: CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.background,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.card,
                  backgroundImage: profile.avatarUrl.isNotEmpty
                      ? NetworkImage(profile.avatarUrl)
                      : null,
                  onBackgroundImageError: profile.avatarUrl.isNotEmpty
                      ? (_, _) {}
                      : null,
                  child: profile.avatarUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.textMuted,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 62),

        // ── Name, email, bio ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Text(
                profile.displayName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
              if (profile.bio.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  profile.bio,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 20),

              // ── Stats row ─────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatChip(
                    value: profile.followingCount.toString(),
                    label: 'Đang theo dõi',
                  ),
                  Container(width: 1, height: 36, color: AppColors.divider),
                  _StatChip(
                    value: profile.playlistCount.toString(),
                    label: 'Playlist',
                  ),
                  Container(width: 1, height: 36, color: AppColors.divider),
                  _StatChip(
                    value: profile.likedTracksCount.toString(),
                    label: 'Bài yêu thích',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widget
// ---------------------------------------------------------------------------

class _StatChip extends StatelessWidget {
  final String value;
  final String label;

  const _StatChip({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
