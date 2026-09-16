import '../../domain/entities/social_media_entity.dart';

class SocialMediaItemModel extends SocialMediaItemEntity {
  const SocialMediaItemModel({
    required super.platform,
    required super.externalPostId,
    required super.permalink,
    super.thumbnailUrl,
    super.caption,
    super.publishedAt,
  });

  factory SocialMediaItemModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaItemModel(
      platform: json['platform'] as String? ?? '',
      externalPostId: json['externalPostId'] as String? ?? '',
      permalink: json['permalink'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      publishedAt: _parseDate(json['publishedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value);
  }
}

class SocialMediaModel extends SocialMediaEntity {
  const SocialMediaModel({
    required super.connected,
    super.warning,
    required super.items,
  });

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List<dynamic>?) ?? const [];
    return SocialMediaModel(
      connected: json['connected'] as bool? ?? false,
      warning: json['warning'] as String?,
      items: itemsJson
          .map((e) => SocialMediaItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
