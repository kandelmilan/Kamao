import 'package:kamao/core/core.dart';

class RewardedPostEntity {
  const RewardedPostEntity({
    required this.id,
    required this.platform,
    required this.contentUrl,
    this.thumbnailUrl,
    this.caption,
    required this.brandId,
    required this.brandName,
    this.brandLogoUrl,
    required this.campaignId,
    required this.campaignName,
    required this.payoutAmount,
    required this.currency,
    required this.postedAt,
  });

  final String id;
  final String platform;
  final String contentUrl;

  /// Relative path from the API — use [thumbnailImageUrl] to render it.
  final String? thumbnailUrl;
  final String? caption;
  final String brandId;
  final String brandName;
  final String? brandLogoUrl;
  final String campaignId;
  final String campaignName;
  final num payoutAmount;
  final String currency;
  final DateTime postedAt;

  String? get thumbnailImageUrl {
    final path = thumbnailUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${AppConstants.assetBaseUrl}$path';
  }

  String? get brandLogoImageUrl {
    final path = brandLogoUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${AppConstants.assetBaseUrl}$path';
  }
}
