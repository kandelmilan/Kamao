import '../../domain/entities/brand_profile_entity.dart';

class BrandProfileModel extends BrandProfileEntity {
  const BrandProfileModel({
    required super.id,
    required super.code,
    required super.name,
    super.description,
    super.logoUrl,
    super.coverImageUrl,
    super.aliases,
    super.bio,
    super.about,
    super.categoryName,
    super.websiteUrl,
    super.instagramHandle,
    super.tikTokHandle,
    super.youTubeHandle,
    super.facebookHandle,
    super.postTip1,
    super.postTip2,
    super.postTip3,
    required super.maxRewardAmount,
    required super.receiptRequired,
    required super.postsPer7Days,
    required super.postsPer12Months,
    required super.currency,
    required super.liveCampaignCount,
  });

  factory BrandProfileModel.fromJson(Map<String, dynamic> json) {
    return BrandProfileModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      aliases: json['aliases'] as String?,
      bio: json['bio'] as String?,
      about: json['about'] as String?,
      categoryName: json['categoryName'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      tikTokHandle: json['tikTokHandle'] as String?,
      youTubeHandle: json['youTubeHandle'] as String?,
      facebookHandle: json['facebookHandle'] as String?,
      postTip1: json['postTip1'] as String?,
      postTip2: json['postTip2'] as String?,
      postTip3: json['postTip3'] as String?,
      maxRewardAmount: (json['maxRewardAmount'] as num?) ?? 0,
      receiptRequired: json['receiptRequired'] as bool? ?? false,
      postsPer7Days: (json['postsPer7Days'] as num?)?.toInt() ?? 0,
      postsPer12Months: (json['postsPer12Months'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'NPR',
      liveCampaignCount: (json['liveCampaignCount'] as num?)?.toInt() ?? 0,
    );
  }
}