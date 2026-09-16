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
  final String? thumbnailUrl;
  final String? caption;
  final DateTime? publishedAt;

  String get id => externalPostId;
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
