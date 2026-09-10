import '../../domain/entities/brand_entity.dart';

class BrandModel extends BrandEntity {
  const BrandModel({
    required super.id,
    required super.code,
    required super.name,
    super.logoUrl,
    super.coverImageUrl,
    super.categoryName,
    super.bio,
    required super.maxRewardAmount,
    required super.receiptRequired,
    required super.currency,
    required super.liveCampaignCount,
    required super.rewardedPostCount,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      categoryName: json['categoryName'] as String?,
      bio: json['bio'] as String?,
      maxRewardAmount: (json['maxRewardAmount'] as num?) ?? 0,
      receiptRequired: json['receiptRequired'] as bool? ?? false,
      currency: json['currency'] as String? ?? '',
      liveCampaignCount: (json['liveCampaignCount'] as num?)?.toInt() ?? 0,
      rewardedPostCount: (json['rewardedPostCount'] as num?)?.toInt() ?? 0,
    );
  }
}
