import 'package:kamao/core/core.dart';

class BrandEntity {
  const BrandEntity({
    required this.id,
    required this.code,
    required this.name,
    this.logoUrl,
    this.coverImageUrl,
    this.categoryName,
    this.bio,
    required this.maxRewardAmount,
    required this.receiptRequired,
    required this.currency,
    required this.liveCampaignCount,
    required this.rewardedPostCount,
  });

  final String id;
  final String code;
  final String name;

  /// Relative path from the API (e.g. "/uploads/commerce/brands/xyz.png"),
  /// not a full URL — use [logoImageUrl] to render it.
  final String? logoUrl;
  final String? coverImageUrl;
  final String? categoryName;
  final String? bio;
  final num maxRewardAmount;
  final bool receiptRequired;
  final String currency;
  final int liveCampaignCount;
  final int rewardedPostCount;

  /// Full, directly-loadable logo URL. Joins [logoUrl] with
  /// AppConstants.assetBaseUrl (the bare host — NOT the /api/v1 API
  /// base the rest of the app calls through). Add that constant if it
  /// doesn't exist yet, or point this at whatever constant you already
  /// use for uploaded-asset hosts.
  String? get logoImageUrl {
    final path = logoUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${AppConstants.assetBaseUrl}$path';
  }

  String? get coverImageFullUrl {
    final path = coverImageUrl;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return '${AppConstants.assetBaseUrl}$path';
  }
}
