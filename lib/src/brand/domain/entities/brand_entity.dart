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
    this.isFavourite = false,
  });

  final String id;
  final String code;
  final String name;

  /// Relative path from the API — use [logoImageUrl] to render it.
  final String? logoUrl;
  final String? coverImageUrl;
  final String? categoryName;
  final String? bio;
  final num maxRewardAmount;
  final bool receiptRequired;
  final String currency;
  final int liveCampaignCount;
  final int rewardedPostCount;
  final bool isFavourite;

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

  BrandEntity copyWith({bool? isFavourite}) {
    return BrandEntity(
      id: id,
      code: code,
      name: name,
      logoUrl: logoUrl,
      coverImageUrl: coverImageUrl,
      categoryName: categoryName,
      bio: bio,
      maxRewardAmount: maxRewardAmount,
      receiptRequired: receiptRequired,
      currency: currency,
      liveCampaignCount: liveCampaignCount,
      rewardedPostCount: rewardedPostCount,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
