import 'package:kamao/core/utils/image_url_resolver.dart';

/// A connected-account post returned by `GET /creator/social/media`.
class SocialMediaItemEntity {
  const SocialMediaItemEntity({
    required this.platform,
    required this.externalPostId,
    required this.permalink,
    this.thumbnailUrl,
    this.caption,
    this.publishedAt,
  });

  final String platform;
  final String externalPostId;
  final String permalink;

  /// Raw thumbnail from the media API (absolute CDN URL or relative path).
  final String? thumbnailUrl;
  final String? caption;
  final DateTime? publishedAt;

  String get id => externalPostId;

  /// Absolute URL safe for [Image.network] / submit payload.
  String? get thumbnailImageUrl => resolveImageUrl(thumbnailUrl);
}

/// Response wrapper: `{ connected, warning, items }`.
class SocialMediaEntity {
  const SocialMediaEntity({
    required this.connected,
    this.warning,
    required this.items,
  });

  final bool connected;
  final String? warning;
  final List<SocialMediaItemEntity> items;
}
