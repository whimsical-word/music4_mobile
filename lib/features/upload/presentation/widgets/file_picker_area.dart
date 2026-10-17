import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilePickerArea extends StatelessWidget {
  final bool isUploading;
  final File? coverFile;
  final File? audioFile;
  final String? audioFileName;
  final String? audioFileSize;
  final Duration? audioDuration;
  final VoidCallback onCoverTap;
  final VoidCallback onAudioTap;

  const FilePickerArea({
    super.key,
    required this.isUploading,
    this.coverFile,
    this.audioFile,
    this.audioFileName,
    this.audioFileSize,
    this.audioDuration,
    required this.onCoverTap,
    required this.onAudioTap,
  });

  String _formatDuration(Duration? d) {
    if (d == null) return '';
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final hasCover = coverFile != null;
    final hasAudio = audioFile != null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Khung ảnh bìa (Chuẩn tỷ lệ 3:4)
        SizedBox(
          width: 105,
          height: 140, // 105 / 140 = 3 / 4
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isUploading ? null : onCoverTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: hasCover ? AppColors.primary : Colors.grey.shade700,
                    width: hasCover ? 2 : 1.5,
                  ),
                  color: AppColors.card,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: hasCover
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              coverFile!,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                color: Colors.black.withValues(alpha: 0.65),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.crop, size: 12, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text('3:4 Đổi', style: TextStyle(fontSize: 10, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined, size: 32, color: Colors.grey),
                              SizedBox(height: 6),
                              Text(
                                'Ảnh bìa',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '(3:4)',
                                style: TextStyle(fontSize: 10, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Khung file audio
        Expanded(
          child: SizedBox(
            height: 140,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isUploading ? null : onAudioTap,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasAudio ? AppColors.primary : Colors.grey.shade700,
                      width: 2,
                    ),
                    color: AppColors.card,
                  ),
                  child: hasAudio
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, size: 24, color: AppColors.primary),
                                SizedBox(width: 6),
                                Text(
                                  'Đã chọn Audio',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              audioFileName ?? audioFile!.path.split(RegExp(r'[\\/]')).last,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${audioFileSize ?? ''}${audioDuration != null ? ' • ${_formatDuration(audioDuration)}' : ''}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Chạm để đổi file khác',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              size: 36,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Chọn File Audio',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'MP3, WAV, FLAC, M4A, AAC\n(Tối đa 10 phút, < 30MB)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

