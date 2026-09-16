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

  CampaignEntity copyWith({bool? alreadyJoined, bool? isFavourite}) {
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
    );
  }
}
