import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/utils/image_url_resolver.dart';
import 'package:kamao/src/auth/presentation/controllers/auth_controller.dart';
import 'package:remixicon/remixicon.dart';

/// Circular avatar driven by `/auth/me` → [AuthController.avatarPath].
///
/// Uses [ClipOval] for the photo and draws the border on an outer ring so
/// the image stays a true circle (border+clip on one box often looks octagonal).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.size,
    this.initial,
    this.borderColor,
    this.borderWidth = 0,
    this.backgroundColor,
    this.fallbackIconSize,
  });

  final double size;
  final String? initial;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final double? fallbackIconSize;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final auth = Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : null;
      auth?.currentUser.value;
      final cacheKey = auth?.avatarCacheKey.value ?? 0;
      final url = resolveImageUrl(auth?.avatarPath);
      final displayUrl = url == null
          ? null
          : (cacheKey == 0
              ? url
              : '$url${url.contains('?') ? '&' : '?'}v=$cacheKey');

      final letter = (initial != null && initial!.trim().isNotEmpty)
          ? initial!.trim()[0].toUpperCase()
          : null;

      final photoSize = (size - borderWidth * 2).clamp(0.0, size);

      final photo = ClipOval(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: SizedBox(
          width: photoSize,
          height: photoSize,
          child: ColoredBox(
            color: backgroundColor ?? const Color(0xFFEDE6F1),
            child: displayUrl == null
                ? Center(child: _fallback(letter))
                : Image.network(
                    displayUrl,
                    key: ValueKey(displayUrl),
                    width: photoSize,
                    height: photoSize,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.medium,
                    errorBuilder: (_, __, ___) =>
                        Center(child: _fallback(letter)),
                  ),
          ),
        ),
      );

      if (borderWidth <= 0) {
        return SizedBox(width: size, height: size, child: photo);
      }

      return Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor ?? AppColors.white,
            width: borderWidth,
          ),
        ),
        child: photo,
      );
    });
  }

  Widget _fallback(String? letter) {
    if (letter != null) {
      return Text(
        letter,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: size * 0.36,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      );
    }
    return Icon(
      RemixIcons.user_3_fill,
      size: fallbackIconSize ?? size * 0.5,
      color: AppColors.primary,
    );
  }
}
