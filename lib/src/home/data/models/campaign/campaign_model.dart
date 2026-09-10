import 'package:kamao/src/home/domain/entities/campaign/campaign_entity.dart';

class CampaignModel extends CampaignEntity {
  CampaignModel({
    required super.id,
    required super.code,
    required super.name,
    required super.objective,
    required super.status,
    required super.currency,
    required super.startDateUtc,
    required super.endDateUtc,
    required super.startDateLocal,
    required super.endDateLocal,
    required super.participationMode,
    required super.performanceWindowHours,
    required super.purchaseProofRequired,
    required super.brandName,
    required super.creatorRewardBudget,
    required super.alreadyJoined,
    required super.brandId,
    required super.creatorMinReward,
    required super.creatorMaxReward,
    required super.isFavourite,
    required super.earnRangeLabel,
    super.brandLogoUrl,
    super.brandCoverUrl,
    super.brandCategory,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      objective: json['objective'] as String? ?? '',
      status: json['status'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      startDateUtc: DateTime.parse(json['startDateUtc'] as String),
      endDateUtc: json['endDateUtc'] != null
          ? DateTime.parse(json['endDateUtc'] as String)
          : null,
      startDateLocal: DateTime.parse(json['startDateLocal'] as String),
      endDateLocal: json['endDateLocal'] != null
          ? DateTime.parse(json['endDateLocal'] as String)
          : null,
      participationMode: json['participationMode'] as String? ?? '',
      performanceWindowHours:
          (json['performanceWindowHours'] as num?)?.toInt() ?? 0,
      purchaseProofRequired: json['purchaseProofRequired'] as bool? ?? false,
      brandName: json['brandName'] as String? ?? '',
      creatorRewardBudget:
          (json['creatorRewardBudget'] as num?)?.toDouble() ?? 0,
      alreadyJoined: json['alreadyJoined'] as bool? ?? false,
      brandId: json['brandId'] as String? ?? '',
      brandLogoUrl: json['brandLogoUrl'] as String?,
      brandCoverUrl: json['brandCoverUrl'] as String?,
      brandCategory: json['brandCategory'] as String?,
      creatorMinReward: (json['creatorMinReward'] as num?)?.toDouble() ?? 0,
      creatorMaxReward: (json['creatorMaxReward'] as num?)?.toDouble() ?? 0,
      isFavourite: json['isFavourite'] as bool? ?? false,
      earnRangeLabel: json['earnRangeLabel'] as String? ?? '',
    );
  }
}
