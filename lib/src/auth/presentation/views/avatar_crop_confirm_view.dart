import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

/// Arrange a picked photo inside a circle, then confirm to export a cropped file.
/// Returns the exported file path via [Get.back], or null if cancelled.
class AvatarCropConfirmView extends StatefulWidget {
  const AvatarCropConfirmView({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<AvatarCropConfirmView> createState() => _AvatarCropConfirmViewState();
}

class _AvatarCropConfirmViewState extends State<AvatarCropConfirmView> {
  static const _accent = Color(0xFF4C5749);
  static const _cropSize = 280.0;

  final GlobalKey _cropKey = GlobalKey();
  final TransformationController _transform = TransformationController();
  bool _exporting = false;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_exporting) return;
    setState(() => _exporting = true);

    try {
      final boundary =
          _cropKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        Get.snackbar("Couldn't save photo", 'Please try again.');
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();

      if (byteData == null) {
        Get.snackbar("Couldn't save photo", 'Please try again.');
        return;
      }

      final bytes = byteData.buffer.asUint8List();
      final path = await _writeTempPng(bytes);
      Get.back(result: path);
    } catch (_) {
      Get.snackbar("Couldn't save photo", 'Please try again.');
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<String> _writeTempPng(Uint8List bytes) async {
    final dir = await Directory.systemTemp.createTemp('kamao_avatar_');
    final file = File(
      '${dir.path}/avatar_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Arrange photo',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            'Move and scale to fit the circle',
            style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                width: _cropSize,
                height: _cropSize,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft dim ring behind the crop
                    Container(
                      width: _cropSize + 16,
                      height: _cropSize + 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    RepaintBoundary(
                      key: _cropKey,
                      child: ClipOval(
                        child: ColoredBox(
                          color: Colors.black,
                          child: InteractiveViewer(
                            transformationController: _transform,
                            minScale: 1,
                            maxScale: 4,
                            panEnabled: true,
                            scaleEnabled: true,
                            boundaryMargin: const EdgeInsets.all(80),
                            child: Image.file(
                              File(widget.imagePath),
                              width: _cropSize,
                              height: _cropSize,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(
                                width: _cropSize,
                                height: _cropSize,
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IgnorePointer(
                      child: Container(
                        width: _cropSize,
                        height: _cropSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _exporting ? null : () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFF444444)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _exporting ? null : _confirm,
                      style: FilledButton.styleFrom(
                        backgroundColor: _accent,
                        disabledBackgroundColor:
                            _accent.withValues(alpha: 0.4),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _exporting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Confirm photo',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
