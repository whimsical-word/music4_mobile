import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Hộp thoại căn chỉnh, zoom và crop ảnh bìa theo tỷ lệ 3:4 (chuẩn Facebook/Instagram)
class ImageCropDialog extends StatefulWidget {
  final File rawImageFile;

  const ImageCropDialog({super.key, required this.rawImageFile});

  static Future<File?> show(BuildContext context, File rawImageFile) {
    return showDialog<File?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ImageCropDialog(rawImageFile: rawImageFile),
    );
  }

  @override
  State<ImageCropDialog> createState() => _ImageCropDialogState();
}

class _ImageCropDialogState extends State<ImageCropDialog> {
  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transformController = TransformationController();
  bool _isCropping = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  Future<void> _onConfirmCrop() async {
    if (_isCropping) return;
    setState(() => _isCropping = true);

    try {
      final boundary = _cropKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        Navigator.of(context).pop(widget.rawImageFile);
        return;
      }

      // Render vùng crop ra ảnh chất lượng cao
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (mounted) Navigator.of(context).pop(widget.rawImageFile);
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final croppedFile = File(
        '${tempDir.path}/cropped_cover_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await croppedFile.writeAsBytes(bytes);

      if (mounted) {
        Navigator.of(context).pop(croppedFile);
      }
    } catch (e) {
      debugPrint('Lỗi crop ảnh: $e');
      if (mounted) {
        Navigator.of(context).pop(widget.rawImageFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF181818),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Căn chỉnh ảnh bìa (3:4)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: _isCropping ? null : () => Navigator.of(context).pop(null),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Dùng 2 ngón tay hoặc cuộn chuột để phóng to/thu nhỏ, kéo ảnh vào đúng khung 3:4 đẹp nhất:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            // Khung ảnh 3:4
            Center(
              child: Container(
                width: 240,
                height: 320, // Tỷ lệ chuẩn 3:4
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: RepaintBoundary(
                    key: _cropKey,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: Colors.black),
                        InteractiveViewer(
                          transformationController: _transformController,
                          minScale: 0.5,
                          maxScale: 4.0,
                          panEnabled: true,
                          scaleEnabled: true,
                          child: Center(
                            child: Image.file(
                              widget.rawImageFile,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        // Lưới hướng dẫn mờ (Grid rule-of-thirds)
                        IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white24, width: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isCropping ? null : () => Navigator.of(context).pop(null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                    ),
                    child: const Text('Hủy'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isCropping ? null : _onConfirmCrop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                    ),
                    child: _isCropping
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                          )
                        : const Text('Xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
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
