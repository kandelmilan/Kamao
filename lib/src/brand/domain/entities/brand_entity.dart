import 'package:kamao/core/core.dart';
import 'package:kamao/core/utils/campaign_platforms.dart';

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
    this.platforms = const [],
    this.contentTypes = const [],
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

  /// Platform labels when the API sends them on brand cards.
  final List<String> platforms;

  /// Content-type codes (`IG`, `TT`, `FB`, `IG_REEL`, …) when present.
  final List<String> contentTypes;

  String? get logoImageUrl => resolveImageUrl(logoUrl);

  String? get coverImageFullUrl => resolveImageUrl(coverImageUrl);

  List<String> get displayPlatforms => resolveCampaignPlatforms(
        contentTypes: contentTypes,
        platforms: platforms,
      );

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
      platforms: platforms,
      contentTypes: contentTypes,
    );
  }
}
