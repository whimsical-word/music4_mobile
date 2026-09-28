import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilePickerArea extends StatelessWidget {
  final bool isUploading;
  final bool isCoverSelected;
  final bool isAudioSelected;
  final VoidCallback onCoverTap;
  final VoidCallback onAudioTap;

  const FilePickerArea({
    super.key,
    required this.isUploading,
    required this.isCoverSelected,
    required this.isAudioSelected,
    required this.onCoverTap,
    required this.onAudioTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Khung ảnh bìa
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: isUploading ? null : onCoverTap,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isCoverSelected ? AppColors.primary : Colors.grey.shade700,
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.card,
                image: isCoverSelected
                    ? const DecorationImage(
                        image: NetworkImage('https://picsum.photos/200'),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: isCoverSelected
                  ? null
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 36, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Ảnh bìa\n(Cover)', textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Khung file mp3
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: isUploading ? null : onAudioTap,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isAudioSelected ? AppColors.primary : Colors.grey.shade700,
                  style: BorderStyle.solid,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.card,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isAudioSelected ? Icons.check_circle : Icons.cloud_upload_outlined,
                      size: 40,
                      color: isAudioSelected ? AppColors.primary : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAudioSelected ? 'master_final.mp3' : 'Chọn File Audio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isAudioSelected ? Colors.white : Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
