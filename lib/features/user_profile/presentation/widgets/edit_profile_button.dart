import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music4_mobile/features/user_profile/domain/models/user_profile.dart';
import 'package:music4_mobile/features/user_profile/presentation/widgets/edit_profile_dialog.dart';

import '../../../../core/theme/app_colors.dart';

class EditProfileButton extends ConsumerWidget {
  final UserProfile profile;

  const EditProfileButton({super.key, required this.profile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: const Icon(Icons.edit_outlined),
        label: const Text(
          'Chỉnh sửa hồ sơ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        onPressed: () => showEditProfileDialog(
          context,
          ref,
          currentName: profile.displayName,
          currentGender: profile.gender,
          imageUrl: profile.avatarUrl,
        ),
      ),
    );
  }
}
