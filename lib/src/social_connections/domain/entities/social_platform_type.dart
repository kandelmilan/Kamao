import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:kamao/src/social_connections/domain/entities/social_platform.dart';

/// Platforms sent as `{platform}` on
/// `POST /creator/social/{platform}/start`.
enum SocialPlatformType {
  facebook('facebook'),
  instagram('instagram'),
  tiktok('tiktok'),
  youtube('youtube');

  const SocialPlatformType(this.apiId);
  final String apiId;

  /// Creator OAuth connect targets (Instagram / TikTok / Facebook).
  static const List<SocialPlatformType> connectable = [
    SocialPlatformType.instagram,
    SocialPlatformType.tiktok,
    SocialPlatformType.facebook,
  ];

  static SocialPlatformType? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final id = raw.toLowerCase();
    for (final platform in values) {
      if (platform.apiId == id) return platform;
    }
    return null;
  }

  String get displayName {
    switch (this) {
      case SocialPlatformType.facebook:
        return 'Facebook';
      case SocialPlatformType.instagram:
        return 'Instagram';
      case SocialPlatformType.tiktok:
        return 'TikTok';
      case SocialPlatformType.youtube:
        return 'YouTube';
    }
  }

  IconData get icon {
    switch (this) {
      case SocialPlatformType.facebook:
        return RemixIcons.facebook_fill;
      case SocialPlatformType.instagram:
        return RemixIcons.instagram_fill;
      case SocialPlatformType.tiktok:
        return RemixIcons.tiktok_fill;
      case SocialPlatformType.youtube:
        return RemixIcons.youtube_fill;
    }
  }

  SocialPlatform toUiPlatform() {
    switch (this) {
      case SocialPlatformType.facebook:
        return SocialPlatform(
          id: apiId,
          name: displayName,
          icon: icon,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFF1877F2),
        );
      case SocialPlatformType.instagram:
        return SocialPlatform(
          id: apiId,
          name: displayName,
          icon: icon,
          iconColor: Colors.white,
          backgroundGradient: const [
            Color(0xFFFED576),
            Color(0xFFF47133),
            Color(0xFFBC3081),
            Color(0xFF4F5BD5),
          ],
        );
      case SocialPlatformType.tiktok:
        return SocialPlatform(
          id: apiId,
          name: displayName,
          icon: icon,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFF010101),
        );
      case SocialPlatformType.youtube:
        return SocialPlatform(
          id: apiId,
          name: displayName,
          icon: icon,
          iconColor: Colors.white,
          backgroundColor: const Color(0xFFE02020),
          notConnectedLabel: 'Optional — public stats use the tenant API key',
        );
    }
  }
}
