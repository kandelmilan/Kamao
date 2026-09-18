import 'package:kamao/core/utils/campaign_platforms.dart';

class CampaignEntity {
  const CampaignEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.objective,
    required this.status,
    required this.currency,
    this.startDateUtc,
    this.endDateUtc,
    this.startDateLocal,
    this.endDateLocal,
    required this.participationMode,
    required this.performanceWindowHours,
    required this.purchaseProofRequired,
    required this.brandName,
    required this.creatorRewardBudget,
    required this.alreadyJoined,
    required this.brandId,
    required this.creatorMinReward,
    required this.creatorMaxReward,
    required this.isFavourite,
    required this.earnRangeLabel,
    this.brandLogoUrl,
    this.brandCoverUrl,
    this.brandCategory,
    this.platforms = const [],
    this.contentTypes = const [],
  });

  final String id;
  final String code;
  final String name;
  final String objective;
  final String status;
  final String currency;
  final DateTime? startDateUtc;
  final DateTime? endDateUtc;
  final DateTime? startDateLocal;
  final DateTime? endDateLocal;
  final String participationMode;
  final int performanceWindowHours;
  final bool purchaseProofRequired;
  final String brandName;
  final double creatorRewardBudget;
  final bool alreadyJoined;
  final String brandId;
  final String? brandLogoUrl;
  final String? brandCoverUrl;
  final String? brandCategory;
  final double creatorMinReward;
  final double creatorMaxReward;
  final bool isFavourite;
  final String earnRangeLabel;

  /// Raw platform labels from the API (e.g. `Instagram`, `TikTok`).
  final List<String> platforms;

  /// Content-type codes from the API (e.g. `IG_REEL`, `TT_VIDEO`, `FB_POST`).
  final List<String> contentTypes;

  /// Logos to show on cards — prefers content types (`IG`/`TT`/`FB`).
  List<String> get displayPlatforms => resolveCampaignPlatforms(
        contentTypes: contentTypes,
        platforms: platforms,
        name: name,
        objective: objective,
      );

  /// Human labels for cards, e.g. `IG_REEL` → `Instagram Reel`.
  String get contentTypeLabel => formatContentTypeLabels(contentTypes);

  CampaignEntity copyWith({
    bool? alreadyJoined,
    bool? isFavourite,
    List<String>? platforms,
    List<String>? contentTypes,
  }) {
    return CampaignEntity(
      id: id,
      code: code,
      name: name,
      objective: objective,
      status: status,
      currency: currency,
      startDateUtc: startDateUtc,
      endDateUtc: endDateUtc,
      startDateLocal: startDateLocal,
      endDateLocal: endDateLocal,
      participationMode: participationMode,
      performanceWindowHours: performanceWindowHours,
      purchaseProofRequired: purchaseProofRequired,
      brandName: brandName,
      creatorRewardBudget: creatorRewardBudget,
      alreadyJoined: alreadyJoined ?? this.alreadyJoined,
      brandId: brandId,
      brandLogoUrl: brandLogoUrl,
      brandCoverUrl: brandCoverUrl,
      brandCategory: brandCategory,
      creatorMinReward: creatorMinReward,
      creatorMaxReward: creatorMaxReward,
      isFavourite: isFavourite ?? this.isFavourite,
      earnRangeLabel: earnRangeLabel,
      platforms: platforms ?? this.platforms,
      contentTypes: contentTypes ?? this.contentTypes,
    );
  }
}
