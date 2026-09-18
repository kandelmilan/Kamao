import 'package:equatable/equatable.dart';
import 'package:kamao/core/utils/campaign_platforms.dart';

class MarketplaceCampaignEntity extends Equatable {
  const MarketplaceCampaignEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.objective,
    required this.status,
    required this.currency,
    required this.startDateUtc,
    required this.endDateUtc,
    required this.startDateLocal,
    required this.endDateLocal,
    required this.participationMode,
    required this.performanceWindowHours,
    required this.purchaseProofRequired,
    required this.brandName,
    required this.creatorRewardBudget,
    required this.alreadyJoined,
    required this.brandId,
    required this.brandLogoUrl,
    required this.brandCoverUrl,
    required this.brandCategory,
    required this.creatorMinReward,
    required this.creatorMaxReward,
    required this.isFavourite,
    required this.earnRangeLabel,
    this.platforms = const [],
    this.contentTypes = const [],
  });

  final String id;
  final String code;
  final String name;
  final String objective;
  final String status;
  final String currency;
  final DateTime startDateUtc;
  final DateTime endDateUtc;
  final DateTime startDateLocal;
  final DateTime endDateLocal;
  final String participationMode;
  final int performanceWindowHours;
  final bool purchaseProofRequired;
  final String brandName;
  final num creatorRewardBudget;
  final bool alreadyJoined;
  final String brandId;
  final String? brandLogoUrl;
  final String? brandCoverUrl;
  final String brandCategory;
  final num creatorMinReward;
  final num creatorMaxReward;
  final bool isFavourite;
  final String earnRangeLabel;
  final List<String> platforms;
  final List<String> contentTypes;

  List<String> get displayPlatforms => resolveCampaignPlatforms(
        contentTypes: contentTypes,
        platforms: platforms,
        name: name,
        objective: objective,
      );

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        objective,
        status,
        currency,
        startDateUtc,
        endDateUtc,
        startDateLocal,
        endDateLocal,
        participationMode,
        performanceWindowHours,
        purchaseProofRequired,
        brandName,
        creatorRewardBudget,
        alreadyJoined,
        brandId,
        brandLogoUrl,
        brandCoverUrl,
        brandCategory,
        creatorMinReward,
        creatorMaxReward,
        isFavourite,
        earnRangeLabel,
        platforms,
        contentTypes,
      ];
}
