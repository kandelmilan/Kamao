import 'package:kamao/src/home/domain/entities/campaign/campaign_detail_entity.dart';

class CampaignBriefModel extends CampaignBriefEntity {
  const CampaignBriefModel({
    required super.campaignId,
    required super.title,
    required super.narrative,
    required super.includeSummary,
    required super.excludeSummary,
  });

  factory CampaignBriefModel.fromJson(Map<String, dynamic> json) {
    return CampaignBriefModel(
      campaignId: json['campaignId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      narrative: json['narrative'] as String?,
      includeSummary: json['includeSummary'] as String?,
      excludeSummary: json['excludeSummary'] as String?,
    );
  }
}

class CampaignDirectiveModel extends CampaignDirectiveEntity {
  const CampaignDirectiveModel({
    required super.id,
    required super.directiveType,
    required super.valueText,
    required super.isRequired,
    required super.sortOrder,
  });

  factory CampaignDirectiveModel.fromJson(Map<String, dynamic> json) {
    return CampaignDirectiveModel(
      id: json['id'] as String? ?? '',
      directiveType: json['directiveType'] as String? ?? '',
      valueText: json['valueText'] as String? ?? '',
      isRequired: json['isRequired'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }
}

class CampaignDetailModel extends CampaignDetailEntity {
  const CampaignDetailModel({
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
    required super.brief,
    required super.directives,
    required super.platforms,
  });

  /// [json] is the full `data` object: `{ campaign, brief, directives, platforms }`.
  factory CampaignDetailModel.fromJson(Map<String, dynamic> json) {
    final campaign = json['campaign'] as Map<String, dynamic>? ?? const {};
    final briefJson = json['brief'] as Map<String, dynamic>?;
    final directivesJson = json['directives'] as List<dynamic>? ?? const [];
    final platformsJson = json['platforms'] as List<dynamic>? ?? const [];

    DateTime? parseDate(dynamic value) =>
        value == null ? null : DateTime.tryParse(value as String);

    return CampaignDetailModel(
      id: campaign['id'] as String? ?? '',
      code: campaign['code'] as String? ?? '',
      name: campaign['name'] as String? ?? '',
      objective: campaign['objective'] as String? ?? '',
      status: campaign['status'] as String? ?? '',
      currency: campaign['currency'] as String? ?? '',
      startDateUtc: parseDate(campaign['startDateUtc']),
      endDateUtc: parseDate(campaign['endDateUtc']),
      startDateLocal: parseDate(campaign['startDateLocal']),
      endDateLocal: parseDate(campaign['endDateLocal']),
      participationMode: campaign['participationMode'] as String? ?? '',
      performanceWindowHours: (campaign['performanceWindowHours'] as num?)
          ?.toInt(),
      purchaseProofRequired:
          campaign['purchaseProofRequired'] as bool? ?? false,
      brandName: campaign['brandName'] as String? ?? '',
      creatorRewardBudget:
          (campaign['creatorRewardBudget'] as num?)?.toDouble() ?? 0,
      alreadyJoined: campaign['alreadyJoined'] as bool? ?? false,
      brandId: campaign['brandId'] as String? ?? '',
      brandLogoUrl: campaign['brandLogoUrl'] as String?,
      brandCoverUrl: campaign['brandCoverUrl'] as String?,
      brandCategory: campaign['brandCategory'] as String?,
      creatorMinReward: (campaign['creatorMinReward'] as num?)?.toDouble() ?? 0,
      creatorMaxReward: (campaign['creatorMaxReward'] as num?)?.toDouble() ?? 0,
      isFavourite: campaign['isFavourite'] as bool? ?? false,
      earnRangeLabel: campaign['earnRangeLabel'] as String? ?? '',
      brief: briefJson != null
          ? CampaignBriefModel.fromJson(briefJson)
          : CampaignBriefEntity(
              campaignId: campaign['id'] as String? ?? '',
              title: campaign['name'] as String? ?? '',
              narrative: null,
              includeSummary: null,
              excludeSummary: null,
            ),
      directives: directivesJson
          .map(
            (e) => CampaignDirectiveModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      platforms: platformsJson.map((e) => e.toString()).toList(),
    );
  }
}
