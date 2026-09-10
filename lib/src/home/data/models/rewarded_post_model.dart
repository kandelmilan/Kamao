import '../../domain/entities/rewarded_post_entity.dart';

class RewardedPostModel extends RewardedPostEntity {
  const RewardedPostModel({
    required super.id,
    required super.platform,
    required super.contentUrl,
    super.thumbnailUrl,
    super.caption,
    required super.brandId,
    required super.brandName,
    super.brandLogoUrl,
    required super.campaignId,
    required super.campaignName,
    required super.payoutAmount,
    required super.currency,
    required super.postedAt,
  });

  factory RewardedPostModel.fromJson(Map<String, dynamic> json) {
    return RewardedPostModel(
      id: json['id'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
      contentUrl: json['contentUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String?,
      caption: json['caption'] as String?,
      brandId: json['brandId'] as String? ?? '',
      brandName: json['brandName'] as String? ?? '',
      brandLogoUrl: json['brandLogoUrl'] as String?,
      campaignId: json['campaignId'] as String? ?? '',
      campaignName: json['campaignName'] as String? ?? '',
      payoutAmount: (json['payoutAmount'] as num?) ?? 0,
      currency: json['currency'] as String? ?? '',
      postedAt:
          DateTime.tryParse(json['postedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
