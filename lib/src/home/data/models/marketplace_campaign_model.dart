import 'package:kamao/src/home/domain/entities/marketplace_campaign_entity.dart';

class MarketplaceCampaignModel extends MarketplaceCampaignEntity {
  const MarketplaceCampaignModel({
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
    required super.brandLogoUrl,
    required super.brandCoverUrl,
    required super.brandCategory,
    required super.creatorMinReward,
    required super.creatorMaxReward,
    required super.isFavourite,
    required super.earnRangeLabel,
  });
  factory MarketplaceCampaignModel.fromJson(Map<String, dynamic> json) {
    return MarketplaceCampaignModel(
      id: json['id'] as String,
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      objective: json['objective'] as String? ?? '',
      status: json['status'] as String? ?? '',
      currency: json['currency'] as String? ?? '',
      startDateUtc: _parseDate(json['startDateUtc']),
      endDateUtc: _parseDate(json['endDateUtc']),
      startDateLocal: _parseDate(json['startDateLocal']),
      endDateLocal: _parseDate(json['endDateLocal']),
      participationMode: json['participationMode'] as String? ?? '',
      performanceWindowHours: json['performanceWindowHours'] as int? ?? 0,
      purchaseProofRequired: json['purchaseProofRequired'] as bool? ?? false,
      brandName: json['brandName'] as String? ?? '',
      creatorRewardBudget: json['creatorRewardBudget'] as num? ?? 0,
      alreadyJoined: json['alreadyJoined'] as bool? ?? false,
      brandId: json['brandId'] as String? ?? '',
      brandLogoUrl: json['brandLogoUrl'] as String?,
      brandCoverUrl: json['brandCoverUrl'] as String?,
      brandCategory: json['brandCategory'] as String? ?? '',
      creatorMinReward: json['creatorMinReward'] as num? ?? 0,
      creatorMaxReward: json['creatorMaxReward'] as num? ?? 0,
      isFavourite: json['isFavourite'] as bool? ?? false,
      earnRangeLabel: json['earnRangeLabel'] as String? ?? '',
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.parse(value as String);
  }
}
